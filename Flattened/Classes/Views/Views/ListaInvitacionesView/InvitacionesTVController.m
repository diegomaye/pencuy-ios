//
//  FixtureViewController.m
//  Flattened
//
//  Created by Diego Maye on 07/02/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//


#import "InvitacionesTVController.h"
#import "ADVTheme.h"

#import "DataSource.h"
#import "AppDelegate.h"

#import "ResultadoPartidoViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "Utils.h"


@interface InvitacionesTVController () {
    NSIndexPath *currentIndex;
}

@property (strong, nonatomic) ZKRevealingTableViewCell *currentlyRevealedCell;

@end




@implementation InvitacionesTVController

#pragma mark - View lifecycle

-(void)setInvitaciones:(NSArray *)invitaciones{
    _invitaciones = invitaciones;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    [ADVThemeManager customizeView:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"INVITATIONS",nil);
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
    
}


- (void)tipeadorBotones:(UIButton*) boton{
    boton.layer.cornerRadius = 3;
    boton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:10];
    boton.backgroundColor = [UIColor colorWithRed:0.17f green:0.18f blue:0.20f alpha:1.00f];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.invitaciones = _invitaciones;
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

- (void)actionCompose:(id)sender {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.invitaciones) {
        return self.invitaciones.count;
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CeldaPartido";
    InvitacionesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[InvitacionesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    if (self.invitaciones) {
        
        NSDictionary *invitacion = self.invitaciones[indexPath.row];
        cell.data = invitacion;
        cell.delegate = self;
        cell.backView.frame = CGRectMake(0, 0, 190, [self tableView:_tableView heightForRowAtIndexPath:nil]);
        cell.backView.backgroundColor = [UIColor colorWithRed:0.91f green:0.38f blue:0.39f alpha:1.00f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.direction = ZKRevealingTableViewCellDirectionRight;
        
        for(UIView *cellItem in cell.backView.subviews) {
            [cellItem removeFromSuperview];
        }
        
        UIButton *btnManage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnManage.frame = CGRectMake(10, 20, 36, 37);
        btnManage.contentMode = UIViewContentModeCenter;
        [btnManage setImage:[UIImage imageNamed:@"email_actions_reply"]
                   forState:UIControlStateNormal];
        [cell.backView addSubview:btnManage];
        
        UIButton *btnMess = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMess.frame = CGRectMake(55, 20, 39, 37);
        btnMess.contentMode = UIViewContentModeCenter;
        [btnMess setImage:[UIImage imageNamed:@"email_actions_forward"]
                 forState:UIControlStateNormal];
        [cell.backView addSubview:btnMess];
        
        UIButton *btnLeave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLeave.frame = CGRectMake(105, 20, 36, 37);
        btnLeave.contentMode = UIViewContentModeCenter;
        [btnLeave setImage:[UIImage imageNamed:@"email_actions_move"]
                  forState:UIControlStateNormal];
        [cell.backView addSubview:btnLeave];
        
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame = CGRectMake(140, 15, 56, 47);
        btnDelete.contentMode = UIViewContentModeCenter;
        [btnDelete setImage:[UIImage imageNamed:@"email_actions_delete"]
                   forState:UIControlStateNormal];
        [cell.backView addSubview:btnDelete];
        
        
    } else { // the datasource is empty - print a message
             //UIImageView* view= [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"715-globe-selected"]];
            //
        UILabel* view = [[UILabel alloc] init];
        view.text = NSLocalizedString(@"There is no information \n to display at the moment!",nil);
        view.textAlignment = NSTextAlignmentCenter;
        view.numberOfLines = 2;
        view.shadowColor = [UIColor blackColor];
        view.shadowOffset = CGSizeMake(0, 0.5);
        view.alpha = 0.5;
        view.frame= tableView.frame;
        [tableView removeFromSuperview];
        [self.view addSubview: view];

    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - ZKRevealingTableViewCellDelegate

- (BOOL)cellShouldReveal:(ZKRevealingTableViewCell *)cell {
	return YES;
}

- (void)cellDidReveal:(InvitacionesCell *)cell {
        //NSLog(@"Revealed Cell with name: %@", cell.lblTitle.text);
	self.currentlyRevealedCell = cell;
}

- (void)cellDidBeginPan:(ZKRevealingTableViewCell *)cell {
	if (cell != self.currentlyRevealedCell)
		self.currentlyRevealedCell = nil;
}

@end

