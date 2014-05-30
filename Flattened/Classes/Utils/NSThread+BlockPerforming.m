//
//  NSThread+BlockPerforming.m
//  Flattened
//
//  Created by Diego Maye on 30/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "NSThread+BlockPerforming.h"

@implementation NSThread (BlockPerforming)

-(void)performBlock:(void(^)())block
{
    if ( !block ) { return ; }
    [ self performSelector:@selector( performBlock: ) onThread:self withObject:[ block copy ] waitUntilDone:NO ] ;
}

@end
