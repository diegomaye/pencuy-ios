//
//  InvitacionesPencaDLTVController.m
//  Flattened
//
//  Created by Diego Maye on 30/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "InvitacionesPencaDLTVController.h"
#import "PencuyFetcher.h"

@interface InvitacionesPencaDLTVController ()

@end

@implementation InvitacionesPencaDLTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchInvitaciones:self.idPenca];
}

-(void)fetchInvitaciones:(NSString *) idPenca{
    if (idPenca) {
        [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryInvitacionesByIdPenca:idPenca] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError==nil) {
                NSArray *invitaciones= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                //NSLog(@"Trajo las siguientes invitaciones para la penca %@: %@",idPenca,invitaciones);
                self.invitaciones= invitaciones;
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else if([data length]==0 && connectionError==nil){
                //NSLog(@"Nothing");
            }
            else if(connectionError!=nil){
                //NSLog(@"An error appends: %@",connectionError);
            }
        }];
    }    
}

@end
