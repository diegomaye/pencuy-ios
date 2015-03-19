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
#import "FixtureViewController.h"

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
    if (![_fechaSeleccionada[@"nombre"] isEqualToString:@"Group H"]) {
        _index++;
        _index = (_index>[_fechas count]-1)?((int)[_fechas count])-1:_index;
        _fechaSeleccionada = _fechas[_index];
        [self fechaLabel:_fechaSeleccionada[@"nombre"] withLabel:(UILabel *)[self.tableView.tableHeaderView viewWithTag:1]];
        [self fetchPartidos:[_fechaSeleccionada[@"idFechaCampeonato"] stringValue]];
        if ([_fechaSeleccionada[@"nombre"] isEqualToString:@"Group H"]) {
            self.btnNext.hidden=YES;
        }
        if ([_fechaSeleccionada[@"nombre"] isEqualToString:@"Group B"]) {
            self.btnBack.hidden=NO;
        }
    }
    
}

- (IBAction)touchAnterior:(id)sender {
    if ([_fechaSeleccionada[@"descripcion"] isEqualToString:@"Groups"]) {
        _index--;
        _index = (_index<0)?0:_index;
        _fechaSeleccionada = _fechas[_index];
        [self fechaLabel:_fechaSeleccionada[@"nombre"] withLabel:(UILabel *)[self.tableView.tableHeaderView viewWithTag:1]];
        [self fetchPartidos:[_fechaSeleccionada[@"idFechaCampeonato"] stringValue]];
        if ([_fechaSeleccionada[@"nombre"] isEqualToString:@"Group G"]) {
            self.btnNext.hidden=NO;
        }
        if ([_fechaSeleccionada[@"nombre"] isEqualToString:@"Group A"]) {
            self.btnBack.hidden=YES;
        }
    }
    
}

-(void)fetchFechas{
    [self showProgressBar];
    if (!_fechas) {
        [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryFechas:@"Brazil 2014"] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError==nil) {
                NSArray *fechas= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                self.fechas= fechas;
                //NSLog(@"Trajo las siguientes fechas: %@",fechas);
                    //dispatch_async(dispatch_get_main_queue(), ^{
                    //NSLog(@"////////////////////SE EJECUTO EL FETCH DE FECHAS////////////////////////");
                    _fechaSeleccionada= self.fechas[0];
                    _index= 0;
                    [self fechaLabel:_fechaSeleccionada[@"nombre"] withLabel:(UILabel *)[self.tableView.tableHeaderView viewWithTag:1]];
                    [self fetchPartidos:[_fechaSeleccionada[@"idFechaCampeonato"] stringValue]];
                    //});
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
    else{
        _fechaSeleccionada = self.fechas[0];
        _index= 0;
        [self fechaLabel:_fechaSeleccionada[@"nombre"] withLabel:(UILabel *)[self.tableView.tableHeaderView viewWithTag:1]];
        [self fetchPartidos:[_fechaSeleccionada[@"idFechaCampeonato"] stringValue]];
    }
}

-(void)fetchPartidos:(NSString *) idFecha{
    [self showProgressBar];
    [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQueryResumenGrupos:idFecha] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data &&[data length] > 0 && connectionError==nil) {
            NSArray *partidos= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //NSLog(@"Trajo los siguientes partidos para la fecha %@: %@",idFecha,partidos);
            self.partidos= partidos;
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
