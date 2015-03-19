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
#import "FileManager.h"
#import "Utils.h"
#import "Usuario.h"
#import "RandomManager.h"
#import "FacebookImageStorage.h"
#import "ImageManager.h"
#import "Validator.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property(strong, nonatomic) Usuario* usuarioFacebook;

@end


@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        [self setProgressBar];
    }
    self.FBLoginView.delegate= self;
    self.FBLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    //NSString* dimensions= [Utils dimensionesPantalla];
//    if ([dimensions isEqualToString:@"320x568"]) {
//        dimensions = [NSString stringWithFormat:@"640x1136"];
//    }
//    NSString* pathLocatario = [[NSBundle mainBundle] pathForResource:[@"Dawn-" stringByAppendingString:dimensions] ofType:@"jpg"];
//    _backImage.image = [UIImage imageWithContentsOfFile:pathLocatario];
    
    [_txtCorreo setDelegate:self];
    [self agregarEspacioInterno:_txtCorreo];
    self.lblYouDont.text = NSLocalizedString(@"You don't have a Facebook account?", nil);
    [self.btnAccessWithAccount setTitle:NSLocalizedString(@"You can access here!", nil) forState:UIControlStateNormal];
    [self.btnAceptar setTitle:NSLocalizedString(@"ACCEPT", nil) forState:UIControlStateNormal];
    [self.btnVolver setTitle:NSLocalizedString(@"RETURN", nil) forState:UIControlStateNormal];
    self.txtCorreo.placeholder = NSLocalizedString(@"E-Mail",nil);
    self.toolbarView.hidden=YES;

}

- (void)viewDidUnload {
    //[self setFBLoginView:nil];
    [super viewDidUnload];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.toolbarView.hidden = NO;
    if (textField == _txtCorreo) {
        [self upTextField:_txtCorreo focusOn:_txtCorreo];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _txtCorreo) {
        [self downField:_txtCorreo withSpace:[NSNumber numberWithInt:0]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark fadeIn fadeOut para los controles cuando el usuario se loguea.

-(void)pedirCorreo{
    [UIView animateWithDuration:0.5 animations:^{
        _FBLoginView.alpha = 0;
        _btnAccessWithAccount.alpha = 0;
        _lblYouDont.alpha = 0;
    } completion: ^(BOOL finished) {
        _FBLoginView.hidden = finished;
        _btnAccessWithAccount.hidden = finished;
        _lblYouDont.hidden = finished;
        
        _btnAceptar.alpha = 0;
        _btnAceptar.hidden = NO;
        _btnVolver.alpha = 0;
        _btnVolver.hidden = NO;
        _txtCorreo.alpha = 0;
        _txtCorreo.hidden = NO;
        [UIView animateWithDuration:0.8 animations:^{
            _btnAceptar.alpha = 1;
            _btnVolver.alpha = 1;
            _txtCorreo.alpha = 1;
        }];
    }];
}

-(void)volver{
    [UIView animateWithDuration:0.5 animations:^{
        _btnAceptar.alpha = 0;
        _btnVolver.alpha = 0;
        _txtCorreo.alpha = 0;
    } completion: ^(BOOL finished) {
        _btnAceptar.hidden = finished;
        _btnVolver.hidden = finished;
        _txtCorreo.hidden = finished;
        
        _FBLoginView.alpha = 0;
        _FBLoginView.hidden = NO;
        _btnAccessWithAccount.alpha = 0;
        _btnAccessWithAccount.hidden = NO;
        _lblYouDont.alpha = 0;
        _lblYouDont.hidden = NO;
        [UIView animateWithDuration:0.8 animations:^{
            _FBLoginView.alpha = 1;
            _btnAccessWithAccount.alpha = 1;
            _lblYouDont.alpha = 1;
        }];
    }];
}

#pragma mark Facebook delegates
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
        //[self performSegueWithIdentifier: @"StartWithFacebook" sender: self];
        //[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"];
    [self showProgressBar];
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (!error) {
                if (![[NSUserDefaults standardUserDefaults] valueForKey:@"USUARIO-PENCA"] ) {
                    NSString *randomKey = [RandomManager getRandomAphanumeric:10];
                    Usuario* usuario= [Usuario new];
                    [usuario setNombreCompleto:user.name];
                    [usuario setNombre:user.first_name];
                    [usuario setApellido:user.last_name];
                    
                    [usuario setMasculino:[user objectForKey:@"gender"]];
                    [usuario setFaceID:user.objectID];
                    NSString *token =  [[[FBSession activeSession] accessTokenData] accessToken];
                    [usuario setPassword:randomKey];
                    [usuario setRePassword:randomKey];
                    [usuario setApnsDeviceToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"DEVICE-TOKEN" ]];
                    [usuario setLastDevAppleModelUsed:[Utils machineName]];
                    [usuario setLastDevApple:[Utils isVersion6AndBelow]?@"IOS6orLess":@"IOS7.X"];
                    [usuario setFacebookToken:token];
                    [usuario setCuentaFacebook:YES];
                    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                    [usuario setLocale:language];
                    
                    _usuarioFacebook = usuario;
                    if ([user objectForKey:@"email"]) {
                        [usuario setEmail:[user objectForKey:@"email"]];
                        [self shootLoginFacebook:usuario];
                    }
                    else{
                        [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
                        [self pedirCorreo];
                    }
                }
                else{
                    [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
                    AppDelegate *delegate= [AppDelegate sharedDelegate];
                    [delegate selectWhatKindOfSetupWithoutSet];
                    //[self performSegueWithIdentifier: @"StartWithFacebook" sender:self];
                }
//                NSString* username = user.name;
//                NSString* email = [user objectForKey:@"email"];
//                NSLog(@"nombre y correo: %@, %@", username, email);
            }
        }];
    }
}

    // This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    if (FBSession.activeSession.isOpen) {
        
    }
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
        // Facebook SDK * error handling *
        // Error handling is an important part of providing a good user experience.
        // Since this sample uses the FBLoginView, this delegate will respond to
        // login failures, or other failures that have closed the session (such
        // as a token becoming invalid). Please see the [- postOpenGraphAction:]
        // and [- requestPermissionAndPost] on `SCViewController` for further
        // error handling on other operations.
    FBErrorCategory errorCategory = [FBErrorUtility errorCategoryForError:error];
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
            // If the SDK has a message for the user, surface it. This conveniently
            // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if (errorCategory == FBErrorCategoryAuthenticationReopenSession) {
            // It is important to handle session closures as mentioned. You can inspect
            // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (errorCategory == FBErrorCategoryUserCancelled) {
            // The user has cancelled a login. You can inspect the error
            // for more context. For this sample, we will simply ignore it.
        alertTitle = @"Facebook message";
        alertMessage = @"User cancelled login.";
    } else {
            // For simplicity, this sample treats other errors blindly, but you should
            // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = [NSString stringWithFormat:@"Error. Please try again later. %@",error];
    }
    
    if (alertMessage) {
        [self showAlert:alertTitle andMessage:alertMessage];
    }
}

-(void) shootLoginFacebook:(Usuario*)usuario{
    
    NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[usuario toDictionary]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[usuario toDictionary]];
    
        //NSDictionary * val = [NSDictionary new];//[usuario toDictionary];
    
    [userDefaults setObject:myEncodedObject forKey:@"USUARIO-PENCA"];
    [userDefaults synchronize];
    NSError *conError = nil;
    NSError *jsonError = nil;
    //NSLog(@"valores: %@", jsonData);
    [PencuyFetcher multiFetcherSyncPublic:[PencuyFetcher URLtoCreateFaceUser]
                                 withHTTP:@"POST"
                                 withData:jsonData
                             withUserName:usuario.email
                             withPassword:usuario.password
                       communicationError:&conError
                   jsonSerializationError:&jsonError];
    //NSLog(@"Connection error: %@", conError);
    //NSLog(@"JsonError : %@", jsonData);
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoggedUser"];
    AppDelegate *delegate= [AppDelegate sharedDelegate];
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
    [delegate selectWhatKindOfSetupWithoutSet];
    //[self performSegueWithIdentifier: @"StartWithFacebook" sender: self];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    BOOL valid = [Validator validateEmail:_txtCorreo.text];
    if (valid) {
        [self showProgressBar];
        [_usuarioFacebook setEmail:_txtCorreo.text];
        [self shootLoginFacebook:_usuarioFacebook];
    }
    else{
        
        [self showAlert:NSLocalizedString(@"Email not valid!",nil) andMessage:NSLocalizedString(@"Please insert a valid email.",nil)];
    }
    return YES;
}

- (IBAction)btnAceptarTouch:(id)sender {
    BOOL valid = [Validator validateEmail:_txtCorreo.text];
    if (valid) {
        [self showProgressBar];
        [_usuarioFacebook setEmail:_txtCorreo.text];
        [self shootLoginFacebook:_usuarioFacebook];
    }
    else{
        
        [self showAlert:NSLocalizedString(@"Email not valid!",nil) andMessage:NSLocalizedString(@"Please insert email valid.",nil)];
    }
}

- (IBAction)btnVoverTouch:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"USUARIO-PENCA"];
    [FBSession.activeSession closeAndClearTokenInformation];
    [self volver];
}


#pragma mark Configuracion de Segues
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"StartWithFacebook"]){
        AppDelegate *delegate= [AppDelegate sharedDelegate];
        [delegate selectWhatKindOfSetupWithoutSet];
        return NO;
    }
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"StartWithFacebook"]){
        
        if ([segue.destinationViewController isKindOfClass:[CustomTabBarViewController class]]) {
            AppDelegate *delegate= [AppDelegate sharedDelegate];
            [delegate selectWhatKindOfSetupWithoutSet];
        }
    }
    
}


@end
