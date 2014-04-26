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

@interface FixtureViewController : MasterViewController <UITableViewDataSource, UITableViewDelegate, ZKRevealingTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *partidos;
@property (nonatomic, strong) NSMutableArray *apuestas;
@property (nonatomic, strong) NSString *idPenca;

-(void) fechaLabel:(NSString *) titulo;

@end
