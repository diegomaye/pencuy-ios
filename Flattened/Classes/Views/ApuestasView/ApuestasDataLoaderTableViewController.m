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

@end

@implementation ApuestasDataLoaderTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchApuestas:self.idPenca andFecha:[self.idFecha stringValue]];
}

-(void)fetchApuestas:(NSString *) idPenca andFecha:(NSString*)idFecha{
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryApuestasIdPenca:idPenca andFecha:idFecha] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSMutableArray *apuestas= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
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
