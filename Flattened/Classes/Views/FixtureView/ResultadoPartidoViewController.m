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

@interface ResultadoPartidoViewController ()

@end

@implementation ResultadoPartidoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"Detail1";
    
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
    
    self.txtLocatario.text= self.apuesta[@"partido"][@"local"];
    self.txtVisitante.text= self.apuesta[@"partido"][@"visitante"];
    
    [self.txtLocatario alignTop];
    
    NSString* pathLocatario = [[NSBundle mainBundle] pathForResource:[self.apuesta[@"partido"][@"local"] stringByAppendingString:@"-square"] ofType:@"ico"];
    self.imgLocatario.image = [UIImage imageWithContentsOfFile:pathLocatario];
    NSString* pathVisitante = [[NSBundle mainBundle] pathForResource:[self.apuesta[@"partido"][@"visitante"] stringByAppendingString:@"-square"] ofType:@"ico"];
    self.imgVisitante.image = [UIImage imageWithContentsOfFile:pathVisitante];
    
    self.pickerLocatario = [[UIPickerView alloc] initWithFrame:(CGRectMake(0,-20,self.view.bounds.size.width,120))];
    [self.pickerLocatario setBounds:CGRectMake(0,0,self.view.bounds.size.width,120)];
        //self.pickerLocatario.transform = CGAffineTransformMakeScale(.9, 0.9);
        //[self.pickerLocatario setBackgroundColor:[UIColor lightGrayColor]];
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
        return 10;
    }
    return 0;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)]; // your frame, so picker gets "colored"
    
    
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [NSString stringWithFormat:@"%d",row];
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
    [diccionario setValue:@"false" forKey:@"tipoFinal"];
    
    [diccionario setValue:[[NSDictionary alloc]initWithObjectsAndKeys:@"65",@"idEquipo", nil] forKey:@"ganador"];
    [diccionario setValue:@"INGRESADO" forKey:@"estado"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:diccionario
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [self.apuesta setValue:locatario forKey:@"golesVisitante"];
    [self.apuesta setValue:visitante forKey:@"golesLocal"];
    self.fixture.apuestas=[[NSMutableArray alloc] initWithObjects:self.apuesta, nil];
        //Cargar las apuestas aca...
    [self.tableView reloadData];
    [PencuyFetcher multiFetcherSync:[PencuyFetcher URLtoMakeApuestas] withHTTP:@"PUT" withData:jsonData];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(NSDictionary*)findApuesa:(NSArray*)array withId:(NSString*)idApuesta{
    for (int i = 0; i<[array count]; i++) {
        if ([[(NSDictionary*)array[i] valueForKey:@"idApuesta"] isEqualToString:idApuesta]) {
            return (NSDictionary*)array[i];
        }
    }
    return nil;
}

@end
