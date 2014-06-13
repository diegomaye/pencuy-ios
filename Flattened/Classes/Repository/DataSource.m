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
                     @"title": NSLocalizedString(@"Cover",nil),
                     @"image": @"874-newspaper-g"
                     },
                @{
                    @"title": NSLocalizedString(@"Bets",nil),
                    @"image": @"838-dice-g",
                    },
                @{
                    @"title": NSLocalizedString(@"Invitations",nil),
                    @"image": @"730-envelope-g",
                    },
                @{
                    @"title": NSLocalizedString(@"Groups",nil),
                    @"image": @"1056-org-chart-g",
                    },
                @{
                    @"title": NSLocalizedString(@"Statics",nil),
                    @"image": @"990-presentation-g"
                    },
                @{
                    @"title": NSLocalizedString(@"Rules",nil),
                    @"image": @"138-scales-g"
                    }
             ];
}

@end
