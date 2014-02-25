//
//  salesapiAppDelegate.m
//  salesapi
//
//  Created by Raja T S Sekhar on 4/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "salesapiAppDelegate.h"

@implementation salesapiAppDelegate


@synthesize window=_window;
@synthesize tabBarController = _tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*nav=[[UINavigationController alloc]init];
    nav.navigationBar.hidden=YES;
    [self.window addSubview:nav.view];
    signIn *signin=[[signIn alloc]initWithNotificationName:@"loginSuccessful"];
    [nav pushViewController:signin animated:YES];
    [self.window makeKeyAndVisible];
    return YES;*/
    __block id myself = self;
    _loginSucceeded = ^(NSDictionary * p_dictInfo)
    {
        [myself loginSucceeded:p_dictInfo];
    };
    _reLoginMethod = ^(NSDictionary * p_dictInfo)
    {
        [myself makeReLogin:p_dictInfo];
    };
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    signin=[[signIn alloc]initWithReturnMethod:_loginSucceeded];
    self.window.rootViewController = signin;
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (void) makeReLogin : (NSDictionary*) relogInfo
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:@"" forKey:@"loggeduser"];
    signin=[[signIn alloc]initWithReturnMethod:_loginSucceeded];
    self.window.rootViewController = signin;
    [self.window makeKeyAndVisible];
}


- (void) loginSucceeded : (NSDictionary*) loginInfo
{
    // Override point for customization after application launch.
    UIViewController *cmh = [[collectionMainHome alloc] initWithNibName:@"collectionMainHome" bundle:nil];
    UIViewController *som =[[salesOrderMain alloc] initWithNibName:@"salesOrderMain" bundle:nil];
    UIViewController *repm = [[reportsMain alloc] initWithNibName:@"reportsMain" bundle:nil];
    UIViewController *sout = [[signOut alloc] initWithMethod:_reLoginMethod];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:cmh, som,repm,sout,nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}

/*____________________________________________________**/

/*
- (void) loginSucceeded : (NSDictionary*) loginInfo
{
    // Override point for customization after application launch.
    mainCtrl= [[mainController alloc] initWithNibName:@"mainController" bundle:nil withReLoginMethod:_reLoginMethod];
    self.window.rootViewController = mainCtrl;
    [self.window makeKeyAndVisible];
}

*/

 

@end
