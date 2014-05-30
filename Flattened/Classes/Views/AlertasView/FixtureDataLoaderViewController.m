//
//  FixtureDataLoaderViewController.m
//  Flattened
//
//  Created by Diego Maye on 06/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "FixtureDataLoaderViewController.h"
#import "PencuyFetcher.h"
#import "NSThread+BlockPerforming.h"

@interface FixtureDataLoaderViewController ()

@property (nonatomic, strong) NSArray *fechas;
@property (nonatomic, strong) NSDictionary *fechaSeleccionada;
@property (assign) int index;

@end

@implementation FixtureDataLoaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchFechas];
}

- (IBAction)touchProximo:(id)sender {
    _index++;
    _index = (_index>[_fechas count]-1)?[_fechas count]-1:_index;
    _fechaSeleccionada = _fechas[_index];
    [self fechaLabel:_fechaSeleccionada[@"nombre"]];
    [self fetchPartidos:[_fechaSeleccionada[@"idFechaCampeonato"] stringValue]];
}

- (IBAction)touchAnterior:(id)sender {
    _index--;
    _index = (_index<0)?0:_index;
    _fechaSeleccionada = _fechas[_index];
    [self fechaLabel:_fechaSeleccionada[@"nombre"]];
    [self fetchPartidos:[_fechaSeleccionada[@"idFechaCampeonato"] stringValue]];
}

-(void)fetchFechas{
    if (!_fechas) {
        [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryFechas:@"Brazil 2014"] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError==nil) {
                NSArray *fechas= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                self.fechas= fechas;
                NSLog(@"Trajo las siguientes fechas: %@",fechas);
                    //dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"////////////////////SE EJECUTO EL FETCH DE FECHAS////////////////////////");
                    _fechaSeleccionada= self.fechas[0];
                    _index= 0;
                    [self fechaLabel:_fechaSeleccionada[@"nombre"]];
                    [self fetchPartidos:[_fechaSeleccionada[@"idFechaCampeonato"] stringValue]];
                    //});
            }
            else if([data length]==0 && connectionError==nil){
                NSLog(@"No trajo nada");
            }
            else if(connectionError!=nil){
                NSLog(@"Dio error: %@",connectionError);
            }
        }];
    }
    else{
        _fechaSeleccionada = self.fechas[0];
        _index= 0;
        [self fechaLabel:_fechaSeleccionada[@"nombre"]];
        [self fetchPartidos:[_fechaSeleccionada[@"idFechaCampeonato"] stringValue]];
    }
}

-(void)fetchPartidos:(NSString *) idFecha{
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryPartido:idFecha] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"Dio error: %@",connectionError);
        if (data &&[data length] > 0 && connectionError==nil) {
            NSArray *partidos= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"Trajo los siguientes partidos para la fecha %@: %@",idFecha,partidos);
            //dispatch_async(dispatch_get_main_queue(), ^{
            //[[NSThread mainThread]  performBlock:^{
            self.partidos= partidos;
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                //}];
            //});
        }
        else if([data length]==0 && connectionError==nil){
            NSLog(@"Nothing");
        }
        else if(connectionError!=nil){
            NSLog(@"An error appends: %@",connectionError);
        }
    }];
    
}

@end
