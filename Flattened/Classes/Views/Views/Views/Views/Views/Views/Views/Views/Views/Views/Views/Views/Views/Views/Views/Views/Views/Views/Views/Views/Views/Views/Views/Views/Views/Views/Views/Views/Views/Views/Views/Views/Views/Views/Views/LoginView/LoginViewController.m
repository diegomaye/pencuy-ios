//
//  LoginViewController.m
//  Flattened
//
//  Created by Diego Maye on 15/11/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTabBarViewController.h"
#import "AppDelegate.h"
#import "PencuyFetcher.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsuario;
@property (weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation LoginViewController

- (IBAction)touchLogin:(id)sender {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_txtUsuario setDelegate:self];
    [_txtPass setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"GoToTheApp"]){
        return [self validateUserAndPassword];
    }
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToTheApp"]){
        
        if ([segue.destinationViewController isKindOfClass:[CustomTabBarViewController class]]) {
            
            AppDelegate *delegate= [AppDelegate sharedDelegate];
            [delegate selectWhatKindOfSetup];
            [self.spinner stopAnimating];
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == _txtUsuario) {
        [_txtPass becomeFirstResponder];
    }
    else if (textField == _txtPass){
        if ([_txtUsuario.text isEqualToString:@""]) {
            [_btnLogin becomeFirstResponder];
        }
        else{
            //Ver de hacer logueo automatico cuando el usuario tiene los datos completos.
            //[self performSegueWithIdentifier:@"GoToTheApp" sender:self];
            [_btnLogin becomeFirstResponder];
        }
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark validacion de usuario

-(BOOL)validateUserAndPassword{
    
    if (![self validateUserAndPasswordRequest]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Perdón!"
                                                            message:@"Has ingresado mal tu usuario o tu contraseña, intenta nuevamente"
                                                           delegate:nil cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
        [alertView show];
        [self.spinner stopAnimating];
        return NO;
    }
    [self.spinner stopAnimating];
    return YES;
}

-(BOOL)validateUserAndPasswordRequest{

    [self.spinner startAnimating];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[PencuyFetcher URLtoCheckUser]];
    NSURLResponse *response= nil;
    NSError *error= nil;
    NSLog(@"Disparando llamada sincronico");
    NSDictionary *eventLocation = [NSDictionary dictionaryWithObjectsAndKeys:self.txtUsuario.text,@"email",self.txtPass.text,@"password", nil];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:eventLocation
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSLog(@"jsonRequest is %@", requestData);
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    NSData *jsonResults= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *propertyListResults= [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
    
    if ([propertyListResults valueForKey:@"password"]) {
        return YES;
    }
    return NO;
}

#pragma mark Animación de los textFields

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _txtUsuario) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _txtUsuario.frame = CGRectMake(_txtUsuario.frame.origin.x, (_txtUsuario.frame.origin.y - 100.0), _txtUsuario.frame.size.width, _txtUsuario.frame.size.height);
        [UIView commitAnimations];
    } else if (textField == _txtPass) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _txtPass.frame = CGRectMake(_txtPass.frame.origin.x, (_txtUsuario.frame.origin.y - 100.0), _txtPass.frame.size.width, _txtPass.frame.size.height);
        [UIView commitAnimations];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _txtUsuario) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _txtUsuario.frame = CGRectMake(_txtUsuario.frame.origin.x, (_txtUsuario.frame.origin.y + 100.0), _txtUsuario.frame.size.width, _txtUsuario.frame.size.height);
        [UIView commitAnimations];
    } else if (textField == _txtPass) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _txtPass.frame = CGRectMake(_txtPass.frame.origin.x, (_txtPass.frame.origin.y + (50) + 100.0), _txtPass.frame.size.width, _txtPass.frame.size.height);
        [UIView commitAnimations];
    }
}

/*
- (void)actionHideKeys:(id)sender {
    [_textBody resignFirstResponder];
    if (_fullScreen) {
        _fullScreen = NO;
        [((UIButton *)[_toolbarView viewWithTag:123]) setImage:[UIImage imageNamed:@"list-item-detail-max"] forState:UIControlStateNormal];
        
        CGRect frameHeader = _headerView.frame;
        frameHeader.origin.y = 0;
        _headerView.frame = frameHeader;
        
        CGRect frameBody = _textBody.frame;
        frameBody.origin.y = frameHeader.size.height + 5;
        frameBody.size.height = frameBody.size.height - frameHeader.size.height;
        _textBody.frame = frameBody;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
*/
@end
