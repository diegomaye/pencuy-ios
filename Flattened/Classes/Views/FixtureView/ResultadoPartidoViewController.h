//
//  ResultadoPartidoViewController.h
//  Flattened
//
//  Created by Diego Maye on 23/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApuestasTVController.h"

@interface ResultadoPartidoViewController : UIViewController <UISplitViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *apuesta;
@property (strong, nonatomic) ApuestasTVController *fixture;


@property (strong, nonatomic) IBOutlet UILabel *txtLocatario;
@property (strong, nonatomic) IBOutlet UIImageView *imgLocatario;

@property (strong, nonatomic) IBOutlet UILabel *txtVisitante;
@property (strong, nonatomic) IBOutlet UIImageView *imgVisitante;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerLocatario;

@end
