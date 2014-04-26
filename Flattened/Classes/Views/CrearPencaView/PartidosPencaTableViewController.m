//
//  PartidosPencaTableViewController.m
//  Flattened
//
//  Created by Diego Maye on 18/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "PartidosPencaTableViewController.h"

@interface PartidosPencaTableViewController ()

@end

@implementation PartidosPencaTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        // Return the number of rows in the section.
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELDA" forIndexPath:indexPath];
    cell.textLabel.text = @"Partido";
    cell.detailTextLabel.text = @"Partidos para la apuesta";
        // Configure the cell...
    
    return cell;
}

@end
