//
//  EPencaEstado.m
//  Flattened
//
//  Created by Diego Maye on 24/11/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "EPencaEstado.h"

@implementation EPencaEstado
typedef enum EPencaEstado : NSInteger PlayerStateType;
enum EPencaEstado : NSInteger {
    PlayerStateOff,
    PlayerStatePlaying,
    PlayerStatePaused
};
@end
