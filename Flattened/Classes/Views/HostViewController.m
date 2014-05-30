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
#import "DateUtility.h"

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
    
    self.title = @"ACTUALIZAR PENCA";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//         self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 30, 30);
    [btnBack setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UIButton *btnCompose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCompose.frame = CGRectMake(0, 0, 40, 30);
    [btnCompose setImage:[UIImage imageNamed:@"navigation-btn-settings"] forState:UIControlStateNormal];
    [btnCompose addTarget:self action:@selector(actionCompose:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCompose];
    
//    self.navigationItem.rightBarButtonItem = ({
//        
//        UIBarButtonItem *button;
//        button = [[UIBarButtonItem alloc] initWithTitle:@"Invitados" style:UIBarButtonItemStylePlain target:self action:@selector(selectTabWithNumberFive)];
//        
//        button;
//    });
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0];
    
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
    for (;index < [self.fechas count]; index++) {
        NSDictionary* fecha= self.fechas[index];
        NSDate *fechaFin = [DateUtility deserializeJsonDateString:[[fecha valueForKey:@"fechaFinalizacion"] stringValue] ];
        NSDate *fechaInicio = [DateUtility deserializeJsonDateString:[[fecha valueForKey:@"fechaInicio"] stringValue]];
        TabApuestaInfo* tabApuesta = [[TabApuestaInfo alloc] initWithTabApuestaId:[fecha valueForKey:@"idFechaCampeonato"]
                                                                          andName:[fecha valueForKey:@"nombre"]
                                                                   andDescription:[fecha valueForKey:@"descripcion"]
                                                                      andFechaFin:fechaFin andInicio:fechaInicio
                                                                andControllerName:apuestasViewController];
        
        [self.tabList setObject:tabApuesta forKey:[NSNumber numberWithInt:index]];
    }
    [self.tabList setObject:[[TabInfo alloc ] initWithTabName:@"Closed Matchs" andViewController:@"PartidosCerradosPenca"] forKey:[NSNumber numberWithInt:index++]];
    [self.tabList setObject:[[TabInfo alloc ] initWithTabName:@"Invitations" andViewController:@"InvitationsPencaView"] forKey:[NSNumber numberWithInt:index++]];
    [self.tabList setObject:[[TabInfo alloc ] initWithTabName:@"Users" andViewController:@"UsuariosView"] forKey:[NSNumber numberWithInt:index++]];
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
    label.font = [UIFont systemFontOfSize:12.0];
    NSString* tabName = [self getTabByIndex:index].tabName;
    label.text = [NSString stringWithFormat:tabName, (unsigned long)index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
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
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCompose"]) {
            //UINavigationController *nav = segue.destinationViewController;
            //DetailViewController *detailVC = nav.viewControllers[0];
            //
//        detailVC.item = @{@"recipients": @[@"Christian Bale", @"Tom Cruise", @"Morgan Freeman"],
//                          @"subject": @"Lorem ipsum dolor sit amet",
//                          @"body": @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis.\n\n"
//                          
//                          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.\n\n"
//                          
//                          "Nemo enim ipsam voluptatem quia"};
//        detailVC.editable = YES;
    }
}


@end
