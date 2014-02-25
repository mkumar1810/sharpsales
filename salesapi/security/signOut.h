//
//  signOut.h
//  dssapi
//
//  Created by Raja T S Sekhar on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "salesapiAppDelegate.h"

@interface signOut : UIViewController {
    IBOutlet UIView *logoutView;
    METHODCALLBACK _reLoginMethod;
    NSTimer *timer;
}

- (id) initWithMethod:(METHODCALLBACK) p_reLogin;

@end
