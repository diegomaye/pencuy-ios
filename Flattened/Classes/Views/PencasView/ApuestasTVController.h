//
//  ApuestasTVController.h
//  Flattened
//
//  Created by Diego Maye on 27/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApuestaCell.h"
#import "MasterViewController.h"

@interface ApuestasTVController : MasterViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *apuestas;
@property (nonatomic, strong) NSString *idPenca;
@property (nonatomic, strong) NSNumber *idFecha;

@end
