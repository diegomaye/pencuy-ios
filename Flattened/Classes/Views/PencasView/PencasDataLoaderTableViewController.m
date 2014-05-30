//
//  PencasDataLoaderTableViewController.m
//  Flattened
//
//  Created by Diego Maye on 26/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "PencasDataLoaderTableViewController.h"


#import "PencuyFetcher.h"

@interface PencasDataLoaderTableViewController ()

@end

@implementation PencasDataLoaderTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchFechas];
}

-(void)fetchPencas{
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryPencas] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSArray *pencas= [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:NULL];
            self.pencas = pencas;//[[pencas reverseObjectEnumerator] allObjects];;
            NSLog(@"Trajo las siguientes pencas: %@",pencas);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        else if([data length]==0 && connectionError==nil){
            NSLog(@"No trajo nada");
        }
        else if(connectionError!=nil){
            NSLog(@"Dio error: %@",connectionError);
        }
    }];
}
-(void)fetchFechas{
    if (!self.fechas) {
        [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryFechas:@"Brazil 2014"] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError==nil) {
                NSArray *fechas= [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:NULL];
                self.fechas= fechas;
                NSLog(@"Trajo las siguientes fechas: %@",fechas);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fetchPencas];
                });

            }
            else if([data length]==0 && connectionError==nil){
                NSLog(@"No trajo nada");
            }
            else if(connectionError!=nil){
                NSLog(@"Dio error: %@",connectionError);
            }
        }];
    }
}

@end
