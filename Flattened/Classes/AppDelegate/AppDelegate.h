//
//  AppDelegate.h
//
//  Created by Valentin Filip on 11/7/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MenuViewController.h"
#import "LoginViewController.h"
#import "Enums.h"
#import "Usuario.h"
@class PaperFoldNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, MenuViewControllerDelegate>

- (void) closeSession;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabbarVC;
@property (strong, nonatomic) PaperFoldNavigationController *foldVC;
@property (strong, nonatomic) MenuViewController *menuVC;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) UIViewController *mainVC;
@property (assign, nonatomic) ADVNavigationType navigationType;
@property (nonatomic) BOOL userLogged;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIBarButtonItem *barButtonFromMaster;
@property (strong, nonatomic) UIBarButtonItem *barButtonForDetail;

+ (AppDelegate *)sharedDelegate;
+ (void)customizeTabsForController:(UITabBarController *)tabVC;
+ (Usuario *) getUsuario;
- (void)togglePaperFold:(id)sender;
- (void)resetAfterTypeChange:(BOOL)cancel;
- (void)showMenuiPad:(id)sender;
- (void)selectWhatKindOfSetup;

@end
