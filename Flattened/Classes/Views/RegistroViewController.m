//
//  RegistroViewController.m
//  Flattened
//
//  Created by Diego Maye on 06/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "RegistroViewController.h"
#import "CustomTabBarViewController.h"
#import "PencuyFetcher.h"
#import "Usuario.h"
#import "AppDelegate.h"
#import "Validator.h"
#import "Utils.h"

@interface RegistroViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtCorreo;
@property (weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UITextField *txtRePass;
@property (weak, nonatomic) IBOutlet UIButton *btnRegistrar;
@property (weak, nonatomic) IBOutlet UIButton *btnVolver;

@end

@implementation RegistroViewController

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
    if (self) {
        [self setProgressBar];
    }
    [_txtNombre setDelegate:self];
    [_txtCorreo setDelegate:self];
    [_txtPass setDelegate:self];
    [_txtRePass setDelegate:self];
    
    [self agregarEspacioInterno:_txtNombre];
    [self agregarEspacioInterno:_txtCorreo];
    [self agregarEspacioInterno:_txtPass];
    [self agregarEspacioInterno:_txtRePass];
    self.txtCorreo.placeholder = NSLocalizedString(@"E-Mail", nil);
    self.txtNombre.placeholder = NSLocalizedString(@"Name", nil);
    self.txtPass.placeholder = NSLocalizedString(@"Password", nil);
    self.txtRePass.placeholder = NSLocalizedString(@"Enter the password again", nil);
    [self.btnRegistrar setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.btnVolver setTitle:NSLocalizedString(@"RETURN", nil) forState:UIControlStateNormal];
    self.toolbarView.hidden=YES;
}

#pragma mark animacion textFields

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == _txtNombre) {
        [_txtCorreo becomeFirstResponder];
    }
    else if (textField == _txtCorreo){
        [_txtPass becomeFirstResponder];
    }
    else if (textField == _txtPass){
        [_txtRePass becomeFirstResponder];
    }
    else if (textField == _txtRePass){
        [_btnRegistrar resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.toolbarView.hidden = NO;
    if (textField == _txtNombre) {
        [self upTextField:_txtNombre focusOn:_txtNombre];
    } else if (textField == _txtCorreo) {
        [self upTextField:_txtCorreo focusOn:_txtNombre];
    } else if (textField == _txtPass) {
        [self upTextField:_txtPass focusOn:_txtNombre];
    } else if (textField == _txtRePass) {
        [self upTextField:_txtRePass focusOn:_txtNombre];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _txtNombre) {
        [self downField:_txtNombre withSpace:[NSNumber numberWithInt:0]];
    } else if (textField == _txtCorreo) {
        [self downField:_txtCorreo withSpace:[NSNumber numberWithInt:50]];
    } else if (textField == _txtPass) {
        [self downField:_txtPass withSpace:[NSNumber numberWithInt:100]];
    } else if (textField == _txtRePass) {
        [self downField:_txtRePass withSpace:[NSNumber numberWithInt:150]];
    }
}

- (IBAction)volverTouch:(id)sender {
    self.toolbarView.hidden=YES;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Validacion de datos e insercion de nuevo usuario al sistema.
-(BOOL)validateUserAndPassword{
    
        //[self.spinner startAnimating];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[PencuyFetcher URLtoCheckUser]];
    NSURLResponse *response= nil;
    NSError *error= nil;
    //NSLog(@"Disparando llamada sincronico");
    NSDictionary *eventLocation = [NSDictionary dictionaryWithObjectsAndKeys:self.txtCorreo.text,@"email",self.txtPass.text,@"password", nil];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:eventLocation
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:&error];
    //NSLog(@"jsonRequest is %@", requestData);
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    NSData *jsonResults= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *propertyListResults= [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
    
    BOOL correoExiste = [[propertyListResults valueForKey:@"correoExiste"] boolValue];
    BOOL valida = [[propertyListResults valueForKey:@"valida"] boolValue];
    BOOL cuentaFacebook = [[propertyListResults valueForKey:@"cuentaFacebook"] boolValue];
    if (cuentaFacebook){
        [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
        if (valida) {
            [self showAlert:NSLocalizedString(@"That email already exist", nil) andMessage:NSLocalizedString(@"This email address is already entered in the system press GO BACK and try to login with your account.",nil)];
        }
        else{
                //ACA ENTRA CUANDO TIENE YA UNA CUENTA EN EL SISTEMA CON FACEBOOK
            [self showAlert:NSLocalizedString(@"Already have an account!", nil) andMessage:NSLocalizedString(@"You're already logged into the system with an account of fecebook try login with that account. Go back and log in with facebook.", nil)];
        }
    }
    else if (correoExiste){
        [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];

            //EL CORREO QUE INGRESO EXISTE PERO NO LE PEGO A LA CLAVE.
        [self showAlert:NSLocalizedString(@"Ups! This email is already in the system", nil) andMessage:NSLocalizedString(@"This email address is already entered in the system press GO BACK and try to login with your account.", nil)];
    }
    else{
        

        if ([self varificacionVacios]) {
            BOOL correoValid = [Validator validateEmail:_txtCorreo.text];
            if (correoValid) {
                if ([_txtPass.text isEqualToString:_txtRePass.text]) {
                    if (_txtPass.text.length>5) {
                        [self shootUserLoggin];
                        [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
                        return YES;
                    }
                    [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
                    [self showAlert:@"Ups!" andMessage:NSLocalizedString(@"The password lenght must be more than 5 digits", nil)];
                }
                else{
                    [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
                    [self showAlert:NSLocalizedString(@"Passwords do not match", nil) andMessage:NSLocalizedString(@"The two passwords you entered must match",nil)];
                }
            }
            else{
                [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
                [self showAlert:NSLocalizedString(@"Invalid E-Mail", nil) andMessage:NSLocalizedString(@"The format of email is not correct", nil) ];
            }
        }
        return NO;
    }
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
    return NO;
}

-(BOOL)varificacionVacios{
    NSString* error = @"";
    if ([_txtNombre.text isEqualToString:@""]) {
        error = NSLocalizedString(@"You must enter a name", nil);
    }
    if([_txtCorreo.text isEqualToString:@""]){
        error = [NSString stringWithFormat:NSLocalizedString(@"%@ \n You must enter an email address",nil),error ];
    }
    if([_txtPass.text isEqualToString:@""]){
        error = [NSString stringWithFormat:NSLocalizedString(@"%@ \n You must enter a password",nil),error ];
    }
    if([_txtRePass.text isEqualToString:@""]){
        error = [NSString stringWithFormat:NSLocalizedString(@"%@ \n You must re enter a password",nil),error ];
    }
    if ([error isEqualToString:@""]) {
        return YES;
    }
    else{
        [self showAlert:@"Ups!" andMessage:error];
        return NO;
    }
}

-(void) shootUserLoggin{
    NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
    Usuario* usuario= [Usuario new];
    [usuario setNombreCompleto:_txtNombre.text];
    [usuario setNombre:_txtNombre.text];
    [usuario setEmail:_txtCorreo.text];
    [usuario setPassword:_txtPass.text];
    [usuario setRePassword:_txtRePass.text];
    [usuario setCuentaFacebook:NO];
    [usuario setApnsDeviceToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"DEVICE-TOKEN" ]];
    [usuario setLastDevAppleModelUsed:[Utils machineName]];
    [usuario setLastDevApple:[Utils isVersion6AndBelow]?@"IOS6orLess":@"IOS7.X"];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [usuario setLocale:language];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[usuario toDictionary]];
    
    [userDefaults setObject:myEncodedObject forKey:@"USUARIO-PENCA"];
    [userDefaults synchronize];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[usuario toDictionary]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSError *conError = nil;
    NSError *jsonError = nil;
    //NSLog(@"valores: %@", [usuario toDictionary]);
    
    /*
     error: {
     message = "error.passwordNoCoinciden";
     status = ERROR;
     }
     */
    [PencuyFetcher multiFetcherSyncPublic:[PencuyFetcher URLtoCreateUser]
                                                         withHTTP:@"POST"
                                                         withData:jsonData
                                                     withUserName:usuario.email
                                                     withPassword:usuario.password
                                               communicationError:&conError
                                           jsonSerializationError:&jsonError];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoggedUser"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self showProgressBar];
    if([identifier isEqualToString:@"NewUserRegistered"]){
        return [self validateUserAndPassword];
    }
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewUserRegistered"]){
        
        if ([segue.destinationViewController isKindOfClass:[CustomTabBarViewController class]]) {
            
            AppDelegate *delegate= [AppDelegate sharedDelegate];
            [delegate selectWhatKindOfSetup];
        }
    }
}


#pragma mark Recive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end
