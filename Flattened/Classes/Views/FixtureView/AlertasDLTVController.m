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

//- (IBAction)touchOrden:(id)sender {
//    NSString* btnText = [self getDescBoton];
//    if ([btnText isEqualToString:@"ANTIGUOS"]) {
//        [self modificaLabel:@"Mensajes mas viejos primero"];
//        [self modificarDescBoton:@"NUEVOS"];
//        [self fetchAlertasOlderFirst];
//    }
//    else{
//        [self modificaLabel:@"Mensajes mas nuevos primero"];
//        [self modificarDescBoton:@"ANTIGUOS"];
//        [self fetchAlertas];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchAlertas];
}

-(void)fetchAlertas{
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryAlertas] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
            NSArray *alertas= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"Trajo las siguientes alertas: %@",alertas);
            self.alertas= alertas;
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

//-(void)fetchAlertasOlderFirst{
//    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryAlertas] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if ([data length] > 0 && connectionError==nil) {
//            NSArray *alertas= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            NSLog(@"Trajo las siguientes alertas: %@",alertas);
//            self.alertas= [[alertas reverseObjectEnumerator] allObjects];
//            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
//        }
//        else if([data length]==0 && connectionError==nil){
//            NSLog(@"No hay info");
//        }
//        else if(connectionError!=nil){
//            NSLog(@"Sucedio un error: %@",connectionError);
//        }
//    }];
//    
//}

@end
