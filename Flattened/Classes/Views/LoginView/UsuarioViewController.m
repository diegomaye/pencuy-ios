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
    [_txtUsuario setDelegate:self];
    [_txtPass setDelegate:self];
    
    [self agregarEspacioInterno:_txtUsuario];
    [self agregarEspacioInterno:_txtPass];
    
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
    
    BOOL correoExiste = [[propertyListResults valueForKey:@"correoExiste"] boolValue];
    BOOL valida = [[propertyListResults valueForKey:@"valida"] boolValue];
    BOOL cuentaFacebook = [[propertyListResults valueForKey:@"cuentaFacebook"] boolValue];
    if (valida&&correoExiste) {
        /*
         VER ESTO CON MAURICIO.
        [PencuyFetcher multiFetcherSyncPublic:[PencuyFetcher URLtoLoginUser]
                                     withHTTP:@"PUT"
                                     withData:jsonData
                                 withUserName:usuario.email
                                 withPassword:usuario.password
                           communicationError:&conError
                       jsonSerializationError:&jsonError];
        */
        
        NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
        Usuario* usuario= [Usuario new];
        [usuario setNombreCompleto:@"Jhon Doe"];
        [usuario setNombre:@"Jhon Doe"];
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
        return YES;
    }
    else if (cuentaFacebook){
        if (valida) {
                //NUNCA ENTRA ACA PORQUE TENDRIA QUE VALIDAR UNA CLAVE AUTOGENERADA.
        }
        else{
                //ACA ENTRA CUANDO TIENE YA UNA CUENTA EN EL SISTEMA CON FACEBOOK
            [self showAlert:@"Ya tienes una cuenta!" andMessage:@"Ya estas ingresado en el sistema con una cuenta de fecebook, intenta ingresar con esa cuenta. Vuelve atras y accede con facebook."];
        }
    }
    else if (correoExiste){
            //EL CORREO QUE INGRESO EXISTE PERO NO LE PEGO A LA CLAVE.
        [self showAlert:@"Error de password!" andMessage:@"La contraseña no es correcta inteta nuevamente."];
    }
    else{
            //EL CORREO QUE INGRESO NO EXISTE, LA CLAVE NO EXISTE Y NO HAY USUARIO DE FACEBOOK.
        [self showAlert:@"Correo invalido" andMessage:@"Esta direccion de correo no existe en el sistema, si deseas crear un nuevo usuario selecciona \"Registrar me!\"."];
    }
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
        }
    }
}

@end
