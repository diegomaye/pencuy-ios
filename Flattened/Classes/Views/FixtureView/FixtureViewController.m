//
//  FixtureViewController.m
//  Flattened
//
//  Created by Diego Maye on 07/02/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "FixtureViewController.h"
#import "ADVTheme.h"
#import "AppDelegate.h"
#import "GraphicUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"


@interface FixtureViewController () {
    NSIndexPath *currentIndex;
}

@end

@implementation FixtureViewController

#pragma mark - View lifecycle

-(void)setPartidos:(NSArray *)partidos{
    _partidos= partidos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    [ADVThemeManager customizeView:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"GROUPS",nil);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeMenu) {
            UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            menuButton.frame = CGRectMake(0, 0, 40, 30);
            [menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
            [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        } else {
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
        }
    }
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:0.27f green:0.29f blue:0.31f alpha:1.00f];
    [self fechaLabel:NSLocalizedString(@"Grupos",nil) withLabel:(UILabel *)[self.tableView.tableHeaderView viewWithTag:1]];
    
    UIButton *btnFilter = (UIButton *)[self.tableView.tableHeaderView viewWithTag:2];
    UIButton *btnFilter2 = (UIButton *)[self.tableView.tableHeaderView viewWithTag:3];
    [self tipeadorBotones:btnFilter];
    [self tipeadorBotones:btnFilter2];
    /*Formato header*/
    self.lblTitlePuntos.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15];
    self.lblTitlePuntos.textColor = [UIColor whiteColor];
    
    [self formateadorLabel:self.lblPJ];
    [self formateadorLabel:self.lblG];
    [self formateadorLabel:self.lblE];
    [self formateadorLabel:self.lblP];
    [self formateadorLabel:self.lblGF];
    [self formateadorLabel:self.lblGC];
    [self formateadorLabel:self.lblPts];
    
    self.tableView.tableHeaderView = self.headerView;
}

-(void)formateadorLabel:(UILabel*)label{
    label.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:11];
    label.textColor = [UIColor whiteColor];
}

-(void) fechaLabel:(NSString *) titulo withLabel:(UILabel*)label{
    
    NSString *filterTitle = [NSString stringWithFormat:@"%@", titulo];
    const CGFloat fontSize = 18;
    
    UIFont *boldFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize];
    UIFont *regularFont = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    UIColor *regularColor = [UIColor whiteColor];
    UIColor *boldColor = [UIColor whiteColor];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           regularColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              boldFont, NSFontAttributeName,
                              boldColor, NSForegroundColorAttributeName, nil];
    const NSRange range = NSMakeRange(0, [titulo length]);
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:filterTitle
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    [label setAttributedText:attributedText];

}

- (void)tipeadorBotones:(UIButton*) boton{
    boton.layer.cornerRadius = 3;
    boton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:10];
    boton.backgroundColor = [UIColor colorWithRed:0.17f green:0.18f blue:0.20f alpha:1.00f];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.partidos = _partidos;
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - Actions

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}


#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.partidos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger* rows = [self.partidos[section][@"partidos"] count];
    return rows;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.partidos[section] valueForKeyPath:@"equipo"];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
    header.backgroundColor = [GraphicUtils colorFromRGBHexString:@"#bdc3c7"];
    /*Lable nombre equipo*/
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 200, 30)];
    textLabel.text = NSLocalizedString([self.partidos[section] valueForKey:@"equipo"], nil);
    textLabel.backgroundColor = [UIColor grayColor];
    textLabel.textColor = [GraphicUtils colorMidnightBlue];
    textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.lineBreakMode = 2;
    /*Lable para los puntos*/
    UILabel *textPoints = [self copyLabel:self.lblTitlePuntos withYPosition:30];
    UILabel * textPJ = [self copyLabel:self.lblPJ withYPosition:50];
    UILabel * textG = [self copyLabel:self.lblG withYPosition:50];
    UILabel * textE = [self copyLabel:self.lblE withYPosition:50];
    UILabel * textP = [self copyLabel:self.lblP withYPosition:50];
    UILabel * textGF = [self copyLabel:self.lblGF withYPosition:50];
    UILabel * textGC = [self copyLabel:self.lblGC withYPosition:50];
    UILabel * textPts = [self copyLabel:self.lblPts withYPosition:50];
    textPJ.text = [[self.partidos[section] valueForKey:@"partidosJugados"] stringValue];
    textG.text = [[self.partidos[section] valueForKey:@"partidosGanados"] stringValue];
    textE.text = [[self.partidos[section] valueForKey:@"partidosEmpatados"] stringValue];
    textP.text = [[self.partidos[section] valueForKey:@"partidosPerdidos"] stringValue];
    textGF.text = [[self.partidos[section] valueForKey:@"golesFavor"] stringValue];
    textGC.text = [[self.partidos[section] valueForKey:@"golesContra"] stringValue];
    textPts.text = [[self.partidos[section] valueForKey:@"puntos"] stringValue];

    textLabel.text = NSLocalizedString([self.partidos[section] valueForKey:@"equipo"], nil);
    textLabel.backgroundColor = [UIColor grayColor];
    textLabel.textColor = [GraphicUtils colorMidnightBlue];
    textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:17];
    textLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(25, 35, 40, 40)];
    image.image = [UIImage imageNamed:[self.partidos[section] valueForKey:@"equipo"]];
    [header addSubview:image];
    [header addSubview:textLabel];
    [header addSubview:textPoints];
    [header addSubview:textPJ];
    [header addSubview:textG];
    [header addSubview:textE];
    [header addSubview:textP];
    [header addSubview:textGF];
    [header addSubview:textGC];
    [header addSubview:textPts];
    
    return header;
}

-(UILabel*) copyLabel: (UILabel*) label withYPosition:(float) positionInY{
    UILabel* labelReturn = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, positionInY, label.frame.size.width, label.frame.size.height)];
    labelReturn.text = label.text;
    labelReturn.textColor = label.textColor;
    labelReturn.font = label.font;
    labelReturn.textAlignment = label.textAlignment;
    return labelReturn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CeldaPartido";
    PartidoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.partidos) {
        NSDictionary *partido = self.partidos[indexPath.section][@"partidos"][indexPath.row];
        cell.partido = partido;
    }
    
    return cell;
}
- (BOOL)allowsHeaderViewsToFloat{
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


@end

