//
//  DetailFixtureViewController.m
//  Flattened
//
//  Created by Diego Maye on 01/03/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "DetailFixtureViewController.h"

#import "ADVTheme.h"
#import "DataSource.h"
#import "ADVGalleryPlain.h"

#import "UIColor+Alpha.h"
#import "Utils.h"
#import "DateUtility.h"

#import <QuartzCore/QuartzCore.h>

@interface DetailFixtureViewController () {
    CGSize kbSize;
}

@end

@implementation DetailFixtureViewController

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
    
    titleLabel.text = @"DETALLE PARTIDO";
    NSString* pathLocatario = [[NSBundle mainBundle] pathForResource:[_partido[@"local"] stringByAppendingString:@"-square"] ofType:@"ico"];
    _imagenLocatario.image = [UIImage imageWithContentsOfFile:pathLocatario];
    NSString* pathVisitante = [[NSBundle mainBundle] pathForResource:[_partido[@"visitante"] stringByAppendingString:@"-square"] ofType:@"ico"];
    _imagenVisitante.image = [UIImage imageWithContentsOfFile:pathVisitante];
    
    _golesLocatario.text = [_partido[@"golesLocal"] stringValue];
    _golesVisitante.text = [_partido[@"golesVisitante"] stringValue];
    
    
    NSDate *date = [DateUtility deserializeJsonDateString:[_partido[@"fecha"] stringValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    _fecha.text = stringFromDate;
    
    
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *stringFromTime = [formatter stringFromDate:date];
    _hora.text = stringFromTime;
    
    NSDate *dateLocal= [DateUtility convertDateToLocal:date];
    
    
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *stringFromDateLocal = [formatter stringFromDate:dateLocal];
    _fechaLocal.text = stringFromDateLocal;
    
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *stringFromTimeLocal = [formatter stringFromDate:dateLocal];
    _horaLocal.text = stringFromTimeLocal;
    
    _txtLocatario.text = self.partido[@"local"];
    _txtVisitante.text = self.partido[@"visitante"];
    _estado.text = self.partido[@"estado"];
    
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Actions

- (void)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
