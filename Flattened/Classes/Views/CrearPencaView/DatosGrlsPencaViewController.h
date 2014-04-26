//
//  DatosGrlsPencaViewController.h
//  Flattened
//
//  Created by Diego Maye on 18/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatosGrlsPencaViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtNombre;

@property (strong, nonatomic) IBOutlet UITextField *txtDescripcion;

@property (strong, nonatomic) IBOutlet UITextField *txtFecha;

@property (strong, nonatomic) IBOutlet UITextField *txtCosto;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *signoMoneda;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
