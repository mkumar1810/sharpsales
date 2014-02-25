//
//  salesapiAppDelegate.h
//  salesapi
//
//  Created by Raja T S Sekhar on 4/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class salesapiViewController;
#import "defaults.h"
#import "signIn.h"
#import "collectionMainHome.h"
#import "salesOrderMain.h"
#import "reportsMain.h"
#import "signOut.h"
#import "mainController.h"

@interface salesapiAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UINavigationController *nav;
    METHODCALLBACK _loginSucceeded;
    METHODCALLBACK _reLoginMethod;
    signIn *signin;
    mainController *mainCtrl;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

- (void) loginSucceeded : (NSDictionary*) loginInfo;
- (void) makeReLogin : (NSDictionary*) relogInfo;

@end
