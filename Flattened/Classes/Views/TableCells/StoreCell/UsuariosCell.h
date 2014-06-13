//
//  StoreCell.h
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface UsuariosCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblPosition;
@property (strong, nonatomic) IBOutlet UILabel *lblPuntos;
@property (strong, nonatomic) IBOutlet UILabel *lblCompletado;
@property (strong, nonatomic) IBOutlet UILabel *lblAcierto;

@property (strong, nonatomic) IBOutlet UIImageView *imageVAvatar;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *imageFacebook;
@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;


@end



