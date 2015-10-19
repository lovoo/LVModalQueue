//
//  UIViewController+LVModalQueue.h
//  LOVOO
//
//  Created by Michael Berg on 23.09.15.
//  Copyright © 2015 LOVOO GmbH. All rights reserved.
//

@import UIKit;

/**
 *  This Category makes sure, that no transitions can be presented simultaniously. If a transition is ongoing, the transition will be queued for later execution
 */
@interface UIViewController (LVModalQueue)

@end
