//
//  PartidoCell.h
//  Flattened
//
//  Created by Diego Maye on 05/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartidoCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSDictionary *partido;
@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;

@property (strong, nonatomic) IBOutlet UIImageView *imageVisitante;
@property (strong, nonatomic) IBOutlet UIImageView *imageLocatario;

@property (strong, nonatomic) IBOutlet UILabel *lblFechaPartido;
@property (strong, nonatomic) IBOutlet UILabel *lblHoraPartido;
@property (strong, nonatomic) IBOutlet UILabel *lblResultado;

@property (strong, nonatomic) IBOutlet UILabel *lblLocatario;
@property (strong, nonatomic) IBOutlet UILabel *lblVisitante;

@end
