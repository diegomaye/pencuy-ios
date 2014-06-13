//
//  HostViewController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewPagerController.h"

@interface HostViewController : ViewPagerController

@property (nonatomic, strong) NSString* idPenca;
@property (nonatomic, strong) NSArray* fechas;
@property (nonatomic, strong) NSDictionary* infoPenca;

@property (strong, nonatomic) IBOutlet UILabel *lblNombrePenca;
@property (strong, nonatomic) IBOutlet UILabel *lblDescripcionPenca;
@property (strong, nonatomic) IBOutlet UILabel *lblPendientes;
@property (strong, nonatomic) IBOutlet UILabel *lblFinalizados;
@property (strong, nonatomic) IBOutlet UILabel *lblParticipantes;

@end
