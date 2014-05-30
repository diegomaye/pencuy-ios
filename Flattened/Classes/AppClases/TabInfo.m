//
//  TabInfo.m
//  Flattened
//
//  Created by Diego Maye on 26/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "TabInfo.h"

@implementation TabInfo

@synthesize tabName= _tabName;
@synthesize viewControllerName = _viewControllerName;

- (id)initWithTabName:(NSString *)name andViewController: (NSString*) view{
    self = [super init];
    if (self) {
        _tabName = name;
        _viewControllerName = view;
    }
    return self;
}

@end
