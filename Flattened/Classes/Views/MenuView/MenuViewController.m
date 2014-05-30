//
//  MenuViewController.m
//  
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "MenuViewController.h"
#import "DataSource.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Usuario.h"
#import "FacebookImageStorage.h"
#import "ImageManager.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSArray       *menu;
@property (nonatomic, strong) NSIndexPath   *currentSelection;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![Utils isVersion6AndBelow]){
        self.profileView.frame = CGRectMake(0, 15, self.profileView.frame.size.width, self.profileView.frame.size.height);
        CGRect tableRect = self.tableView.frame;
        tableRect.origin.y += 15;
        tableRect.size.height -= 15;
        self.tableView.frame = tableRect;
    }
    
    self.menu = [DataSource menu];
    [self.tableView reloadData];
    /*
     Sacando usuario por defecto
     */
    NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
    NSData* userDefaultData = [userDefaults valueForKey:@"USUARIO-PENCA"];
    NSDictionary* userDefaultDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:userDefaultData];
    NSError* error;
    Usuario* usuarioPenca = [[Usuario alloc] initWithDictionary:userDefaultDictionary error:&error];
    NSLog(@"Error tratando de sacar el usuario por defecto: %@", error);
    /*
     Sacando usuario por defecto
     */
    UIImage *imgBkg = [[UIImage imageNamed:@"menu-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(100, 0, 150, 0)];
    UIImageView *imgVBkg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgVBkg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imgVBkg.image = imgBkg;
    [self.view insertSubview:imgVBkg atIndex:0];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.profileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-profile-background.png"]];
    
    UIImageView *profileImageView = (UIImageView *)[_profileView viewWithTag:1];
    
    if (usuarioPenca.faceID && ![usuarioPenca.faceID isEqualToString:@""]) {
        profileImageView.hidden=YES;
        self.facebookImageView.hidden=NO;
        self.facebookImageView.profileID = usuarioPenca.faceID;
        self.facebookImageView.pictureCropping = FBProfilePictureCroppingOriginal;
    }
    else{
        profileImageView.hidden=NO;
        self.facebookImageView.hidden=YES;
        profileImageView.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    
    UILabel *nameLabel = (UILabel *)[_profileView viewWithTag:2];
    nameLabel.text = usuarioPenca.nombreCompleto;
    nameLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:19];
    nameLabel.textColor = [UIColor whiteColor];
    
    UILabel *emailLabel = (UILabel *)[_profileView viewWithTag:3];
    
    emailLabel.text = usuarioPenca.email;
    emailLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12];
    emailLabel.textColor = [UIColor colorWithRed:0.56f green:0.59f blue:0.64f alpha:1.00f];
    
    UIButton *btnSettings = (UIButton *)[_profileView viewWithTag:4];
    [btnSettings setImage:[UIImage imageNamed:@"menu-profile-settings"] forState:UIControlStateNormal];
    btnSettings.backgroundColor = [UIColor clearColor];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menu count] + 1;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
        //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

- (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(origImage.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, (CGRect){ {0,0}, origImage.size} );
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, origImage.size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, (CGRect){ {0,0}, origImage.size }, [origImage CGImage]);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *cellIdentifier = @"MenuCell";
    NSInteger index = indexPath.row;
    
    if (indexPath.row == [aTableView numberOfRowsInSection:0] - 2) {
        cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else if (indexPath.row > [aTableView numberOfRowsInSection:0] - 2) {
        index--;
        cellIdentifier = @"MenuCellReverted";
    }
    
    cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundView = nil;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    aTableView.backgroundColor = [UIColor clearColor];
    NSDictionary *item = self.menu[index];
    
    UIImageView *imgRow = (UIImageView *)[cell viewWithTag:1];
    UIImage *imgRowImage = nil;
    if (item[@"image"]) {
        imgRowImage = [UIImage imageNamed:item[@"image"]];
        
            //imgRow.image = imgRowImage;
        imgRow.image = [self scaleImage:imgRowImage toSize:CGSizeMake(22, 22)];
    }
    else{
        imgRow.image = imgRowImage;
    }
    UILabel *lblText = (UILabel *)[cell viewWithTag:2];
    lblText.text = item[@"title"];
    lblText.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
    
    UIView *countView = nil;
    if ([item[@"count"] intValue] > 0) {
        UIFont *countFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:13];
        
        NSString *countString = [NSString stringWithFormat:@"%@", item[@"count"]];
        CGSize sizeCount = [countString sizeWithFont:countFont];
        
        CGFloat padding = 2;
        CGFloat viewWidth = sizeCount.width + padding*2;
        viewWidth = viewWidth > 20 ? : 20;
        
        UIImage *bkgImg = [UIImage imageNamed:@"menu-count.png"];
        countView = [[UIImageView alloc] initWithImage:[bkgImg stretchableImageWithLeftCapWidth:12 topCapHeight:0]];
        countView.frame = CGRectIntegral(CGRectMake(0, 0, viewWidth, bkgImg.size.height));
        
        int labelX = (viewWidth - sizeCount.width)/2;
        UILabel *lblCount = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelX, (bkgImg.size.height-sizeCount.height)/2+1, sizeCount.width, sizeCount.height))];
        lblCount.text = countString;
        lblCount.backgroundColor = [UIColor clearColor];
        lblCount.textColor = [UIColor colorWithRed:0.43f green:0.43f blue:0.45f alpha:1.00f];
        lblCount.textAlignment = NSTextAlignmentCenter;
        lblCount.font = countFont;
        lblCount.shadowColor = [UIColor clearColor];
        lblCount.shadowOffset = CGSizeMake(0, 1);
        [countView addSubview:lblCount];
    }
    cell.accessoryView = countView;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 44;
    if (indexPath.row == _menu.count - 1) {
        return aTableView.frame.size.height - _menu.count*rowHeight;
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES animated:YES];
        [[AppDelegate sharedDelegate].masterPopoverController dismissPopoverAnimated:YES];
    }
    
    if (indexPath.row == [aTableView numberOfRowsInSection:0] - 2) {
        return;
    } else if (indexPath.row > [aTableView numberOfRowsInSection:0] - 2) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    [self.delegate userDidSwitchToControllerAtIndexPath:indexPath];
}

- (void)viewDidUnload {
    [self setProfileView:nil];
    [super viewDidUnload];
}
@end
