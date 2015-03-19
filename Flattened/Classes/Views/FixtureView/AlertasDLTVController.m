//
//  FixtureDataLoaderViewController.m
//  Flattened
//
//  Created by Diego Maye on 06/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "AlertasDLTVController.h"
#import "PencuyFetcher.h"

@interface AlertasDLTVController ()

@end

@implementation AlertasDLTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchAlertas];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self viewWillAppear:animated];
//    [self fetchAlertas];
//}

-(void)fetchAlertas{
    [self showProgressBar];
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryAlertas] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSArray *alertas= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            self.alertas= alertas;
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
        }
        else if([data length]==0 && connectionError==nil){
            [self performSelector:@selector(setCompleteError) withObject:nil afterDelay:0.5];
        }
        else if(connectionError!=nil){
            [self performSelector:@selector(setCompleteError) withObject:nil afterDelay:0.5];
        }
        else {
            [self performSelector:@selector(setCompleteError) withObject:nil afterDelay:0.5];
        }

    }];
    
}


@end
