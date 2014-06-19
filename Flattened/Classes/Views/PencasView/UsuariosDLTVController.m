//
//  InvitacionesPencaDLTVController.m
//  Flattened
//
//  Created by Diego Maye on 30/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "UsuariosDLTVController.h"
#import "PencuyFetcher.h"


@implementation UsuariosDLTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self fetchPencas:self.idPenca];
}

-(void)fetchPencas:(NSString *) idPenca{
    if (idPenca) {
        [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryUsuariosPenca:idPenca] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError==nil) {
                NSArray *usuarios= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                NSLog(@"Trajo las siguientes usuarios para la penca %@: %@",idPenca,usuarios);
                self.usuarios= usuarios;
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else if([data length]==0 && connectionError==nil){
                NSLog(@"Nothing");
            }
            else if(connectionError!=nil){
                NSLog(@"An error appends: %@",connectionError);
            }
        }];
    }    
}

@end
