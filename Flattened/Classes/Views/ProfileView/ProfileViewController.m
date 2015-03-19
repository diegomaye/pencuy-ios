//
//  ProfileViewController.m
//  Flattened
//
//  Created by Diego Maye on 01/06/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ProfileViewController.h"
#import "Utils.h"
#import "ADVTheme.h"
#import "AppDelegate.h"
#import "GraphicUtils.h"
#import "PencuyFetcher.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    [ADVThemeManager customizeView:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"USER PROFILE",nil);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeMenu) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0, 0, 40, 30);
        [menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        self.btnFacebookLogin.hidden = YES;
        self.btnLogout.hidden = NO;
    }
    Usuario* usuario = [AppDelegate getUsuario];
    if ([usuario faceID]!=nil&&![[usuario faceID] isEqualToString:@""]) {
        self.imgPerfil.hidden=YES;
        self.imgFacebook.hidden=NO;
        self.imgFacebook.profileID = usuario.faceID;
        [GraphicUtils makeSquadViewRounded:self.imgFacebook];
        self.btnFacebookLogin.hidden = NO;
        self.btnFacebookLogin.delegate = self;
        self.btnLogout.hidden = YES;
    }
    else{
        self.imgPerfil.hidden=NO;
        self.imgFacebook.hidden=YES;
        self.imgPerfil.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    self.lblNombreUsuario.text = usuario.nombreCompleto;
    self.lblCorreoUsuario.text = usuario.email;
    
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryProfile] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSDictionary *perfil= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //NSLog(@"Trajo el siguiente perfil: %@",perfil);
            self.lblTotalPuntosGanados.text = [NSString stringWithFormat:@"%@ %@", [perfil[@"totPGan"] stringValue], NSLocalizedString(@"Total Points Granted", nil)];
            self.lblResultadoExacto.text = [NSString stringWithFormat:@"%@ %@", [perfil[@"totApGanExa"] stringValue], NSLocalizedString(@"Exact Result", nil)];
            self.lblResultadoParcial.text = [NSString stringWithFormat:@"%@ %@", [perfil[@"totApGanNoExa"]stringValue], NSLocalizedString(@"Parcial Result", nil)];
            self.lblTotalApuestas.text = [NSString stringWithFormat:@"%@ %@", [perfil[@"totApuesta"] stringValue], NSLocalizedString(@"Total Bets", nil)];
            self.lblApuestasHechas.text = [NSString stringWithFormat:@"%@ %@", [perfil[@"totApIngresada"] stringValue], NSLocalizedString(@"Maked by me", nil)];
            int pendientes = [perfil[@"totApuesta"] intValue] - [perfil[@"totApIngresada"] intValue];
            self.lblApuestasPendientes.text = [NSString stringWithFormat:@"%i %@",pendientes, NSLocalizedString(@"Pending", nil)];
        }
        else if([data length]==0 && connectionError==nil){
            //NSLog(@"No hay info");
        }
        else if(connectionError!=nil){
            //NSLog(@"Sucedio un error: %@",connectionError);
        }
    }];
    self.lblPuntosGanados.text = NSLocalizedString(@"Points Earned", nil);
    self.lblApuestas.text = NSLocalizedString(@"Bets", nil);
    /*
     id: 1579
     email: "juancarrocio@gmail.com"
     nombreCompleto: "Juan Carrocio"
     idpais: 0
     pais: null
     fechaNacimiento: null
     fechaHoraCreacion: 1401581322498
     ultimaActividad: 1401762887588
     cantidadDiamantes: 1000
     imgToken: null
     estadoRelPenca: null
     tipoAsociacion: null
     totApuesta: 128
     totApIngresada: 0
     totApGanExa: 0
     totApGanNoExa: 0
     totPGan: 0
     totPozos: 2200
     totInvFace: 0
     totInvFaceIng: 0
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - facebook delegates

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoggedUser"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"USUARIO-PENCA"];
    [AppDelegate setUsuarioNil];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    LoginViewController* loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[AppDelegate sharedDelegate] closeSession];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:loginVC];
}

#pragma mark - Actions

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}
- (IBAction)touchLogut:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoggedUser"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"USUARIO-PENCA"];
    [AppDelegate setUsuarioNil];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    LoginViewController* loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.view.window setRootViewController:loginVC];
}

@end
