//
//  UsuarioViewController.m
//  Flattened
//
//  Created by Diego Maye on 06/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "UsuarioViewController.h"
#import "PencuyFetcher.h"
#import "AppDelegate.h"
#import "CustomTabBarViewController.h"
#import "usuario.h"

@interface UsuarioViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUsuario;
@property (weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblNotieneCuenta;
@property (strong, nonatomic) IBOutlet UIButton *btnRegistrarme;
@property (strong, nonatomic) IBOutlet UIButton *btnVolver;


@end


@implementation UsuarioViewController

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
    [_txtUsuario setDelegate:self];
    [_txtPass setDelegate:self];
    
    [self agregarEspacioInterno:_txtUsuario];
    [self agregarEspacioInterno:_txtPass];
    self.txtUsuario.placeholder = NSLocalizedString(@"E-mail",nil);
    self.txtPass.placeholder = NSLocalizedString(@"Password",nil);
    self.lblNotieneCuenta.text = NSLocalizedString(@"If you have an account then press the button \"Login\" otherwise you can press \"Create Account\"", nil);
    [self.btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.btnRegistrarme setTitle:NSLocalizedString(@"Create Account", nil) forState:UIControlStateNormal];
    [self.btnVolver setTitle:NSLocalizedString(@"RETURN", nil) forState:UIControlStateNormal];
    self.toolbarView.hidden=YES;
}

#pragma mark animacion textFields

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == _txtUsuario) {
        [_txtPass becomeFirstResponder];
    }
    else if (textField == _txtPass){
        self.toolbarView.hidden=YES;
        [_btnLogin becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.toolbarView.hidden = NO;
    if (textField == _txtUsuario) {
        [self upTextField:_txtUsuario focusOn:_txtUsuario];
    } else if (textField == _txtPass) {
        [self upTextField:_txtPass focusOn:_txtUsuario];

    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _txtUsuario) {
        [self downField:_txtUsuario withSpace:[NSNumber numberWithInt:0]];
    } else if (textField == _txtPass) {
        [self downField:_txtPass withSpace:[NSNumber numberWithInt:50]];

    }
}

#pragma mark validacion de usuario

-(BOOL)validateUserAndPassword{
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[PencuyFetcher URLtoCheckUser]];
    NSURLResponse *response= nil;
    NSError *error= nil;
    //NSLog(@"Disparando llamada sincronico");
    NSDictionary *eventLocation = [NSDictionary dictionaryWithObjectsAndKeys:self.txtUsuario.text,@"email",self.txtPass.text,@"password", nil];
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
    if (valida&&correoExiste) {
        NSError* conError = nil;
        NSError* jsonError = nil;
        NSDictionary* diccionario = [PencuyFetcher multiFetcherSync:[PencuyFetcher URLtoQueryProfile]
                                     withHTTP:@"GET"
                                     withData:nil
                                 withUserName:self.txtUsuario.text
                                 withPassword:self.txtPass.text
                           communicationError:&conError
                       jsonSerializationError:&jsonError];
       
        NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
        Usuario* usuario= [Usuario new];
        [usuario setNombreCompleto:diccionario[@"nombreCompleto"]];
        [usuario setNombre:diccionario[@"nombreCompleto"]];
        [usuario setEmail:_txtUsuario.text];
        [usuario setPassword:_txtPass.text];
        [usuario setRePassword:_txtPass.text];
        [usuario setCuentaFacebook:NO];
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        [usuario setLocale:language];
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[usuario toDictionary]];
        
        [userDefaults setObject:myEncodedObject forKey:@"USUARIO-PENCA"];
        [userDefaults synchronize];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoggedUser"];
        [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
        return YES;
    }
    else if (cuentaFacebook){
        [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
        if (valida) {
                //NUNCA ENTRA ACA PORQUE TENDRIA QUE VALIDAR UNA CLAVE AUTOGENERADA.
        }
        else{
                //ACA ENTRA CUANDO TIENE YA UNA CUENTA EN EL SISTEMA CON FACEBOOK
            [self showAlert:NSLocalizedString(@"You already have an account!",nil) andMessage:NSLocalizedString(@"You're already logged into the system with an account of fecebook try login with that account. Go back and sign in with facebook.",nil)];
        }
    }
    else if (correoExiste){
        [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
            //EL CORREO QUE INGRESO EXISTE PERO NO LE PEGO A LA CLAVE.
        [self showAlert:NSLocalizedString(@"Password error!",nil) andMessage:NSLocalizedString(@"The password is not correct try again.",nil)];
    }
    else{
        [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
            //EL CORREO QUE INGRESO NO EXISTE, LA CLAVE NO EXISTE Y NO HAY USUARIO DE FACEBOOK.
        [self showAlert:@"E-mail invalid!" andMessage:@"This e-mail does not exist in the system, if you want to create a new user selects \"Create Account\"."];
    }
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (IBAction)volverTouch:(id)sender {
    self.toolbarView.hidden=YES;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self showProgressBar];
    if([identifier isEqualToString:@"GoToTheApp"]){
        return [self validateUserAndPassword];
    }
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToTheApp"]){
        
        if ([segue.destinationViewController isKindOfClass:[CustomTabBarViewController class]]) {
            
            AppDelegate *delegate= [AppDelegate sharedDelegate];
            [delegate selectWhatKindOfSetup];
        }
    }
}

@end
