//
//  LVViewController.m
//  LVModalQueue
//
//  Created by Michael Berg on 10/12/2015.
//  Copyright (c) 2015 Michael Berg. All rights reserved.
//

#import "LVViewController.h"

@interface LVViewController ()

@end

@implementation LVViewController

- (IBAction)delayedPresentViewController:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LVDetailViewController"];
        [self presentViewController:controller animated:YES completion:nil];
    });
}

@end
