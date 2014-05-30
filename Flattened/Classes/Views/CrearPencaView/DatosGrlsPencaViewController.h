//
//  DatosGrlsPencaViewController.h
//  Flattened
//
//  Created by Diego Maye on 18/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PencasDataLoaderTableViewController.h"
#import "MasterLoginViewController.h"

@interface DatosGrlsPencaViewController : MasterLoginViewController

@property (strong, nonatomic) IBOutlet UITextField *txtNombre;
@property (strong, nonatomic) IBOutlet UITextField *txtDescripcion;
@property (strong, nonatomic) IBOutlet UITextField *txtCosto;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) NSArray *fechas;

@property (strong, nonatomic) PencasTVController *pencas;

@end
