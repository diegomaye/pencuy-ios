//
//  FixtureViewController.h
//  Flattened
//
//  Created by Diego Maye on 07/02/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartidoCell.h"
#import "MasterViewController.h"

@interface FixtureViewController : MasterViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *partidos;
@property (nonatomic, strong) NSNumber *idFecha;
@property (strong, nonatomic) IBOutlet UILabel *lblTitlePuntos;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UILabel *lblPJ;
@property (strong, nonatomic) IBOutlet UILabel *lblG;
@property (strong, nonatomic) IBOutlet UILabel *lblE;
@property (strong, nonatomic) IBOutlet UILabel *lblP;
@property (strong, nonatomic) IBOutlet UILabel *lblGF;
@property (strong, nonatomic) IBOutlet UILabel *lblGC;
@property (strong, nonatomic) IBOutlet UILabel *lblPts;

-(void) fechaLabel:(NSString *) titulo withLabel:(UILabel*)label;

@end
