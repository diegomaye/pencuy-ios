//
//  TabInfo.h
//  Flattened
//
//  Created by Diego Maye on 26/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabInfo : NSObject

@property(nonatomic, strong) NSString* tabName;
@property(nonatomic, strong) NSString* viewControllerName;

- (id)initWithTabName:(NSString *)name andViewController: (NSString*) view;

@end
