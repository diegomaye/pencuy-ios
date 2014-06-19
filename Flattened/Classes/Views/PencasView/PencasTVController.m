//
//  PencasTVController.m
//  Flattened
//
//  Created by Diego Maye on 27/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "PencasTVController.h"
#import "ADVTheme.h"

#import "AppDelegate.h"

#import "DatosGrlsPencaViewController.h"
#import "HostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

@interface PencasTVController () {
    NSIndexPath *currentIndex;
}

@end

@implementation PencasTVController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self) {
        [self setProgressBar];
    }
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
    [self performSegueWithIdentifier:@"createPenca" sender:self];
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"createPenca"]) {
        UINavigationController *nav = segue.destinationViewController;
        DatosGrlsPencaViewController *detailVC = nav.viewControllers[0];
        detailVC.fechas = self.fechas;
        detailVC.pencas = self;

    } else if ([segue.identifier isEqualToString:@"showDetailPenca"]) {
        HostViewController* detailVC = segue.destinationViewController;
        NSDictionary* penca = self.pencas[currentIndex.row];
        detailVC.idPenca = [[penca valueForKey:@"idPenca"] stringValue];
        detailVC.infoPenca = penca;
        detailVC.fechas = self.fechas;
    }
}


@end
