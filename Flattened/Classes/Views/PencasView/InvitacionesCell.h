//
//  StoreCell.h
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKRevealingTableViewCell.h"


@protocol StoreCellDelegate;


@interface InvitacionesCell : ZKRevealingTableViewCell

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblSender;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imageVAvatar;
@property (strong, nonatomic) IBOutlet UIImageView *imageVBkg;


@end



