//
//  MasterViewController.m
//  
//
//  Created by Valentin Filip on 6/1/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "M13ProgressHUD.h"
#import "M13ProgressViewRing.h"

@interface MasterViewController (){
    M13ProgressHUD *HUD;
}



@end

@implementation MasterViewController

- (void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self) {
        [self setProgressBar];
    }
}

-(void) showProgressBar{
    [self.menuButton setEnabled:NO];
    [HUD setIndeterminate:YES];
    HUD.status = NSLocalizedString(@"Loading",nil);
    [HUD show:YES];
}

-(void) setProgressBar{
    HUD = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
    HUD.layer.zPosition = 3;
    HUD.progressViewSize = CGSizeMake(60.0, 60.0);
    HUD.animationPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [window addSubview:HUD];
    [HUD setShouldAutorotate:NO];
    [HUD setApplyBlurToBackground:YES];
    [HUD setMaskType:M13ProgressHUDMaskTypeGradient];
}

- (void)setComplete
{
    HUD.status = NSLocalizedString(@"Finishing Processing",nil);
    //[HUD setStatusPosition:M13ProgressHUDStatusPositionRightOfProgress];
    [HUD setIndeterminate:NO];
    [HUD performAction:M13ProgressViewActionSuccess animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1];
}

- (void)setCompleteError
{
    HUD.status = NSLocalizedString(@"A connection error happened apology",nil);
    //[HUD setStatusPosition:M13ProgressHUDStatusPositionRightOfProgress];
    [HUD setIndeterminate:NO];
    [HUD performAction:M13ProgressViewActionFailure animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1.5];
}

- (void)setCompleteErrorSorry
{
    HUD.status = NSLocalizedString(@"Sorry, something wrong happened, try again",nil);
    //[HUD setStatusPosition:M13ProgressHUDStatusPositionRightOfProgress];
    [HUD setIndeterminate:NO];
    [HUD performAction:M13ProgressViewActionFailure animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:2];
}

- (void)reset
{
    [HUD hide:YES];
    [HUD performAction:M13ProgressViewActionNone animated:NO];
    [self.menuButton setEnabled:YES];
    //UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    //[HUD removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([AppDelegate sharedDelegate].barButtonForDetail != nil) {
            self.navigationItem.leftBarButtonItem = [AppDelegate sharedDelegate].barButtonForDetail;
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 40, 30);
    [menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
    [menuButton addTarget:appDelegate action:@selector(showMenuiPad:) forControlEvents:UIControlEventTouchUpInside];
    appDelegate.barButtonFromMaster = barButtonItem;
    appDelegate.barButtonForDetail = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    [self.navigationItem setLeftBarButtonItem:[AppDelegate sharedDelegate].barButtonForDetail animated:YES];
    appDelegate.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    [AppDelegate sharedDelegate].barButtonForDetail = nil;
    [AppDelegate sharedDelegate].masterPopoverController = nil;
}


@end
