//
//  PencasTVController.m
//  Flattened
//
//  Created by Diego Maye on 27/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "PencasTVController.h"

#import "ADVTheme.h"

#import "DataSource.h"
#import "AppDelegate.h"

#import "DatosGrlsPencaViewController.h"
#import "HostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

@interface PencasTVController () {
    NSIndexPath *currentIndex;
}

@property (strong, nonatomic) ZKRevealingTableViewCell *currentlyRevealedCell;

@end

@implementation PencasTVController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    [ADVThemeManager customizeView:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"BETS",nil);
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
    
    UIButton *btnCompose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCompose.frame = CGRectMake(0, 0, 40, 30);
    [btnCompose setImage:[UIImage imageNamed:@"navigation-btn-settings"] forState:UIControlStateNormal];
    [btnCompose addTarget:self action:@selector(actionCompose:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCompose];
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:0.27f green:0.29f blue:0.31f alpha:1.00f];
    
    NSString *filterTitle = [NSString stringWithFormat:@"Showing %@ of %@", @10, @52];
    UILabel *labelFilter = (UILabel *)[self.tableView.tableHeaderView viewWithTag:1];
    
    const CGFloat fontSize = 14;
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
    const NSRange range = NSMakeRange(8, 2);
    
        // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:filterTitle
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    const NSRange range1 = NSMakeRange(13, 3);
    [attributedText setAttributes:subAttrs range:range1];
    
    [labelFilter setAttributedText:attributedText];
    
    UIButton *btnFilter = (UIButton *)[self.tableView.tableHeaderView viewWithTag:2];
    btnFilter.layer.cornerRadius = 2;
    btnFilter.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:10];
    btnFilter.backgroundColor = [UIColor colorWithRed:0.17f green:0.18f blue:0.20f alpha:1.00f];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.pencas= _pencas;
    self.fechas= _fechas;
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - Actions

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

- (void)actionCompose:(id)sender {
    [self performSegueWithIdentifier:@"createUser" sender:self];
}




#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.pencas) {
        return self.pencas.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PencaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Penca Cell"];
    
    NSDictionary *penca = self.pencas[indexPath.row];
    cell.penca = penca;
    
    cell.delegate       = self;
    cell.backView.frame = CGRectMake(0, 0, 190, [self tableView:_tableView heightForRowAtIndexPath:nil]);
    cell.backView.backgroundColor = [UIColor colorWithRed:0.91f green:0.38f blue:0.39f alpha:1.00f];
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
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentIndex = indexPath;
    [self performSegueWithIdentifier:@"showDetailPenca" sender:self];
}

#pragma mark - ZKRevealingTableViewCellDelegate

- (BOOL)cellShouldReveal:(ZKRevealingTableViewCell *)cell {
	return YES;
}

- (void)cellDidReveal:(PencaCell *)cell {
	NSLog(@"Revealed Cell with name: %@", cell.lblTitle.text);
	self.currentlyRevealedCell = cell;
}

- (void)cellDidBeginPan:(ZKRevealingTableViewCell *)cell {
	if (cell != self.currentlyRevealedCell)
		self.currentlyRevealedCell = nil;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"createUser"]) {
        UINavigationController *nav = segue.destinationViewController;
        DatosGrlsPencaViewController *detailVC = nav.viewControllers[0];
        detailVC.fechas = self.fechas;
        detailVC.pencas = self;

    } else if ([segue.identifier isEqualToString:@"showDetailPenca"]) {
        HostViewController* detailVC = segue.destinationViewController;
        NSDictionary* penca = self.pencas[currentIndex.row];
        detailVC.idPenca = [[penca valueForKey:@"idPenca"] stringValue];
        detailVC.fechas = self.fechas;
    }
}


@end
