//
//  MasterViewController.h
//  
//
//  Created by Valentin Filip on 10/23/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsuariosCell.h"

#import "MasterViewController.h"

@interface UsuariosTVController : MasterViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* usuarios;

@end
