//
//  StoreCell.h
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PencaCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *penca;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblUsuarios;

@property (strong, nonatomic) IBOutlet UILabel *lblPozo;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;

    //cantidad de plata(icono, label),jugadores(icono, label), dias(icono) 
@end



