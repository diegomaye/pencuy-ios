//
//  FixtureDataLoaderViewController.m
//  Flattened
//
//  Created by Diego Maye on 06/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "InvitacionesDLTVController.h"
#import "PencuyFetcher.h"

@interface InvitacionesDLTVController ()

@end

@implementation InvitacionesDLTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchInvitaciones];
}

-(void)fetchInvitaciones{
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryInvitaciones] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSArray *invitaciones= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"Trajo las siguientes invitaciones: %@",invitaciones);
            self.invitaciones= invitaciones;
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        else if([data length]==0 && connectionError==nil){
            NSLog(@"No hay info");
        }
        else if(connectionError!=nil){
            NSLog(@"Sucedio un error: %@",connectionError);
        }
    }];
    
}

@end
