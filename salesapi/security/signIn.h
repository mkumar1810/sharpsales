//
//  signIn.h
//  dssapi
//
//  Created by Raja T S Sekhar on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ssWSProxy.h"

@interface signIn : UIViewController 
{
    UIInterfaceOrientation currOrientation;
    NSUserDefaults *standardUserDefaults;
    IBOutlet UITextField *Email,*Password;
    CGPoint scrollOffset;
    NSMutableString *respcode, *respmessage;
    IBOutlet UIActivityIndicatorView *actview;
    IBOutlet UIView *loginControl;
    IBOutlet UIImageView *mainImage;
    IBOutlet UIScrollView *scrollView;
    UIInterfaceOrientation intOrientationType;
    METHODCALLBACK _loginReturn;
}
- (id) initWithReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) loginSuccessful : (NSDictionary*) signInfo;
- (IBAction)Login;
- (BOOL) validate;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) setForOrientation:(UIInterfaceOrientation) orientationType;
@end
