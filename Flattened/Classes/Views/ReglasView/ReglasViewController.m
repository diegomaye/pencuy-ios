//
//  ReglasViewController.m
//  Flattened
//
//  Created by Diego Maye on 02/06/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ReglasViewController.h"
#import "Utils.h"
#import "ADVTheme.h"
#import "AppDelegate.h"

@interface ReglasViewController ()

@end

@implementation ReglasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    [ADVThemeManager customizeView:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"RULES",nil);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeMenu) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0, 0, 40, 30);
        [menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    [self setLabelsTitles];
}

-(void)setLabelsTitles{
    self.lblModalidadJuego.text = NSLocalizedString(@"reglasTitModalidad", nil);
    self.lblMJPrimero.text = NSLocalizedString(@"reglasModalidad1", nil);
    self.lblMJSegundo.text = NSLocalizedString(@"reglasModalidad2", nil);
    self.lblSistemaResultados.text = NSLocalizedString(@"reglasTitResultados", nil);
    self.lblSR0.text = NSLocalizedString(@"reglasResultados1", nil);
    self.lblSR1.text = NSLocalizedString(@"reglasResultados2", nil);
    self.lblSR2.text = NSLocalizedString(@"reglasResultados3", nil);
    self.lblSR3.text = NSLocalizedString(@"reglasResultados4", nil);
    self.lblSR4.text = NSLocalizedString(@"reglasResultados5", nil);
    self.lblSistemaPuntos.text= NSLocalizedString(@"reglasTitPuntos", nil);
    self.lblSP0.text = NSLocalizedString(@"reglasPuntos0", nil);
    self.lblSP1.text = NSLocalizedString(@"reglasPuntos1", nil);
    self.lblSP2.text = NSLocalizedString(@"reglasPuntos2", nil);
    self.lblSP3.text = NSLocalizedString(@"reglasPuntos3", nil);
    self.lblSP4.text = NSLocalizedString(@"reglasPuntos4", nil);
    
}

#pragma mark - Actions

- (void)showMenu:(id)sender {
    [[AppDelegate sharedDelegate] togglePaperFold:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
