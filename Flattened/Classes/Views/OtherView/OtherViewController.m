//
//  OtherViewController.m
//  
//
//  Created by Valentin Filip on 5/27/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "OtherViewController.h"

#import "ADVTheme.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "GraphicUtils.h"
#import "PencuyFetcher.h"

@interface OtherViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIBarButtonItem *barButtonFromMaster;
@property (strong, nonatomic) NSArray* lstEquipos;
@property (strong, nonatomic) UIView* pickerContainerView;
@property int equipoEjejido;

@end

@implementation OtherViewController


- (void)viewDidLoad {
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    [ADVThemeManager customizeView:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"STATICS",nil);
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
    }
    [self setPickerView];
    [self setTouchEventView];
    self.lblEquipo1.text=NSLocalizedString(@"Select a country", nil);
    self.lblEquipo2.text=NSLocalizedString(@"Select a country", nil);

}

-(void) setTraducciones{
    self.lblMundiales.text= NSLocalizedString(@"WC won", nil);
    self.lblCopas.text = NSLocalizedString(@"Cups", nil);
    self.lblPuntos.text = NSLocalizedString(@"Points", nil);
    self.lblPJugados.text = NSLocalizedString(@"Matchs played", nil);
    self.lblPGanados.text = NSLocalizedString(@"Matchs won", nil);
    self.lblPPerdidos.text = NSLocalizedString(@"Lost Points", nil);
    self.lblGolesConv.text = NSLocalizedString(@"Goals Scored", nil);
    self.lblGolesRec.text = NSLocalizedString(@"Goals Against", nil);
}

-(void) setTouchEventView{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSomethingWhenTapped:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.viewContainer addGestureRecognizer:tapGestureRecognizer];
}

-(void)doSomethingWhenTapped:(id*) sender{
    [self hidePickerView];
}

-(void) setPickerView{
    
    self.pickerContainerView = [UIView new];
    self.lstEquipos = [PencuyFetcher multiFetcherGetArraySync:[PencuyFetcher URLtoQueryEquipos] withHTTP:@"GET" withData:nil];
    NSMutableDictionary *equipoDefault = [NSMutableDictionary new];
    [equipoDefault setValue:NSLocalizedString(@"Select a country", nil) forKey:@"nombre"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [mutableArray addObject:equipoDefault];
    [mutableArray addObjectsFromArray:self.lstEquipos];
    self.lstEquipos = mutableArray;
    self.pickerViewPaises = [UIPickerView new];
    CGRect rect=CGRectMake(0,self.view.frame.size.height,self.view.bounds.size.width,300);
    
    self.pickerContainerView.frame = rect;
    self.pickerContainerView.backgroundColor = [UIColor darkGrayColor];
    self.pickerContainerView.alpha = 0.9;
    [self setToolbar:self.pickerViewPaises];
    [self.pickerContainerView addSubview:self.pickerViewPaises];
    
    [self.view addSubview:self.pickerContainerView];
    
    self.pickerViewPaises.dataSource = self;
    self.pickerViewPaises.delegate = self;
}

-(void) setToolbar:(UIView*) pickerViewContainer{
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    //UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSString* desc = [NSString stringWithFormat:NSLocalizedString(@"Please select the team",nil)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(desc, nil) style:UIBarButtonItemStyleDone target:self action:@selector(ocultarVista:)];
    
    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects:done, nil]];
    
    //pickerViewContainer.inputAccessoryView = keyboardToolbar;
    [pickerViewContainer addSubview:keyboardToolbar];
}

-(void) setToolbar2:(UIView*) pickerViewContainer{
    UIView *keyboardToolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    //keyboardToolbar.alpha = 0.8;
    UIButton *botonAceptar =[[UIButton alloc] init];
    [botonAceptar addTarget:self action:@selector(ocultarVista:) forControlEvents:UIControlEventTouchDown];
    [keyboardToolbar addSubview:botonAceptar];
    //pickerViewContainer.inputAccessoryView = keyboardToolbar;
    [pickerViewContainer addSubview:keyboardToolbar];
}

-(void) ocultarVista:(id)sender{
    [self hidePickerView];
}

#pragma mark - Actions

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchEquipo1:(id)sender {
    self.equipoEjejido=1;
    [self.pickerViewPaises selectRow:0 inComponent:0 animated:YES];
    self.lblEquipo1.text=NSLocalizedString(@"Select a country", nil);
    [self showPickerView];
}

- (IBAction)touchEquipo2:(id)sender {
    self.equipoEjejido=2;
    [self.pickerViewPaises selectRow:0 inComponent:0 animated:YES];
    self.lblEquipo2.text=NSLocalizedString(@"Select a country", nil);
    [self showPickerView];
}


-(void) showPickerView{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -250);
	self.pickerContainerView.transform = transform;
	[self.view addSubview:self.pickerContainerView];
	[UIView commitAnimations];
}

-(void) hidePickerView{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 250);
	self.pickerContainerView.transform = transform;
	[self.view addSubview:self.pickerContainerView];
	[UIView commitAnimations];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.lstEquipos count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    
    
    //label.backgroundColor = [GraphicUtils colorDefault];
    label.textColor = [GraphicUtils colorDefault];
    label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:16];
    label.text = NSLocalizedString([self.lstEquipos[row] valueForKey:@"nombre"],nil);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.lstEquipos[row] valueForKey:@"nombre"];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString* nombre = [self.lstEquipos[row] valueForKey:@"nombre"];
    if (self.equipoEjejido == 1) {
        UIImage* imagen = [UIImage imageNamed:nombre];
        if (imagen) {
            self.equipo1.imageView.image = [UIImage imageNamed:nombre];
            self.lblEquipo1.text=NSLocalizedString(nombre,nil);
            [self setEstadisticasEquipo1:row];
        }
        else{
            self.equipo1.imageView.image = [UIImage imageNamed:@"field 4"];
            self.lblEquipo1.text=NSLocalizedString(@"Select a country", nil);
        }
        
    }
    else{
        UIImage* imagen = [UIImage imageNamed:nombre];
        if (imagen) {
            self.equipo2.imageView.image = [UIImage imageNamed:nombre];
            self.lblEquipo2.text=NSLocalizedString(nombre,nil);
            [self setEstadisticasEquipo2:row];
        }
        else{
            self.equipo2.imageView.image = [UIImage imageNamed:@"field 4"];
            self.lblEquipo2.text=NSLocalizedString(@"Select a country", nil);
        }
        
    }
    //if (![self.lblEquipo1.text isEqualToString:NSLocalizedString(@"Select a country", nil)]&&![self.lblEquipo2.text isEqualToString:NSLocalizedString(@"Select a country", nil)]) {
    
    //}
    //[self hidePickerView];
}

-(void) setEstadisticasEquipo1:(NSInteger)row{
    NSArray* estadistica = [PencuyFetcher multiFetcherGetArraySync:[PencuyFetcher URLtoQueryEstadisticas:[[self.lstEquipos[row] valueForKey:@"idEquipo"]stringValue]] withHTTP:@"GET" withData:nil];
    self.lblEquipo1MundGanados.text = [[estadistica[0] valueForKey:@"mundialesJugados"] stringValue];
    self.lblEquipo1Copas.text = [[estadistica[0] valueForKey:@"copasGanadas"] stringValue];
    self.lblEquipo1Puntos.text = [[estadistica[0] valueForKey:@"puntos"] stringValue];
    self.lblEquipo1PJugados.text = [[estadistica[0] valueForKey:@"partidosJugados"] stringValue];
    self.lblEquipo1PGanados.text = [[estadistica[0] valueForKey:@"partidosGanados"] stringValue];
    self.lblEquipo1PEmpatados.text = [[estadistica[0] valueForKey:@"partidosEmpatados"] stringValue];
    self.lblEquipo1PPerdidos.text = [[estadistica[0] valueForKey:@"partidosPerdidos"] stringValue];
    self.lblEquipo1GolesConvertidos.text = [[estadistica[0] valueForKey:@"golesFavor"] stringValue];
    self.lblEquipo1GolesRecividos.text = [[estadistica[0] valueForKey:@"golesContra"] stringValue];
}

-(void) set0EstadisticasEquipo1:(NSInteger)row{
    self.lblEquipo1MundGanados.text = @"0";
    self.lblEquipo1Copas.text = @"0";
    self.lblEquipo1Puntos.text = @"0";
    self.lblEquipo1PJugados.text = @"0";
    self.lblEquipo1PGanados.text = @"0";
    self.lblEquipo1PEmpatados.text = @"0";
    self.lblEquipo1PPerdidos.text = @"0";
    self.lblEquipo1GolesConvertidos.text = @"0";
    self.lblEquipo1GolesRecividos.text = @"0";
}

-(void) setEstadisticasEquipo2:(NSInteger)row{
    NSArray* estadistica = [PencuyFetcher multiFetcherGetArraySync:[PencuyFetcher URLtoQueryEstadisticas:[[self.lstEquipos[row] valueForKey:@"idEquipo"]stringValue]] withHTTP:@"GET" withData:nil];
    self.lblEquipo2MundGanados.text = [[estadistica[0] valueForKey:@"mundialesJugados"] stringValue];
    self.lblEquipo2Goles.text = [[estadistica[0] valueForKey:@"copasGanadas"] stringValue];
    self.lblEquipo2Puntos.text = [[estadistica[0] valueForKey:@"puntos"] stringValue];
    self.lblEquipo2PJugados.text = [[estadistica[0] valueForKey:@"partidosJugados"] stringValue];
    self.lblEquipo2PGanados.text = [[estadistica[0] valueForKey:@"partidosGanados"] stringValue];
    self.lblEquipo2PEmpatados.text = [[estadistica[0] valueForKey:@"partidosEmpatados"] stringValue];
    self.lblEquipo2PPerdidos.text = [[estadistica[0] valueForKey:@"partidosPerdidos"] stringValue];
    self.lblEquipo2GolesConvertidos.text = [[estadistica[0] valueForKey:@"golesFavor"] stringValue];
    self.lblEquipo2GolesRecividos.text = [[estadistica[0] valueForKey:@"golesContra"] stringValue];
}

-(void) set0EstadisticasEquipo2:(NSInteger)row{
    self.lblEquipo2MundGanados.text = @"0";
    self.lblEquipo2Goles.text = @"0";
    self.lblEquipo2Puntos.text = @"0";
    self.lblEquipo2PJugados.text = @"0";
    self.lblEquipo2PGanados.text = @"0";
    self.lblEquipo2PEmpatados.text = @"0";
    self.lblEquipo2PPerdidos.text = @"0";
    self.lblEquipo2GolesConvertidos.text = @"0";
    self.lblEquipo2GolesRecividos.text = @"0";
}

@end
