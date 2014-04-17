//
//  FixtureDataLoaderViewController.m
//  Flattened
//
//  Created by Diego Maye on 06/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "FixtureDataLoaderViewController.h"
#import "PencuyFetcher.h"

@interface FixtureDataLoaderViewController ()

@end

@implementation FixtureDataLoaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPartidos];
        // Do any additional setup after loading the view.
}

-(void)fetchPartidos{
    
    NSURL *url = [PencuyFetcher URLtoQueryPartido:@"42"];
    NSMutableURLRequest *urlRequest= [NSMutableURLRequest requestWithURL:url];
    NSString *user= [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *pass= [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", user, pass];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [authData base64Encoding];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    
    NSOperationQueue *queue= [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError==nil) {
                //NSString *html= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //NSDictionary *propertyListResults= [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
                //NSData *jsonResults= [NSData dataWithContentsOfURL:url];
            NSArray *partidos= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                //NSArray *photos= [partidos ];
            self.partidos= partidos;
            NSLog(@"Trajo datos: %@",partidos);
            dispatch_async(dispatch_get_main_queue(), ^{
                    // Now make the call to reload data and make any other UI updates
                [self.tableView reloadData];
            });
        }
        else if([data length]==0 && connectionError==nil){
            NSLog(@"No trajo nada");
        }
        else if(connectionError!=nil){
            NSLog(@"Dio error: %@",connectionError);
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
