//
//  mainController.h
//  dssapi
//
//  Created by Raja T S Sekhar on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"

@interface mainController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate>
{
    IBOutlet UITabBarController *tab;
    IBOutlet UITabBar *tabbar;
    NSTimer *timer;
    int tabSelected;
    METHODCALLBACK _reLoginMethod;
}

@property(nonatomic,retain)IBOutlet UITabBarController *tab;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withReLoginMethod:(METHODCALLBACK) p_reLoginMethod;
@end
