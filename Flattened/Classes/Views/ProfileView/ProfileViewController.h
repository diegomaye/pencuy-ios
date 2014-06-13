//
//  ProfileViewController.h
//  Flattened
//
//  Created by Diego Maye on 01/06/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController : UIViewController<FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgPerfil;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *imgFacebook;

@property (strong, nonatomic) IBOutlet UILabel *lblNombreUsuario;
@property (strong, nonatomic) IBOutlet UILabel *lblCorreoUsuario;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogoFacebook;
@property (strong, nonatomic) IBOutlet FBLoginView *btnFacebookLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;

//Labels
@property (strong, nonatomic) IBOutlet UILabel *lblInvitedAndConnected;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPuntosGanados;
@property (strong, nonatomic) IBOutlet UILabel *lblResultadoExacto;
@property (strong, nonatomic) IBOutlet UILabel *lblResultadoParcial;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalApuestas;
@property (strong, nonatomic) IBOutlet UILabel *lblApuestasHechas;
@property (strong, nonatomic) IBOutlet UILabel *lblApuestasPendientes;

@property (strong, nonatomic) IBOutlet UILabel *lblPuntosGanados;
@property (strong, nonatomic) IBOutlet UILabel *lblApuestas;

@end
