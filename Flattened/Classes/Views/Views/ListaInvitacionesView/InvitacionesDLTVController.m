//
//  FixtureDataLoaderViewController.m
//  Flattened
//
//  Created by Diego Maye on 06/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "InvitacionesDLTVController.h"
@interface InvitacionesDLTVController ()

@end

@implementation InvitacionesDLTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        [self setProgressBar];
    }
    [self fetchInvitaciones];
}

-(void)fetchInvitaciones{
    [self showProgressBar];
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryInvitaciones] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSArray *invitaciones= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //NSLog(@"Trajo las siguientes invitaciones: %@",invitaciones);
            self.invitaciones= invitaciones;
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [self performSelector:@selector(setComplete) withObject:nil afterDelay:0.5];
        }
        else if([data length]==0 && connectionError==nil){
            //NSLog(@"No hay info");
            [self performSelector:@selector(setCompleteError) withObject:nil afterDelay:0.5];
        }
        else if(connectionError!=nil){
            //NSLog(@"Sucedio un error: %@",connectionError);
            [self performSelector:@selector(setCompleteError) withObject:nil afterDelay:0.5];
        }
        else {
            //NSLog(@"Error de conexion");
            [self performSelector:@selector(setCompleteError) withObject:nil afterDelay:0.5];
        }

    }];
    
}

@end
