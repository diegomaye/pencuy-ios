//
//  AppDelegate.m
//
//  Created by Valentin Filip on 11/7/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "AppDelegate.h"
#import "ADVTheme.h"
#import "PaperFoldNavigationController.h"
#import "PencuyFetcher.h"
static AppDelegate *sharedDelegate;
static Usuario *usuario;

@implementation AppDelegate

+ (Usuario*) getUsuario {
    if (usuario==nil) {
        NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
        NSData* userDefaultData = [userDefaults valueForKey:@"USUARIO-PENCA"];
        NSDictionary* userDefaultDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:userDefaultData];
        NSError* error;
        usuario = [[Usuario alloc] initWithDictionary:userDefaultDictionary error:&error];
    }
    return usuario;
}

+ (void) setUsuarioNil{
    usuario = nil;
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
        // Facebook SDK * login flow *
        // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
            // Facebook SDK * App Linking *
            // For simplicity, this sample will ignore the link if the session is already
            // open but a more advanced app could support features like user switching.
        if (call.accessTokenData) {
            if ([FBSession activeSession].isOpen) {
                NSLog(@"INFO: Ignoring app link because current session is open.");
            }
            else {
                [self handleAppLink:call.accessTokenData];
            }
        }
    }];
}

    // Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
        // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
        // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                  // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  NSLog(@"Error pidiendo el token");
                                      //[self.loginViewController loginView:nil handleError:error];
                              }
                          }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    [ADVThemeManager customizeAppAppearance];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.mainVC = (((UINavigationController *)self.window.rootViewController).viewControllers)[0];
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        splitViewController.presentsWithGesture = NO;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        MenuViewController *menuVC = splitViewController.viewControllers[0];
        menuVC.delegate = self;
    } else {
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        if (!usuarioPenca) {
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoggedUser"];
//            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"USUARIO-PENCA"];
//            [AppDelegate setUsuarioNil];
//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
//                                                                     bundle: nil];
//            LoginViewController* loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            [self.view.window setRootViewController:loginVC];
//        }
        Usuario* usuarioPenca = [AppDelegate getUsuario];
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"]||![[NSUserDefaults standardUserDefaults] valueForKey:@"USUARIO-PENCA"]||!usuarioPenca) {
            self.userLogged= NO;
        }
        else{
            self.userLogged= [[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"];
        }
        if (_userLogged) {
            [self selectWhatKindOfSetup];
        }
        else{
            [self navigateToLogin];
        }
    }
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

-(void) navigateToLogin{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    self.loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.mainVC= _loginVC;
    self.window.rootViewController = self.mainVC;
    //self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
}

-(void)selectWhatKindOfSetup {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"NavigationType"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:ADVNavigationTypeMenu forKey:@"NavigationType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.navigationType = [[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"];
    
    if (_navigationType == ADVNavigationTypeTab) {
        [self setupTabbar];
    } else {
        [self setupMenu];
    }
    self.window.rootViewController = self.mainVC;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
}

- (void)setupTabbar {
    if (!self.tabbarVC) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                                 bundle: nil];
        
        
        self.tabbarVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabbarController"];
    }
    
    self.mainVC = _tabbarVC;
}

- (void)setupMenu {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    if (!self.foldVC) {
        self.foldVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PaperFoldController"];
    }
    
    UINavigationController *navMag1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"CoverNav"];
    if (!_menuVC) {
        _menuVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SideViewController"];
        
        _menuVC.delegate = self;
    }
    [_menuVC viewDidLoad];
    //[_menuVC.tableView reloadData];
    [_foldVC setRootViewController:navMag1];
    [_foldVC setLeftViewController:_menuVC width:275];
    self.mainVC = _foldVC;
}

#pragma mark - Actions

- (void)showMenuiPad:(id)sender {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_barButtonFromMaster.target performSelector:_barButtonFromMaster.action withObject:_barButtonFromMaster];
#pragma clang diagnostic pop
}


- (void)togglePaperFold:(id)sender {
    [self.menuVC.tableView reloadData];
    if (_foldVC.paperFoldView.state == PaperFoldStateLeftUnfolded) {
        [_foldVC.paperFoldView setPaperFoldState:PaperFoldStateDefault animated:YES];
    } else {
        [_foldVC.paperFoldView setPaperFoldState:PaperFoldStateLeftUnfolded animated:YES];
    }
}


-(void)userDidSwitchToControllerAtIndexPath:(NSIndexPath*)indexPath{
    NSString *controllerIdentifier;
        
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.mainVC = (((UINavigationController *)self.window.rootViewController).viewControllers)[0];
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        NSString *title;
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        controllerIdentifier = @"InvitationsNav";
                        break;
                    case 1:
                        title = @"INVITAR AMIGO";
                        break;
                    case 2:
                        title = @"PENCAS";
                        break;
                    case 3:
                        title = @"BASURA";
                        break;
                    case 4:
                        title = @"CONFIGURACIÓN";
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        controllerIdentifier = controllerIdentifier ? : @"OtherNav";
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                                 bundle: nil];
        UINavigationController *nav = [mainStoryboard instantiateViewControllerWithIdentifier:controllerIdentifier];
        
        splitViewController.delegate = (id)nav.topViewController;
        splitViewController.viewControllers = @[splitViewController.viewControllers[0], nav];
        nav.topViewController.title = title;
    } else {
        
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        controllerIdentifier = @"CoverNav";
                        break;
                    case 1:
                        controllerIdentifier = @"PencasNav";
                        break;
                    case 2:
                        controllerIdentifier = @"InvitationsNav";
                        break;
                    case 3:
                        controllerIdentifier = @"GroupNav";
                        break;
                    case 4:
                        controllerIdentifier = @"OtherNav";
                        break;
                    case 5:
                        controllerIdentifier = @"SettingsNav";
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                                 bundle: nil];
        UINavigationController *nav = [mainStoryboard instantiateViewControllerWithIdentifier:controllerIdentifier];
        
        [_foldVC setRootViewController:nav];
        [_foldVC.paperFoldView setPaperFoldState:PaperFoldStateDefault animated:YES];
    }
}

-(void) setFoldVCWithNavBar: (UINavigationController*) nav{
    [_foldVC setRootViewController:nav];
    [_foldVC.paperFoldView setPaperFoldState:PaperFoldStateDefault animated:YES];
}

- (void)resetAfterTypeChange:(BOOL)cancel {
    UINavigationController *settingsNav;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeTab) {
        [self setupTabbar];
        _tabbarVC.selectedIndex = 4;
        settingsNav = [_tabbarVC.viewControllers lastObject];
        [settingsNav popToRootViewControllerAnimated:NO];
    } else {
        [self setupMenu];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                                 bundle: nil];
        settingsNav = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
        [_foldVC setRootViewController:settingsNav];
        [_foldVC setLeftViewController:_menuVC width:275];
    }
    
    self.window.rootViewController = self.mainVC;
    
    if (!cancel) {
        UIViewController *settingsVC = settingsNav.viewControllers[0];
        [settingsVC performSegueWithIdentifier:@"selectNavigationTypeNoAnim" sender:settingsVC];
    }
}

+ (AppDelegate *)sharedDelegate {
    if (!sharedDelegate) {
        sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return sharedDelegate;
}


+ (void)customizeTabsForController:(UITabBarController *)tabVC {
    NSArray *items = tabVC.tabBar.items;
    for (int idx = 0; idx < items.count; idx++) {
        UITabBarItem *item = items[idx];
        [ADVThemeManager customizeTabBarItem:item forTab:((SSThemeTab)idx)];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:0.55f green:0.56f blue:0.58f alpha:1.00f], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"OpenSans-Semibold" size:9], NSFontAttributeName,
      nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"OpenSans-Semibold" size:9], NSFontAttributeName,
      nil]
                                             forState:UIControlStateSelected];
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* token = [NSString stringWithFormat:@"%@", deviceToken];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"DEVICE-TOKEN"];
    NSLog(@"devToken=%@",token);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    Usuario* usuario = [AppDelegate getUsuario];
    NSError* errorComunicacion;
    NSError* errorSerializacion;
    NSDictionary* retorno = [PencuyFetcher multiFetcherSync:[PencuyFetcher URLtoQueryProfile] withHTTP:@"GET" withData:nil withUserName:usuario.email withPassword:usuario.password communicationError:&errorComunicacion jsonSerializationError:&errorSerializacion];
    if(errorComunicacion.code == -1012 && usuario.faceID){
        //SI TENGO UN ERROR DE AUTENTICACIÓN ENTONCES MANDO EL USUARIO DE FACEBOOK DE NUEVO... VEMAMOS QUE PASA
        
        NSLog(@"###############################################################");
        NSLog(@"ENTRO ACA CARAJOOOOO!!!!!!!!!!!!!!!");
        NSLog(@"###############################################################");
        
        NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[usuario toDictionary]
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[usuario toDictionary]];
        
        //NSDictionary * val = [NSDictionary new];//[usuario toDictionary];
        
        [userDefaults setObject:myEncodedObject forKey:@"USUARIO-PENCA"];
        [userDefaults synchronize];
        NSError *conError = nil;
        NSError *jsonError = nil;
        NSLog(@"valores: %@", jsonData);
        [PencuyFetcher multiFetcherSyncPublic:[PencuyFetcher URLtoCreateFaceUser]
                                     withHTTP:@"POST"
                                     withData:jsonData
                                 withUserName:usuario.email
                                 withPassword:usuario.password
                           communicationError:&conError
                       jsonSerializationError:&jsonError];
        NSLog(@"Connection error: %@", conError);
        NSLog(@"JsonError : %@", jsonData);
    }
        
    NSLog(@"###############################################################");
    NSLog(@"La aplicacion se activo, en el retorno tenemos: %@", retorno);
    NSLog(@"La aplicacion se activo, en el errorComunicacion tenemos: %@", errorComunicacion);
    NSLog(@"La aplicacion se activo, en el errorSerializacion tenemos: %@", errorSerializacion);
    NSLog(@"###############################################################");
        // Facebook SDK * login flow *
        // We need to properly handle activation of the application with regards to SSO
        //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
