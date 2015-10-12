//
//  LVModalQueueTests.m
//  LVModalQueueTests
//
//  Created by Michael Berg on 10/12/2015.
//  Copyright (c) 2015 Michael Berg. All rights reserved.
//

@import XCTest;

@interface Tests : XCTestCase

@property (nonatomic, strong) UIWindow *window;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *rootViewController = [[UIViewController alloc] init];
    self.window.rootViewController = rootViewController;
    
    self.window.hidden = NO;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.window.hidden = YES;
    self.window.rootViewController = nil;
    self.window = nil;
    
    [super tearDown];
}

- (void)testViewControllerQueuing
{
    UIViewController *rootViewController = self.window.rootViewController;
    
    XCTestExpectation *presentationExpectation1 = [self expectationWithDescription:@"Presentation 1 should be successful."];
    XCTestExpectation *presentationExpectation2 = [self expectationWithDescription:@"Presentation 2 should be successful."];
    XCTestExpectation *presentationExpectation3 = [self expectationWithDescription:@"Presentation 3 should be successful."];
    XCTestExpectation *presentationExpectation4 = [self expectationWithDescription:@"Presentation 4 should be successful."];
    
    XCTestExpectation *dismissExpectation1 = [self expectationWithDescription:@"Dismiss 1 should be successful."];
    XCTestExpectation *dismissExpectation2 = [self expectationWithDescription:@"Dismiss 2 should be successful."];
    XCTestExpectation *dismissExpectation3 = [self expectationWithDescription:@"Dismiss 3 should be successful."];
    XCTestExpectation *dismissExpectation4 = [self expectationWithDescription:@"Dismiss 4 should be successful."];
    
    UIViewController *controller1 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *controller2 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *controller3 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *controller4 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    
    // set title for easier debugging
    rootViewController.title = @"Root Controller";
    controller1.title = @"Controller 1";
    controller2.title = @"Controller 2";
    controller3.title = @"Controller 3";
    controller4.title = @"Controller 4";
    
    // delay presentation methods to avoid unbalanced animations, when presenting view controllers in rootViewController viewDidLoad
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       // present the first controller
                       [rootViewController presentViewController:controller1 animated:YES completion:^
                        {
                            /*
                             - root
                                - controller1
                             */
                            
                            [presentationExpectation1 fulfill];
                        }];
                       
                       // queue the next presentation
                       [rootViewController presentViewController:controller2 animated:YES completion:^
                        {
                            /*
                             - root
                                - controller1
                                    - controller2
                             */
                            
                            [presentationExpectation2 fulfill];
                        }];
                       
                       // test, if the extension loops through presentedViewControllers, until it finds the current visible one
                       [controller1 presentViewController:controller4 animated:YES completion:^
                        {
                            /*
                             - root
                                - controller1
                                    - controller2
                                        - controller4
                             */
                            
                            [presentationExpectation4 fulfill];
                        }];
                       
                       // unanimated dismiss should also work
                       [controller4 dismissViewControllerAnimated:NO completion:^
                        {
                            /*
                             - root
                                - controller1
                                    - controller2
                             */
                            
                            [dismissExpectation4 fulfill];
                        }];
                       
                       // test dismiss queuing
                       [controller2 dismissViewControllerAnimated:YES completion:^
                        {
                            /*
                             - root
                                - controller1
                             */
                            
                            [dismissExpectation1 fulfill];
                        }];
                       
                       // presenting from a view controller, that is not in the hierarchy anymore should no block the queue
                       [controller2 presentViewController:controller3 animated:YES completion:^
                       {
                           // this should never be reached, as viewController2 is not in the hierarchy
                       }];
                       
                       // unanimated presentation
                       [controller1 presentViewController:controller3 animated:NO completion:^
                        {
                            /*
                             - root
                                - controller1
                                    - controller3
                             */
                            
                            [presentationExpectation3 fulfill];
                        }];
                       
                       // unanimated dismissing
                       [controller1 dismissViewControllerAnimated:NO completion:^
                        {
                            /*
                             - root
                                - controller1
                             */
                            
                            [dismissExpectation2 fulfill];
                        }];
                       
                       /**
                        *  A Controller without presenting and persentedViewController should not break the chain
                        */
                       [controller3 dismissViewControllerAnimated:YES completion:^
                        {
                            // this should never be reached, as viewController3 is not in the hierarchy
                            
                        }];
                       
                       // and back to root
                       [controller1 dismissViewControllerAnimated:YES completion:^
                        {
                            /*
                             - root
                             */
                            
                            [dismissExpectation3 fulfill];
                        }];
                   });
    
    [self waitForExpectationsWithTimeout:100.0 handler:nil];
}

@end