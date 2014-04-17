//
//  DataSource.m
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource


+ (NSArray *)timeline {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Timeline" ofType:@"plist"];
    return [[NSArray alloc] initWithContentsOfFile:path];
}

+ (NSDictionary *)userAccount {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"User-Account" ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}


+ (NSArray *)menu {
    return @[
                 @{
                     @"title": @"Fixture",
                     @"image": @"menu-icon1",
                     @"count": @23
                     },
                @{
                    @"title": @"Invitaciones",
                    @"image": @"menu-icon1",
                    @"count": @23
                    },
                @{
                    @"title": @"Invitar Amigo",
                    @"image": @"menu-icon2"
                    },
                @{
                    @"title": @"Pencas",
                    @"image": @"menu-icon3",
                    @"count": @6
                    },
                @{
                    @"title": @"Basura",
                    @"image": @"menu-icon4"
                    },
                @{
                    @"title": @"Configuracion",
                    @"image": @"menu-icon5"
                    }
             ];
}

@end
