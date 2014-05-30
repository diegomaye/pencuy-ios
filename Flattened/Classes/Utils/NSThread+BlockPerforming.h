//
//  NSThread+BlockPerforming.h
//  Flattened
//
//  Created by Diego Maye on 30/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (BlockPerforming)

-(void)performBlock:(void(^)())block;

@end
