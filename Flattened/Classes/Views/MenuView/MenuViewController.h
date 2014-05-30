//
//  MenuViewController.h
//  
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol MenuViewControllerDelegate;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) id<MenuViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *facebookImageView;

@end

@protocol MenuViewControllerDelegate <NSObject>

- (void)userDidSwitchToControllerAtIndexPath:(NSIndexPath*)index;

@end