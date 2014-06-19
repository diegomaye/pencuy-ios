//
//  MasterViewController.h
//  
//
//  Created by Valentin Filip on 6/1/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController <UISplitViewControllerDelegate>
@property (strong,nonatomic)UIButton* menuButton;
- (void) showProgressBar;
- (void) setComplete;
- (void) setCompleteError;
- (void) setCompleteErrorSorry;
- (void) setProgressBar;

@end
