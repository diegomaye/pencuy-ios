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
    
    [_txtNombre setDelegate:self];
    [_txtCorreo setDelegate:self];
    [_txtPass setDelegate:self];
    [_txtRePass setDelegate:self];
    
    [self agregarEspacioInterno:_txtNombre];
    [self agregarEspacioInterno:_txtCorreo];
    [self agregarEspacioInterno:_txtPass];
    [self agregarEspacioInterno:_txtRePass];
    
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
    NSLog(@"Disparando llamada sincronico");
    NSDictionary *eventLocation = [NSDictionary dictionaryWithObjectsAndKeys:self.txtCorreo.text,@"email",self.txtPass.text,@"password", nil];
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
    
    BOOL correoExiste = [[propertyListResults valueForKey:@"correoExiste"] boolValue];
    BOOL valida = [[propertyListResults valueForKey:@"valida"] boolValue];
    BOOL cuentaFacebook = [[propertyListResults valueForKey:@"cuentaFacebook"] boolValue];
    if (valida&&correoExiste) {
        
    }
    else if (cuentaFacebook){
        if (valida) {
            [self showAlert:@"Este correo ya existe" andMessage:@"Esta direccion de correo ya esta ingresada en el sistema presiona VOLVER e intenta loguearte con tu cuenta."];
        }
        else{
                //ACA ENTRA CUANDO TIENE YA UNA CUENTA EN EL SISTEMA CON FACEBOOK
            [self showAlert:@"Ya tienes una cuenta!" andMessage:@"Ya estas ingresado en el sistema con una cuenta de fecebook, intenta ingresar con esa cuenta. Vuelve atras y accede con facebook."];
        }
    }
    else if (correoExiste){
            //EL CORREO QUE INGRESO EXISTE PERO NO LE PEGO A LA CLAVE.
        [self showAlert:@"Ups! este correo ya esta en el sistema" andMessage:@"Esta direccion de correo ya esta ingresada en el sistema presiona VOLVER e intenta loguearte con tu cuenta."];
    }
    else{
        if ([self varificacionVacios]) {
            BOOL correoValid = [Validator validateEmail:_txtCorreo.text];
            if (correoValid) {
                if ([_txtPass.text isEqualToString:_txtRePass.text]) {
                    if (_txtPass.text.length>5) {
                        [self shootUserLoggin];
                        return YES;
                    }
                    [self showAlert:@"Ups!" andMessage:@"La contraseña debe ser de mas de 5 digitos :D"];
                }
                else{
                    [self showAlert:@"Las contraseñas no coinciden!" andMessage:@"Las dos contraseñas que ingresaste deben de conincidir"];
                }
            }
            else{
                [self showAlert:@"Correo invalido!" andMessage:@"El formato de correo no es correcto"];
            }
        }
        return NO;
    }
    return NO;
}

-(BOOL)varificacionVacios{
    NSString* error = @"";
    if ([_txtNombre.text isEqualToString:@""]) {
        error = @"Debes ingresar un nombre";
    }
    if([_txtCorreo.text isEqualToString:@""]){
        error = [NSString stringWithFormat:@"%@ \n Debes ingresar una direccion de correo",error ];
    }
    if([_txtPass.text isEqualToString:@""]){
        error = [NSString stringWithFormat:@"%@ \n Debes ingresar una contraseña",error ];
    }
    if([_txtRePass.text isEqualToString:@""]){
        error = [NSString stringWithFormat:@"%@ \n Debes re ingresar tu contraseña",error ];
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
    NSLog(@"valores: %@", [usuario toDictionary]);
    
    /*
     error: {
     message = "error.passwordNoCoinciden";
     status = ERROR;
     }
     */
#warning Cachear eventuales errores que se produscan del lado del servidor, ver arriba comentado esta un ejemplo de error del servidor.
    NSDictionary* retorno = [PencuyFetcher multiFetcherSyncPublic:[PencuyFetcher URLtoCreateUser]
                                                         withHTTP:@"POST"
                                                         withData:jsonData
                                                     withUserName:usuario.email
                                                     withPassword:usuario.password
                                               communicationError:&conError
                                           jsonSerializationError:&jsonError];
    NSLog(@"Error: %@", retorno);
    NSLog(@"Connection error: %@", conError);
    NSLog(@"JsonError : %@", jsonData);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoggedUser"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"NewUserRegistered"]){
        return [self validateUserAndPassword];
    }
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
