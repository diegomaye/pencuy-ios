//
//  ApuestasCerradasDLTVController.m
//  Flattened
//
//  Created by Diego Maye on 28/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ApuestasHoyDLTVController.h"

#import "PencuyFetcher.h"

@interface ApuestasHoyDLTVController ()

@end

@implementation ApuestasHoyDLTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchApuestas:self.idPenca];
}

-(void)fetchApuestas:(NSString *) idPenca{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryApuestasByDay:idPenca andDate:dateString] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSMutableArray *apuestas= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            self.apuestas= apuestas;
            //NSLog(@"Trajo los siguientes partidos para la fecha %@: %@",idPenca,apuestas);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        else if([data length]==0 && connectionError==nil){
            //NSLog(@"No trajo nada");
        }
        else if(connectionError!=nil){
            //NSLog(@"Dio error: %@",connectionError);
        }
    }];
}


@end
