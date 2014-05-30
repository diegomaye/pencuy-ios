//
//  MapViewController.m
//  
//
//  Created by Valentin Filip on 2/16/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "CrearInvitacionView.h"

#import "ADVTheme.h"
#import "DataSource.h"
#import "ADVGalleryPlain.h"

#import "UIColor+Alpha.h"
#import "Utils.h"

#import <QuartzCore/QuartzCore.h>

@interface CrearInvitacionView () {
    CGSize kbSize;
}

@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, strong) UIView *toolbarView;
@property (nonatomic, assign) BOOL fullScreen;


@end




@implementation CrearInvitacionView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 0, 40, 30);
    [btnCancel setImage:[UIImage imageNamed:@"navigation-btn-cancel"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(0, 0, 40, 30);
    [btnSend setImage:[UIImage imageNamed:@"navigation-btn-send"] forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(actionSend:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSend];
    
    titleLabel.text = @"INVITAR AMIGOS";
    
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    [self configureView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)isTall {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
        && [UIScreen mainScreen].bounds.size.height == 568)
    {
        return YES;
    }
    return NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Actions

- (void)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)actionSend:(id)sender {
    [self actionCancel:sender];
}


#pragma mark - View config

- (void)configureView {
    
}


@end
