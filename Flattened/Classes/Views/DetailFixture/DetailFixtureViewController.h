//
//  DetailFixtureViewController.h
//  Flattened
//
//  Created by Diego Maye on 01/03/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailFixtureViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) NSDictionary *partido;
@property (strong, nonatomic) IBOutlet UIImageView *imagenLocatario;
@property (strong, nonatomic) IBOutlet UIImageView *imagenVisitante;
@property (strong, nonatomic) IBOutlet UILabel *txtLocatario;
@property (strong, nonatomic) IBOutlet UILabel *txtVisitante;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDescGral;
@property (strong, nonatomic) IBOutlet UILabel *fecha;
@property (strong, nonatomic) IBOutlet UILabel *hora;
@property (strong, nonatomic) IBOutlet UILabel *fechaLocal;
@property (strong, nonatomic) IBOutlet UILabel *horaLocal;
@property (strong, nonatomic) IBOutlet UILabel *estado;
@property (strong, nonatomic) IBOutlet UILabel *golesLocatario;
@property (strong, nonatomic) IBOutlet UILabel *golesVisitante;

@end
