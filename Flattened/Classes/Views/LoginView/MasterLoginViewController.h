//
//  MasterLoginViewController.h
//  Flattened
//
//  Created by Diego Maye on 07/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UIView *toolbarView;

- (void)showAlert:(NSString*)title andMessage:(NSString*)message;

-(void) upTextField:(UITextField *) textField focusOn:(UITextField*) focus;

-(void) downField:(UITextField*) textField withSpace:(NSNumber*) space;

-(void) agregarEspacioInterno:(UITextField*) textField;

-(void) customizationUIDatePickerUITextView:(UITextField*)text withButtonDescription:(NSString*) buttonDescription;

//Loading Components
- (void) showProgressBar;
- (void) setComplete;
- (void) setCompleteError;
- (void) setCompleteErrorSorry;
- (void) setProgressBar;

@end
