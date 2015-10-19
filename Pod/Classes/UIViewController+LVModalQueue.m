//
//  UIViewController+LVPresentationQueueing.m
//  LOVOO
//
//  Created by Michael Berg on 23.09.15.
//  Copyright © 2015 LOVOO GmbH. All rights reserved.
//

#import "UIViewController+LVModalQueue.h"
#import <objc/runtime.h>


typedef void (^LVQueueTransitionBlock)(void);

static const NSMutableArray <LVQueueTransitionBlock> *transitionQueue;
static BOOL isTransitioning = NO;
static NSUInteger transitionCount = 0;


@implementation UIViewController (LVModalQueue)

/**
 *  We hook into presentViewController:animated:completion and dismissViewControllerAnimated:completion: to queue the transition for later, if a transition is currently going on
 */
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        Class class = [self class];

        // exchange presentViewController implementations
        Method originalPresentMethod = class_getInstanceMethod(class, @selector(presentViewController:animated:completion:));
        Method queuePresentMethod = class_getInstanceMethod(class, @selector(lv_queuePresentViewController:animated:completion:));

        method_exchangeImplementations(originalPresentMethod, queuePresentMethod);

        // exchange dismissViewController implementations
        Method originalDismissMethod = class_getInstanceMethod(class, @selector(dismissViewControllerAnimated:completion:));
        Method queueDismissMethod = class_getInstanceMethod(class, @selector(lv_queueDismissViewControllerAnimated:completion:));

        method_exchangeImplementations(originalDismissMethod, queueDismissMethod);
      });
}

/**
 *  custom implementation of presentViewController. Creates a transition block, that can be queued for later in case a view controller is currently transitioning
 */
- (void)lv_queuePresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [UIViewController lv_performTransition:^{
        UIViewController *presenter = [self lv_topmostPresentedViewController];
        
        // if there is no presenter, we should not block the queue
        if (!presenter)
        {
            [UIViewController lv_dequeueTransition];
            
            return;
        }
        
        [self lv_transitionWillStart];
        
        // because we swizzled the implementations, this will call the original implementation
        [presenter lv_queuePresentViewController:viewControllerToPresent animated:flag completion:[UIViewController lv_queueBlockWithCompletionBlock:completion animated:flag]];
    }];
}

/**
 *  custom implementation of dismissViewController. Creates a transition block, that can be queued for later in case a view controller is currently transitioning
 */
- (void)lv_queueDismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [UIViewController lv_performTransition:^{
        [self lv_transitionWillStart];

        // we don't want to break presentations, if someone decides to dismiss a view controller, that is not in the view hierarchy.
        if (!self.presentingViewController && !self.presentedViewController)
        {
            // call the original dismiss method anyway, to let UIKit decide, wether to call the completion block or not.
            [self lv_queueDismissViewControllerAnimated:flag completion:completion];
            [UIViewController lv_transitionDidComplete];
            
            return;
        }

        // because we swizzled the implementations, this will call the original implementation
        [self lv_queueDismissViewControllerAnimated:flag completion:[UIViewController lv_queueBlockWithCompletionBlock:completion animated:flag]];
    }];
}


#pragma mark - Queueing

/**
 *  When we start the transition, we save an instance of the viewcontroller.
 *  FAILOVER: If the currentViewController is still the same after 1 second (could happen, if completion block is not called for some reason), we reset isTransitioning
 */
- (void)lv_transitionWillStart
{
    ++transitionCount;
    isTransitioning = YES;
    
    NSUInteger currentTransitionCount = transitionCount;
    
    //Failover. If the transtionCount has not changed after one second, we reset isTransitioning
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if (currentTransitionCount == transitionCount)
        {
            isTransitioning = NO;
        }
    });
}

/**
 *  performs a transition or queues it for later
 *
 *  @param transitionBlock the transition block
 */
+ (void)lv_performTransition:(LVQueueTransitionBlock)transitionBlock
{
    // if transition is ongoing, queue it for later
    if (!isTransitioning)
    {
        transitionBlock();
    }
    else
    {
        if (!transitionQueue)
        {
            transitionQueue = [NSMutableArray array];
        }
        
        [transitionQueue addObject:[transitionBlock copy]];
    }
}

/**
 *  Performs the next transition, if there is any
 */
+ (void)lv_dequeueTransition
{
    if (transitionQueue.count == 0)
    {
        isTransitioning = NO;
        return;
    }
    
    // pop oldest block from queue
    LVQueueTransitionBlock transitionBlock = [transitionQueue firstObject];
    [transitionQueue removeObjectAtIndex:0];
    
    // perform the transition
    transitionBlock();
}

/**
 *  Notifies the queuing system, that the transition did finish
 */
+ (void)lv_transitionDidComplete
{
    // NOTE: unfortunately we have to delay the next presentation. Calling dismiss from a presentations completion-block crashes. Using the transitioningCoordinaters animateAlongsideTransitions completion Block always crashes in some rare cases, when using custom transitions
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self lv_dequeueTransition];
    });
}

/**
 *  This creates a block, that contains the original completion block. If the completion is called, we notify the queuing system, that the transition did complete
 *
 *  @param completion the original completion block
 *  @param animated   animated transition or not?
 */
+ (void (^)(void))lv_queueBlockWithCompletionBlock:(void (^)(void))completion animated:(BOOL)animated
{
    // if the transition is not animated, than immediatly complete the transition (we can call this before completion is even started, because the next transition is delayed on the mainthread)
    if (!animated)
    {
        [UIViewController lv_transitionDidComplete];
        return completion;
    }
    
    return ^
    {
        if(completion)
        {
            completion();
        }
        
        [UIViewController lv_transitionDidComplete];
    };
}


#pragma mark - Fetch top view controller

/*!
 *  Because we delay the transitions, it could happen, that the original controller, that wants to present the view controller is not in the view hierarchy anymore. Therefore we have to find the controller, that is currently presented.
 *
 *  @return The topmost presented view controller
 *
 *  @since 0.1.0
 */
- (UIViewController *)lv_topmostPresentedViewController
{
    // if view controller is not in the hierarchy (and not the rootViewController), we should return nil
    if (self.presentedViewController == nil && self.presentingViewController == nil && ![self lv_isRootViewController])
    {
        return nil;
    }
    
    UIViewController *viewController = self;

    if (viewController.presentedViewController)
    {
        // iterate through modal view controllers if available
        while (viewController.presentedViewController)
        {
            viewController = viewController.presentedViewController;
        }
    }
    
    return viewController;
}

/*!
 *  Checks, if the view controller is the root view controller
 *
 *  @return YES, if it is the rootViewController, otherwise no.
 *
 *  @since 0.1.0
 */
- (BOOL)lv_isRootViewController
{
    return self.isViewLoaded && self.view.window.rootViewController == self;
}

@end