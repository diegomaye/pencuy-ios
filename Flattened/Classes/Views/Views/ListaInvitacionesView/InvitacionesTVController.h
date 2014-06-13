//
//  FixtureViewController.h
//  Flattened
//
//  Created by Diego Maye on 07/02/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PencuyFetcher.h"
#import "InvitacionesCell.h"
#import "MasterViewController.h"

@interface InvitacionesTVController : MasterViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *invitaciones;

@end
