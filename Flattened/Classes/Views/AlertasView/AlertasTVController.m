//
//  FixtureViewController.m
//  Flattened
//
//  Created by Diego Maye on 07/02/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "AlertasTVController.h"

#import "ADVTheme.h"

#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>
#import "Utils.h"


@interface AlertasTVController () {
    NSIndexPath *currentIndex;
}
@end

@implementation AlertasTVController
#pragma mark - View lifecycle

-(void)setAlertas:(NSArray *)alertas{
    _alertas = alertas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self) {
        [self setProgressBar];
    }
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    [ADVThemeManager customizeView:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"COVER",nil);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeMenu) {
            self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.menuButton.frame = CGRectMake(0, 0, 40, 30);
            [self.menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
            [self.menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
        } else {
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
        }
    }
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:0.27f green:0.29f blue:0.31f alpha:1.00f];
}



- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.alertas = _alertas;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.alertas) {
        return self.alertas.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CeldaPartido";
    AlertaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.alertas) {
        NSDictionary *alerta = self.alertas[indexPath.row];
        cell.alerta = alerta;
//        cell.backView.frame = CGRectMake(0, 0, 190, [self tableView:_tableView heightForRowAtIndexPath:nil]);
//        cell.backView.backgroundColor = [UIColor colorWithRed:0.91f green:0.38f blue:0.39f alpha:1.00f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    for(UIView *cellItem in cell.backView.subviews) {
//        [cellItem removeFromSuperview];
//    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

@end

