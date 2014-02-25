//
//  login.h
//  dssapi
//
//  Created by Raja T S Sekhar on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"
#import "ssWSProxy.h"
/*#import "collectionEntry.h"
#import "USAdditions.h"
*/
@interface login : UIView 
{
    IBOutlet UITextField *Email,*Password;
    CGPoint scrollOffset;
	NSMutableString *parseElement,*value;
    NSMutableData *webData;
    NSXMLParser *xmlParser;
    NSMutableString *respcode, *respmessage;
    IBOutlet UIActivityIndicatorView *actview;
    IBOutlet UIView *loginControl;
    IBOutlet UIImageView *mainImage;
    IBOutlet UIScrollView *scrollView;
    UIInterfaceOrientation intOrientationType;
    METHODCALLBACK _loginReturn;
    //NSString *_notificationName;
   // ssWSProxy *_wsProxy;
    
}
- (IBAction)Login;
- (BOOL) validate;
/*-(NSString *)htmlEntityDecode:(NSString *)string;*/
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) setForOrientation:(UIInterfaceOrientation) orientationType;
- (id) initWithFrame:(CGRect)frame andLoginMethod:(METHODCALLBACK) p_returnMethod;
@end
