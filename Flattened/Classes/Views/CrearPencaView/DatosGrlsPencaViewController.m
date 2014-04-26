//
//  DatosGrlsPencaViewController.m
//  Flattened
//
//  Created by Diego Maye on 18/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "DatosGrlsPencaViewController.h"
#import "DateUtility.h"
#import "PencuyFetcher.h"
#import "ApuestasDataLoaderTableViewController.h"

@interface DatosGrlsPencaViewController (){
    NSDate *fechaInicio;
    NSString *idPenca;
}
@end

@implementation DatosGrlsPencaViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.spinner setAlpha:0.0];
    [self.spinner startAnimating];
    
    [self customizationUITextField:_txtNombre withDescription:@"Nombre para la penca"];
    [self customizationUITextField:_txtDescripcion withDescription:@"Descripcion para tus amigos"];
    [self customizationUITextField:_txtFecha withDescription:@"Fecha de comienzo"];
    [self customizationUITextField:_txtCosto withDescription:@"Precio unitario penca"];
    [self addAccessoryButtonToNumberPad:_txtCosto];
    _signoMoneda.text= NSLocalizedString(@"$U",nil);
    
    [self customizationUIDatePickerUITextView:_txtFecha withButtonDescription:@"Listo"];
     
}

#pragma mark Animacion del spinner
-(void)appear{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.spinner setAlpha:0.65];
    [UIView commitAnimations];
}

-(void)disappear{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.spinner setAlpha:0.0];
    [UIView commitAnimations];
}

#pragma mark Agregar botones de aceptar al Decimal Pad

-(void)addAccessoryButtonToNumberPad:(UITextField *)text{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [numberToolbar setBarStyle:UIBarStyleBlackTranslucent];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancelar" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Aceptar" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    text.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [_txtCosto resignFirstResponder];
    _txtCosto.text = @"";
}

-(void)doneWithNumberPad{
    [_txtCosto resignFirstResponder];
}
#pragma mark Agregado de UIDatePicker customizado.
-(void) customizationUIDatePickerUITextView:(UITextField*)text withButtonDescription:(NSString*) buttonDescription{
    
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:buttonDescription style:UIBarButtonItemStyleDone target:self action:@selector(changeDate:)];
    
    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: flexSpace, done, nil]];
    
    text.inputAccessoryView = keyboardToolbar;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setBounds:CGRectMake(0,0,self.view.bounds.size.width,100)];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [text setInputView:datePicker];
}

-(void)changeDate:(id)sender{
    [self modifyUITextField];
    [self.view endEditing:YES];
}

-(void)updateTextField:(id)sender
{
    [self modifyUITextField];
}

-(void)modifyUITextField{
    UIDatePicker *picker = (UIDatePicker*)_txtFecha.inputView;
    
    if (!fechaInicio) {
        fechaInicio = [NSDate new];
    }
    
    fechaInicio=picker.date;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = NSLocalizedString(@"dd/MM/yyyy",nil);
    NSString *fecha = [dateFormatter stringFromDate:picker.date];
    dateFormatter.dateFormat = NSLocalizedString(@"HH:mm",nil);
    NSString *hora = [dateFormatter stringFromDate:picker.date];
    NSString *resultado= [NSString stringWithFormat:@"%@ %@ %@ %@",
                          NSLocalizedString(@"Comienza el",nil),
                          fecha,
                          NSLocalizedString(@"a las",nil),
                          hora];
    
    _txtFecha.text = [NSString stringWithFormat:@"%@",resultado];

}

#pragma mark Customizacion de componentes de texto.

-(void) customizationUITextField:(UITextField *)text withDescription:(NSString*) placeholder{
    text.delegate= self;
    [text.layer setCornerRadius:5.0f];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    
    text.leftView = paddingView;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.placeholder = placeholder;
}

#pragma mark Eventos UITextFieldDelegate.

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-80);
    [_scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark evento touch de crear penca

- (IBAction)touchCrearPenca:(id)sender {
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showApuestas"]) {
        ApuestasDataLoaderTableViewController *apuestaView = segue.destinationViewController;
        
        if (!idPenca) {
            idPenca = [NSString new];
        }
        apuestaView.idPenca = idPenca;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showApuestas"]) {
        
        [self.view endEditing:YES];
        [self appear];
        NSMutableDictionary *diccionario= [NSMutableDictionary new];
        NSMutableString *errores= [NSMutableString new];
        if ([[_txtNombre text] length]) {
            [diccionario setValue:(NSString*)_txtNombre.text forKey:@"nombre"];
        }
        else{
            [errores appendString:NSLocalizedString(@"El nombre de la penca.\r",nil)];
        }
        if ([[_txtDescripcion text] length]) {
            [diccionario setValue:_txtDescripcion.text forKey:@"descripcion"];
        }
        else{
            [errores appendString:NSLocalizedString(@"Descripcion de la penca.\r",nil)];
        }
        if (fechaInicio) {
            [diccionario setValue:[DateUtility serealizadorJsonDateToString:fechaInicio] forKey:@"fechaHoraInicio"];
        }
        else{
            [errores appendString:NSLocalizedString(@"Fecha en la que inicia.\r",nil)];
        }
        if ([[_txtCosto text] length]) {
            [diccionario setValue:_txtCosto.text forKey:@"costoUnitario"];
        }
        else{
            [errores appendString:NSLocalizedString(@"Costo unitario.\r",nil)];
        }
        if ([errores length]) {
            UIAlertView* alerta=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Te falto ingresar:",nil)
                                                           message:errores
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Ok",nil)
                                                 otherButtonTitles: nil];
            
            [alerta show];
            [self disappear];
            return NO;
        }
        else{
            [diccionario setValue:[DateUtility dateNow] forKey:@"fechaHoraGeneracion"];
            [diccionario setValue:@"false" forKey:@"mostrarApuestas"];
            NSArray *porcentajes = [NSArray arrayWithObjects: [NSNumber numberWithInt:100], nil];
            [diccionario setValue:porcentajes forKey:@"porcentajesGanadores"];
            [diccionario setValue:_txtCosto.text forKey:@"pozoTotal"];
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:diccionario
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            if (!jsonData) {
                NSLog(@"Error al convertir el diccionario en json: %@", error);
                UIAlertView* alerta=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ups!, hubo un error",nil)
                                                               message:NSLocalizedString(@"No puedes crear la penca en este momento, espera e intentalo mas tarde",nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"Ok",nil)
                                                     otherButtonTitles: nil];
                
                [alerta show];
                [self disappear];
                return NO;
            } else {
                NSDictionary *devolucion = [PencuyFetcher multiFetcherSync:[PencuyFetcher URLAPIForPencaBrasil] withHTTP:@"POST" withData:jsonData];
                if ([devolucion valueForKeyPath:@"idPenca"]) {
                    UIAlertView* alerta=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nueva penca",nil)
                                                                   message:[NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"La penca",nil), _txtNombre.text, NSLocalizedString(@"se ha creado exitosamente, ahora debes de apostar",nil)]
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"Ok",nil)
                                                         otherButtonTitles: nil];
                    if (!idPenca) {
                        idPenca = [NSString new];
                    }
                    idPenca= [devolucion valueForKey:@"idPenca"];
                    
                    [alerta show];
                    [self disappear];
                    return YES;
                }
                else if ([devolucion valueForKeyPath:@"message"]) {
                    UIAlertView* alerta=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ocurrió un error",nil)
                                                                   message:[devolucion valueForKeyPath:@"message"]
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"Ok",nil)
                                                         otherButtonTitles: nil];
                    
                    [alerta show];
                    [self disappear];
                    return NO;
                }
            }
        }
    }
    return YES;
}

@end
