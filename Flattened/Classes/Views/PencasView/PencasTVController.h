//
//  PencasTVController.h
//  Flattened
//
//  Created by Diego Maye on 27/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PencaCell.h"

#import "MasterViewController.h"

@interface PencasTVController : MasterViewController <UITableViewDataSource, UITableViewDelegate, ZKRevealingTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *pencas;
@property (nonatomic, strong) NSArray *fechas;

@end
