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
#import "HostViewController.h"
#import "Utils.h"

@interface DatosGrlsPencaViewController (){
    NSString *idPenca;
}
@end

@implementation DatosGrlsPencaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    self.title = NSLocalizedString(@"CREATE A BET",nil);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];

    
    [self.spinner setAlpha:0.0];
    [self.spinner startAnimating];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 0, 40, 30);
    [btnCancel setImage:[UIImage imageNamed:@"navigation-btn-cancel"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    _txtNombre.placeholder = NSLocalizedString(@"Name for the bet",nil);
    _txtDescripcion.placeholder = NSLocalizedString(@"Description to your friend",nil);
    _txtCosto.placeholder = NSLocalizedString(@"Unit cost for bet", @"");
    [self agregarEspacioInterno:_txtNombre];
    [self agregarEspacioInterno:_txtDescripcion];
    [self agregarEspacioInterno:_txtCosto];
    
    _txtNombre.delegate=self;
    _txtDescripcion.delegate=self;
    _txtCosto.delegate=self;
    
    [self addAccessoryButtonToNumberPad:_txtCosto];
}

- (void)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 38)];
    [numberToolbar setBarStyle:UIBarStyleBlackTranslucent];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Accept" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    text.inputAccessoryView = numberToolbar;
    self.toolbarView.hidden = YES;
}

-(void)cancelNumberPad{
    [_txtCosto resignFirstResponder];
    _txtCosto.text = @"";
}

-(void)doneWithNumberPad{
    [_txtCosto resignFirstResponder];
}
#pragma mark Agregado de UIDatePicker customizado.


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
    [self.view endEditing:YES];
    [self appear];
    NSMutableDictionary *diccionario= [NSMutableDictionary new];
    NSMutableString *errores= [NSMutableString new];
    if ([[_txtNombre text] length]) {
        [diccionario setValue:(NSString*)_txtNombre.text forKey:@"nombre"];
    }
    else{
        [errores appendString:NSLocalizedString(@"The name of the bet.\r",nil)];
    }
    if ([[_txtDescripcion text] length]) {
        [diccionario setValue:_txtDescripcion.text forKey:@"descripcion"];
    }
    else{
        [errores appendString:NSLocalizedString(@"Description for the bet.\r",nil)];
    }
    if ([[_txtCosto text] length]) {
        [diccionario setValue:_txtCosto.text forKey:@"costoUnitario"];
    }
    else{
        [errores appendString:NSLocalizedString(@"Unit price for bet.\r",nil)];
    }
    if ([errores length]) {
        [self showAlert:NSLocalizedString(@"You need to insert:",nil)
             andMessage:errores];
        [self disappear];
    }
    else{
        [diccionario setValue:[DateUtility dateNow] forKey:@"fechaHoraGeneracion"];
        [diccionario setValue:[DateUtility dateNow] forKey:@"fechaHoraInicio"];
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
            [self showAlert:NSLocalizedString(@"Ups!",nil)
                 andMessage:NSLocalizedString(@"You cannot create the bet at the moment, please try again late",nil)];
            [self disappear];
        } else {
            NSDictionary *devolucion = [PencuyFetcher multiFetcherSync:[PencuyFetcher URLAPIForPencaBrasil]
                                                              withHTTP:@"POST"
                                                              withData:jsonData];
            
            if ([devolucion valueForKeyPath:@"idPenca"]) {

                [self disappear];
                [(PencasDataLoaderTableViewController*)self.pencas fetchPencas];
                [self.pencas.tableView reloadData];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];

            }
            else if ([devolucion valueForKeyPath:@"message"]) {
                [self showAlert:NSLocalizedString(@"Sorry!",nil)
                     andMessage:[devolucion valueForKeyPath:@"message"]];
                [self disappear];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end
