//
//  PencasTableViewController.h
//  Flattened
//
//  Created by Diego Maye on 21/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface PencasTableViewController : MasterViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
