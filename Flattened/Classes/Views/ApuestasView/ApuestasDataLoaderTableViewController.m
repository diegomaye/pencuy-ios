//
//  ApuestasDataLoaderTableViewController.m
//  Flattened
//
//  Created by Diego Maye on 24/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ApuestasDataLoaderTableViewController.h"

#import "PencuyFetcher.h"


@interface ApuestasDataLoaderTableViewController ()

@property (nonatomic, strong) NSArray *fechas;
@property (nonatomic, strong) NSDictionary *fechaSeleccionada;
@property (assign) int index;

@end

@implementation ApuestasDataLoaderTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchApuestas:self.idPenca];
}

-(void)fetchApuestas:(NSString *) idPenca{
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryApuestas:idPenca] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSMutableArray *apuestas= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            self.apuestas= apuestas;
            NSLog(@"Trajo los siguientes partidos para la fecha %@: %@",idPenca,apuestas);
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


@end
