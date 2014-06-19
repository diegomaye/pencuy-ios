//
//  PartidoCell.h
//  Flattened
//
//  Created by Diego Maye on 05/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ApuestaCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSDictionary *apuesta;
@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;

@property (strong, nonatomic) IBOutlet UIImageView *imageVisitante;
@property (strong, nonatomic) IBOutlet UILabel *lblResultadoVisitante;
@property (strong, nonatomic) IBOutlet UIImageView *imageLocatario;
@property (strong, nonatomic) IBOutlet UILabel *lblResultadoLocatario;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparadorResultado;

@property (strong, nonatomic) IBOutlet UILabel *lblPuntosGanados;
@property (strong, nonatomic) IBOutlet UILabel *lblResultadoApostado;
@property (strong, nonatomic) IBOutlet UILabel *lblYourBet;

@property (strong, nonatomic) IBOutlet UIImageView *imgEstado;
@property (strong, nonatomic) IBOutlet UIImageView *imgResultado;


@property (strong, nonatomic) IBOutlet UILabel *lblNombreLocatario;
@property (strong, nonatomic) IBOutlet UILabel *lblNombreVisitante;
@property (strong, nonatomic) IBOutlet UILabel *lblFechaPartido;
@property (strong, nonatomic) IBOutlet UILabel *lblEstado;

@end
