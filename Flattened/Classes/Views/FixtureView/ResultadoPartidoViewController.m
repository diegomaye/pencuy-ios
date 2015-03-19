//
//  ResultadoPartidoViewController.m
//  Flattened
//
//  Created by Diego Maye on 23/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ResultadoPartidoViewController.h"
#import "ApuestasDataLoaderTableViewController.h"
#import "ADVTheme.h"
#import "DataSource.h"
#import "ADVGalleryPlain.h"

#import "UIColor+Alpha.h"
#import "Utils.h"
#import "DateUtility.h"
#import "UILabel+VerticalAlign.h"

#import <QuartzCore/QuartzCore.h>
#import "PencuyFetcher.h"
#import "GraphicUtils.h"
#import "SIAlertView.h"

@interface ResultadoPartidoViewController ()

@end

@implementation ResultadoPartidoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
        
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 0, 40, 30);
    [btnCancel setImage:[UIImage imageNamed:@"navigation-btn-cancel"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    titleLabel.text = @"SELECCIONAR RESULTADO";
    [titleLabel sizeToFit];
    
    
    self.navigationItem.titleView = titleLabel;
    
    self.txtLocatario.text= NSLocalizedString(self.apuesta[@"localDesc"],nil);
    self.txtVisitante.text= NSLocalizedString(self.apuesta[@"visitanteDesc"],nil);
    
    
    [self.txtLocatario alignTop];
    [self.txtVisitante alignTop];
    
    self.txtLocatario.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    self.txtLocatario.textColor = [GraphicUtils colorMidnightBlue];
    self.txtVisitante.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    self.txtVisitante.textColor = [GraphicUtils colorMidnightBlue];
    
    NSString* pathLocatario = [[NSBundle mainBundle] pathForResource:[self.apuesta[@"localDesc"] stringByAppendingString:@"-square"] ofType:@"ico"];
    self.imgLocatario.image = [UIImage imageWithContentsOfFile:pathLocatario];
    NSString* pathVisitante = [[NSBundle mainBundle] pathForResource:[self.apuesta[@"visitanteDesc"] stringByAppendingString:@"-square"] ofType:@"ico"];
    self.imgVisitante.image = [UIImage imageWithContentsOfFile:pathVisitante];
    
    self.pickerLocatario = [[UIPickerView alloc] initWithFrame:(CGRectMake(0,-20,self.view.bounds.size.width,300))];
    [self.pickerLocatario setBounds:CGRectMake(0,0,self.view.bounds.size.width,300)];
    [self.view addSubview:self.pickerLocatario];
    
    self.pickerLocatario.dataSource = self;
    self.pickerLocatario.delegate = self;
}

#pragma mark UILabel Set top
-(void) setUILableTextToVAlignTop:(UILabel*)myLabel{
    myLabel.textAlignment = NSTextAlignmentCenter;
    
    [myLabel setNumberOfLines:0];
    [myLabel sizeToFit];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ([pickerView isEqual:self.pickerLocatario]) {
        return 2;
    }
    return 0;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([pickerView isEqual:self.pickerLocatario]) {
        return 20;
    }
    return 0;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 32)]; // your frame, so picker gets "colored"
    
    
    label.backgroundColor = [GraphicUtils colorDefault];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    label.text = [NSString stringWithFormat:@"%lu",(long)row];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([pickerView isEqual:self.pickerLocatario]) {
        return [NSString stringWithFormat:@"%d",(int)row + 1];
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    NSNumber* golesLocal = self.apuesta[@"golesLocal"];
    if ([golesLocal isKindOfClass:NSNull.class]) {
        [self.pickerLocatario selectRow:0 inComponent:0 animated:YES];
    }
    else{
        [self.pickerLocatario selectRow:[golesLocal integerValue] inComponent:0 animated:YES];
    }
    NSNumber* golesVisitante = self.apuesta[@"golesVisitante"];
    if ([golesVisitante isKindOfClass:NSNull.class]) {
         [self.pickerLocatario selectRow:0 inComponent:1 animated:YES];
    }
    else{
        [self.pickerLocatario selectRow:[golesVisitante integerValue] inComponent:1 animated:YES];
    }

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Actions

- (void)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)touchIngresar:(id)sender {
    NSMutableDictionary *diccionario= [NSMutableDictionary new];
    [diccionario setValue:[NSNumber numberWithInteger:[self.apuesta[@"idApuesta"] intValue]] forKey:@"idApuesta"];
    
    NSNumber *locatario = [NSNumber numberWithInteger:([self.pickerLocatario selectedRowInComponent:1])] ;
    NSNumber *visitante = [NSNumber numberWithInteger:([self.pickerLocatario selectedRowInComponent:0])] ;
    [diccionario setValue:locatario forKey:@"golesVisitante"];
    [diccionario setValue:visitante forKey:@"golesLocal"];
    [self showProgressBar];
    if([self.apuesta[@"tipoFinal"] intValue]== 1){
        [diccionario setValue:@"true" forKey:@"tipoFinal"];
        if ([locatario intValue] == [visitante intValue]) {
            SIAlertView* alertView = [[SIAlertView alloc]initWithTitle:NSLocalizedString(@"Choose a winner!", nil) andMessage:NSLocalizedString(@"This match determines the pass to the next round, please choose a winner.", nil)];
            
            [alertView addButtonWithTitle:NSLocalizedString(self.apuesta[@"localDesc"],nil)
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                      [diccionario setValue:@"true" forKey:@"ganaLocal"];
                                      [self sendApuesta:diccionario];
                                  }];
            [alertView addButtonWithTitle:NSLocalizedString(self.apuesta[@"visitanteDesc"],nil)
                                     type:SIAlertViewButtonTypeDestructive
                                  handler:^(SIAlertView *alert) {
                                      [diccionario setValue:@"false" forKey:@"ganaLocal"];
                                      [self sendApuesta:diccionario];
                                  }];
            
            alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
            [alertView show];

        }
        else{
            if ([locatario intValue] > [visitante intValue]) {
                [diccionario setValue:@"true" forKey:@"ganaLocal"];
            }
            else{
                [diccionario setValue:@"false" forKey:@"ganaLocal"];
            }
            [self sendApuesta:diccionario];
        }

    }
    else {
        [diccionario setValue:@"false" forKey:@"tipoFinal"];
        [self sendApuesta:diccionario];
    }
    
}

-(void) sendApuesta:(NSDictionary*) apuesta{
    [apuesta setValue:@"INGRESADO" forKey:@"estado"];
    //NSLog(@"Valore enviados: %@", apuesta);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:apuesta
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSDictionary* retorno = [PencuyFetcher multiFetcherSync:[PencuyFetcher URLtoMakeApuestas] withHTTP:@"PUT" withData:jsonData];
    //NSLog(@"Devolvió: %@", retorno);
    if (retorno) {
        [self setComplete];
        [(ApuestasDataLoaderTableViewController*)self.fixture fetchApuestas:self.fixture.idPenca andFecha:[self.fixture.idFecha stringValue] ];
        [self.fixture.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    else{
        [self setCompleteErrorSorry];
    }
    
}

@end
