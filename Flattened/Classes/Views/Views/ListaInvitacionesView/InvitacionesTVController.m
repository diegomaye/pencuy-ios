//
//  FixtureViewController.m
//  Flattened
//
//  Created by Diego Maye on 07/02/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//


#import "InvitacionesTVController.h"
#import "ADVTheme.h"

#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

#import "SIAlertView.h"
#import "InvitacionesDLTVController.h"

@interface InvitacionesTVController () {
    NSIndexPath *currentIndex;
}

@property(nonatomic,strong) UILabel* lblNoRowSelected;

@end

@implementation InvitacionesTVController

#pragma mark - View lifecycle

-(void)setInvitaciones:(NSArray *)invitaciones{
    _invitaciones = invitaciones;
    [self.tableView reloadData];
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
    self.tableView.delegate = self;
    [self addNotInformationMessage:NSLocalizedString(@"There is not invitation \n to display at the moment!",nil)];
    //[self setProgressBar];
    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:0.27f green:0.29f blue:0.31f alpha:1.00f];
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.invitaciones = _invitaciones;
    [self.tableView reloadData];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvitacionesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CeldaPartido"];

    NSDictionary *invitacion = self.invitaciones[indexPath.row];
    cell.data = invitacion;
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentIndex = indexPath;
    NSDictionary* invitacion = self.invitaciones[currentIndex.row];
    NSString* idInvitacion= [invitacion valueForKey:@"idInvitacion"];
    SIAlertView* alertView = [[SIAlertView alloc]initWithTitle:NSLocalizedString(@"Invitation", nil) andMessage:NSLocalizedString(@"Would you like to accept the inviation?", nil)];
    
    [alertView addButtonWithTitle:NSLocalizedString(@"No",nil)
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [PencuyFetcher multiFetcherSync:[PencuyFetcher URLtoAceptRevocarInvitacion:idInvitacion withBooleanSting:@"false"] withHTTP:@"PUT" withData:nil];
                              [((InvitacionesDLTVController*)self) fetchInvitaciones];
                          }];
    [alertView addButtonWithTitle:NSLocalizedString(@"Yes",nil)
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [PencuyFetcher multiFetcherSync:[PencuyFetcher URLtoAceptRevocarInvitacion:idInvitacion withBooleanSting:@"true"] withHTTP:@"PUT" withData:nil];
                              if ([self isKindOfClass:InvitacionesDLTVController.class]) {
                                  [((InvitacionesDLTVController*)self) fetchInvitaciones];
                              }
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //If there is no table data, unhide the "No matches" view
    if([self.invitaciones count] == 0 ){
        _lblNoRowSelected.hidden = NO;
    } else {
        _lblNoRowSelected.hidden = YES;
    }
    return [self.invitaciones count];
}

- (void) addNotInformationMessage:(NSString*) message{
    _lblNoRowSelected = [[UILabel alloc] init];
    _lblNoRowSelected.text = message;
    _lblNoRowSelected.textAlignment = NSTextAlignmentCenter;
    _lblNoRowSelected.numberOfLines = 4;
    _lblNoRowSelected.shadowColor = [UIColor blackColor];
    _lblNoRowSelected.shadowOffset = CGSizeMake(0, 0.5);
    _lblNoRowSelected.alpha = 0.5;
    _lblNoRowSelected.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y-50, self.tableView.frame.size.width,self.tableView.frame.size.height);//self.tableView.frame;
    //[_lblNoRowSelected sizeToFit ];
    _lblNoRowSelected.layer.zPosition=1;
    self.tableView.layer.zPosition=2;
    _lblNoRowSelected.hidden = YES;
    [self.view addSubview: _lblNoRowSelected];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

@end

