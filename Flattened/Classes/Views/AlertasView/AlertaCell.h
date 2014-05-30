//
//  PartidoCell.h
//  Flattened
//
//  Created by Diego Maye on 05/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKRevealingTableViewCell.h"
#import <FacebookSDK/FacebookSDK.h>

@protocol AlertaCellDelegate;

@interface AlertaCell : ZKRevealingTableViewCell

@property (strong, nonatomic) NSDictionary *alerta;

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *body;

@property (strong, nonatomic) IBOutlet UILabel *fecha;

@property (strong, nonatomic) IBOutlet UIImageView *imagenPrincipal;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *imagenFacebook;

@property (strong, nonatomic) IBOutlet UIImageView *imagenTiempo;

@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;

@end
