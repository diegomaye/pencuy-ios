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
        NSLog(@"Listando Celda %d", indexPath.row);
        NSLog(@"idApuesta%@", [apuesta valueForKey:@"idApuesta"]);
            //localDesc
            //visitanteDesc
        NSMutableDictionary *partido = [[NSMutableDictionary alloc] initWithDictionary:[apuesta valueForKey:@"partido"]];
        [partido setValue:[apuesta valueForKey:@"localDesc"] forKey:@"local"];
        [partido setValue:[apuesta valueForKey:@"visitanteDesc"] forKey:@"visitante"];
        if (![[apuesta valueForKey:@"golesLocal"] isKindOfClass : [NSNull class]]) {
            [partido setValue:[apuesta valueForKey:@"golesLocal"] forKey:@"golesLocal"];
        }
        else{
            [partido setValue:[NSNumber numberWithInt:-1] forKey:@"golesLocal"];
        }
        if (![[apuesta valueForKey:@"golesVisitante"] isKindOfClass : [NSNull class]]) {
            [partido setValue:[apuesta valueForKey:@"golesVisitante"] forKey:@"golesVisitante"];
        }
        else{
            [partido setValue:[NSNumber numberWithInt:-1] forKey:@"golesVisitante"];
        }
        cell.partido = partido;        
        return cell;
    }
    else{
        return nil;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndex = indexPath;
    [self performSegueWithIdentifier:@"showSeleccionApuesta" sender:self];
}


#pragma mark - Segue

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
