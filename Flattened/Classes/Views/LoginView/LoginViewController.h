//
//  LoginViewController.h
//  Flattened
//
//  Created by Diego Maye on 15/11/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MasterLoginViewController.h"

#import "Enums.h"

@interface LoginViewController : MasterLoginViewController<FBLoginViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet FBLoginView *FBLoginView;
@property (weak, nonatomic) IBOutlet UIButton *btnVolver;
@property (weak, nonatomic) IBOutlet UIButton *btnAceptar;
@property (weak, nonatomic) IBOutlet UITextField *txtCorreo;
@property (weak, nonatomic) IBOutlet UIButton *btnAccessWithAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblYouDont;

@end
