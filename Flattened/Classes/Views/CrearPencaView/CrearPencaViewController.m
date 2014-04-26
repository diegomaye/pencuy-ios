//
//  CrearPencaViewController.m
//  Flattened
//
//  Created by Diego Maye on 17/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "CrearPencaViewController.h"

@interface CrearPencaViewController ()

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *contentViewControllers;

@end

@implementation CrearPencaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Create page view controller
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    
    titleLabel.text = @"CREAR PENCA";
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 30, 30);
    [btnBack setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageView"];
    self.pageViewController.dataSource = self;
    
    UIViewController *datosGrl = [self.storyboard instantiateViewControllerWithIdentifier:@"DatosGrl"];
    
    UIViewController *partdosPenca = [self.storyboard instantiateViewControllerWithIdentifier:@"PartidosPenca"];
    
    UIViewController *invitarPenca = [self.storyboard instantiateViewControllerWithIdentifier:@"InvitarPenca"];
    
    UIViewController *aceptarCrearPenca = [self.storyboard instantiateViewControllerWithIdentifier:@"AceptarCrearPenca"];
    
    self.contentViewControllers = [NSArray arrayWithObjects:datosGrl,partdosPenca,invitarPenca,aceptarCrearPenca,nil];
    
    [self.pageViewController setViewControllers:@[datosGrl] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.contentViewControllers indexOfObject:viewController];
    
    if (index == 0) {
        return nil;
    }
    return self.contentViewControllers[index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.contentViewControllers indexOfObject:viewController];
    
    
    if (index >= self.contentViewControllers.count - 1) {
        return nil;
    }
    return self.contentViewControllers[index + 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
