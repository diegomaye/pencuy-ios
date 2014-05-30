//
//  FixtureViewController.h
//  Flattened
//
//  Created by Diego Maye on 07/02/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertaCell.h"
#import "MasterViewController.h"

@interface AlertasTVController : MasterViewController <UITableViewDataSource, UITableViewDelegate, ZKRevealingTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *alertas;

//-(void) modificarDescBoton:(NSString*) texto;
//
//-(NSString*) getDescBoton;
//
//-(void) modificaLabel:(NSString *) titulo;

@end
