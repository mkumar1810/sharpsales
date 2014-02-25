//
//  getSignature.h
//  salesapi
//
//  Created by Macintosh User on 27/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"

@interface getSignature : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *signImage;
	int mouseMoved;
	BOOL mouseSwiped;
	CGPoint lastPoint;
    IBOutlet UILabel *dispLabel;
    METHODCALLBACK _returnCallBack;
    NSString *lblTitle;
    UIImage *_prevImage;
    NSString *_returnSet;
    UIImagePickerController *imgPicker;
}

@property (nonatomic,retain) IBOutlet UIImageView *signImage;
@property (nonatomic,retain) IBOutlet UILabel *dispLabel;

- (id) initWithTitle:(NSString*) p_title andCallBack:(METHODCALLBACK) p_callback withCurrImage:(UIImage*) p_currImage andreturnContext:(NSString*) p_retContext;
- (void)drawTheSignatureFrom:(CGPoint) p_startpoint andTill:(CGPoint) p_endpoint;
- (IBAction) cancelCapture:(id)sender;
- (IBAction) imageCapture:(id)sender;
- (IBAction) clearImage:(id)sender;
- (IBAction) fromCamera:(id)sender;
- (void) showAlertMessage:(NSString *) dispMessage;

@end
