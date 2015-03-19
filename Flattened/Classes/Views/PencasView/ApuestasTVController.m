//
//  ApuestasTVController.m
//  Flattened
//
//  Created by Diego Maye on 27/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ApuestasTVController.h"

#import "ADVTheme.h"

#import "DataSource.h"
#import "AppDelegate.h"

#import "ResultadoPartidoViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "SIAlertView.h"
#import "ApuestasDataLoaderTableViewController.h"
#import "ApuestasHoyDLTVController.h"

@interface ApuestasTVController (){
    NSIndexPath *currentIndex;
}


@end

@implementation ApuestasTVController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    [ADVThemeManager customizeView:self.view];
    
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
    self.apuestas = _apuestas;
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
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.apuestas){
        return self.apuestas.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.apuestas){
        NSString *CellIdentifier = @"CeldaPartido";
        ApuestaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSDictionary *apuesta = self.apuestas[indexPath.row];
        //NSLog(@"Listando Celda %lu", (long)indexPath.row);
        //NSLog(@"idApuesta%@", [apuesta valueForKey:@"idApuesta"]);
        cell.apuesta = apuesta;
        if ([[apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"BLOQUEADO"]||
            [[apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"INICIADO"]||
            [[apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"FINALIZADO"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else{
        return nil;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndex = indexPath;
    NSDictionary *apuesta = [[NSMutableDictionary alloc] initWithDictionary:[self.apuestas objectAtIndex:currentIndex.row]];
    if ([[apuesta valueForKey:@"tipo"] isEqualToString:@"A_DEFINIR"]) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry!", nil) andMessage:NSLocalizedString(@"First complete the matchs in the group stage", nil)];
        
        [alertView addButtonWithTitle:@"Ok"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                              }];
        
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
    else if ([[apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"BLOQUEADO"]||
             [[apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"INICIADO"]||
             [[apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"FINALIZADO"]) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry!", nil) andMessage:NSLocalizedString(@"You cannot modify the score at the moment, because the status..", nil)];
        
        [alertView addButtonWithTitle:@"Ok"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                              }];
        
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
    else if ([self isKindOfClass:[ApuestasDataLoaderTableViewController class]]) {
        [self performSegueWithIdentifier:@"showSeleccionApuesta" sender:self];
    }
    else if ([self isKindOfClass:[ApuestasHoyDLTVController class]]) {
        [self performSegueWithIdentifier:@"showSeleccionApuesta2" sender:self];
    }

    
}


#pragma mark - Segue
// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSeleccionApuesta"]) {
        UINavigationController *nav = segue.destinationViewController;
        ResultadoPartidoViewController *detailVC = nav.viewControllers[0];
            //Mensaje por defecto para el envio de la invitación
        NSMutableDictionary *apuesta = [[NSMutableDictionary alloc] initWithDictionary:[self.apuestas objectAtIndex:currentIndex.row]];
        detailVC.apuesta = apuesta;
        detailVC.fixture = self;
        
    }
}

@end
