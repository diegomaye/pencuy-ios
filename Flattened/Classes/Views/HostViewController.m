//
//  HostViewController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "HostViewController.h"
#import "TabApuestaInfo.h"
#import "ApuestasDataLoaderTableViewController.h"
#import "ApuestasCerradasDLTVController.h"
#import "InvitacionesPencaDLTVController.h"
#import "UsuariosDLTVController.h"
#import "DateUtility.h"
#import "GraphicUtils.h"
#import "THContactPickerViewController.h"

@interface HostViewController () <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic) NSUInteger numberOfTabs;

@property (nonatomic, strong) NSMutableDictionary* tabList;

@end

@implementation HostViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initTabList];
    
    self.dataSource = self;
    self.delegate = self;
    
    self.title = NSLocalizedString(@"UPDATE BET",nil);
    
    // Keeps tab bar below navigation bar on iOS 7.0+
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//         self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 30, 30);
    [btnBack setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    if ([self.infoPenca[@"puedeInvitar"] integerValue]==1) {
        UIButton *btnCompose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCompose.frame = CGRectMake(0, 0, 40, 30);
        [btnCompose setImage:[UIImage imageNamed:@"navigation-btn-send"] forState:UIControlStateNormal];
        [btnCompose addTarget:self action:@selector(actionCompose:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCompose];
    }
    
    

    self.lblNombrePenca.text = self.infoPenca[@"nombre"];
    self.lblDescripcionPenca.text = self.infoPenca[@"descripcion"];
    self.lblPendientes.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"PENDINGS", nil), [self.infoPenca[@"cantPPend"]stringValue]];
    self.lblFinalizados.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"ENDED", nil), [self.infoPenca[@"cantPFina"]stringValue]];
    self.lblParticipantes.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"PARTICIPANTS", nil), [self.infoPenca[@"cantUsuarios"]stringValue]];
    
    [self formatTitleLabel:self.lblNombrePenca withColor:[UIColor whiteColor] andFontSize:16];
    [self formatTitleLabel:self.lblDescripcionPenca withColor:[UIColor whiteColor] andFontSize:14];
    
    [self formatLabel:self.lblPendientes withColor:[GraphicUtils colorOrange]];
    [self formatLabel:self.lblFinalizados withColor:[GraphicUtils colorPumpkin]];
    [self formatLabel:self.lblParticipantes withColor:[GraphicUtils colorDefault]];
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0];
    
}

-(void) formatLabel: (UILabel*)label withColor:(UIColor*) color{
    label.textColor = color;
    label.font = [UIFont fontWithName:@"ProximaNova-Regular" size:10];
}

-(void) formatTitleLabel: (UILabel*)label withColor:(UIColor*) color andFontSize:(float)fontSize{
    label.textColor = color;
    label.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize];
}

- (void)actionCompose:(id)sender {
    [self performSegueWithIdentifier:@"showCompose" sender:self];
}

- (void)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initTabList{
    self.tabList = [NSMutableDictionary new];
    NSString* apuestasViewController= @"PartidosPenca";
    
    int index = 0;
    TabInfo* tabUsuarios = [[TabInfo alloc ] initWithTabName:NSLocalizedString(@"Ranking",nil) andViewController:@"UsuariosView"];
    [self.tabList setObject:tabUsuarios forKey:[NSNumber numberWithInt:index++]];
    //[self initTab:tabUsuarios];
    for (;index < [self.fechas count] + 1; index++) {
        NSDictionary* fecha= self.fechas[index-1];
        NSDate *fechaFin = [DateUtility deserializeJsonDateString:[[fecha valueForKey:@"fechaFinalizacion"] stringValue] ];
        NSDate *fechaInicio = [DateUtility deserializeJsonDateString:[[fecha valueForKey:@"fechaInicio"] stringValue]];
        TabApuestaInfo* tabApuesta = [[TabApuestaInfo alloc] initWithTabApuestaId:[fecha valueForKey:@"idFechaCampeonato"]
                                                                          andName:[fecha valueForKey:@"nombre"]
                                                                   andDescription:[fecha valueForKey:@"descripcion"]
                                                                      andFechaFin:fechaFin andInicio:fechaInicio
                                                                andControllerName:apuestasViewController];
        
        [self.tabList setObject:tabApuesta forKey:[NSNumber numberWithInt:index]];
        //[self initTab:tabApuesta];
    }
    TabInfo* tabInfoInvitaciones= [[TabInfo alloc ] initWithTabName:NSLocalizedString(@"Invitations",nil) andViewController:@"InvitationsPencaView"];
    [self.tabList setObject:tabInfoInvitaciones forKey:[NSNumber numberWithInt:index++]];
    //[self initTab:tabInfoInvitaciones];
}

-(void) initTab:(TabInfo*)tabInfo{
    UIViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:tabInfo.viewControllerName];
    if ([tabInfo isKindOfClass:TabApuestaInfo.class] && [cvc isKindOfClass:[ApuestasDataLoaderTableViewController class]]) {
        ApuestasDataLoaderTableViewController* apuesta = ((ApuestasDataLoaderTableViewController*)cvc);
        TabApuestaInfo* tabApuestaInfo = ((TabApuestaInfo*)tabInfo);
        apuesta.idPenca = self.idPenca;
        apuesta.idFecha = tabApuestaInfo.idFechaCampeonato;
        [apuesta fetchApuestas:apuesta.idPenca andFecha:[apuesta.idFecha stringValue]];
    }
    else if ([cvc isKindOfClass:[InvitacionesPencaDLTVController class]]) {
        InvitacionesPencaDLTVController* invitaciones = ((InvitacionesPencaDLTVController*)cvc);
        invitaciones.idPenca = self.idPenca;
        [invitaciones fetchInvitaciones:self.idPenca];
    }
    else if ([cvc isKindOfClass:[UsuariosDLTVController class]]) {
        UsuariosDLTVController* usuarios = ((UsuariosDLTVController*)cvc);
        usuarios.idPenca = self.idPenca;
        [usuarios fetchPencas:self.idPenca];
        [usuarios.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}

#pragma mark - Helpers
- (void)selectTabWithNumberFive {
    [self selectTabAtIndex:5];
}
- (void)loadContent {
    self.numberOfTabs = [self.tabList count];
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
    NSString* tabName = [self getTabByIndex:index].tabName;
    NSString* translated = NSLocalizedString(tabName, nil);
    label.text = [NSString stringWithFormat:translated, (unsigned long)index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    TabInfo* tabInfo = [self getTabByIndex:index];
    UIViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:tabInfo.viewControllerName];
    if ([tabInfo isKindOfClass:TabApuestaInfo.class] && [cvc isKindOfClass:[ApuestasDataLoaderTableViewController class]]) {
        ApuestasDataLoaderTableViewController* apuesta = ((ApuestasDataLoaderTableViewController*)cvc);
        TabApuestaInfo* tabApuestaInfo = ((TabApuestaInfo*)tabInfo);
        apuesta.idPenca = self.idPenca;
        apuesta.idFecha = tabApuestaInfo.idFechaCampeonato;
    }
    else if ([cvc isKindOfClass:[ApuestasCerradasDLTVController class]]) {
        ApuestasCerradasDLTVController* apuesta = ((ApuestasCerradasDLTVController*)cvc);
        apuesta.idPenca = self.idPenca;
    }
    else if ([cvc isKindOfClass:[InvitacionesPencaDLTVController class]]) {
        InvitacionesPencaDLTVController* invitaciones = ((InvitacionesPencaDLTVController*)cvc);
        invitaciones.idPenca = self.idPenca;
    }
    else if ([cvc isKindOfClass:[UsuariosDLTVController class]]) {
        UsuariosDLTVController* usuarios = ((UsuariosDLTVController*)cvc);
        usuarios.idPenca = self.idPenca;
    }
    
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 30.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 96.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 1.0;
        default:
            return value;
    }
}

-(TabInfo*) getTabByIndex:(NSUInteger*)option{
    TabInfo* tabInfo = [self.tabList objectForKey:[NSNumber numberWithInteger:option]];

    return tabInfo;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor whiteColor];
        case ViewPagerTabsView:
            return [GraphicUtils colorDefault];
        case ViewPagerContent:
            return [GraphicUtils colorDefault];;
        default:
            return color;
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCompose"]) {
            UINavigationController *nav = segue.destinationViewController;
            THContactPickerViewController *detailVC = nav.viewControllers[0];
            //Mensaje por defecto para el envio de la invitación
            detailVC.idPenca = self.idPenca;
    }
}


@end
