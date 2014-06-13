//
//  OtherViewController.h
//  
//
//  Created by Valentin Filip on 5/27/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface OtherViewController : MasterViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *equipo1;
@property (strong, nonatomic) IBOutlet UIButton *equipo2;

@property (strong, nonatomic) IBOutlet UITextField *lblEquipo1;
@property (strong, nonatomic) IBOutlet UITextField *lblEquipo2;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewPaises;
//Equipo1
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1MundGanados;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1Copas;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1Puntos;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1PJugados;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1PGanados;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1PEmpatados;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1PPerdidos;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1GolesConvertidos;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo1GolesRecividos;

//Equipo2
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2MundGanados;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2Goles;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2Puntos;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2PJugados;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2PGanados;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2PEmpatados;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2PPerdidos;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2GolesConvertidos;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo2GolesRecividos;

@property (strong, nonatomic) IBOutlet UIView *viewContainer;

//Labels para diccionario
@property (strong, nonatomic) IBOutlet UILabel *lblMundiales;
@property (strong, nonatomic) IBOutlet UILabel *lblCopas;
@property (strong, nonatomic) IBOutlet UILabel *lblPuntos;
@property (strong, nonatomic) IBOutlet UILabel *lblPJugados;
@property (strong, nonatomic) IBOutlet UILabel *lblPGanados;
@property (strong, nonatomic) IBOutlet UILabel *lblPEmpatados;
@property (strong, nonatomic) IBOutlet UILabel *lblPPerdidos;
@property (strong, nonatomic) IBOutlet UILabel *lblGolesConv;
@property (strong, nonatomic) IBOutlet UILabel *lblGolesRec;

@end
