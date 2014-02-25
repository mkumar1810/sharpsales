//
//  Paint_AppViewController.h
//  Paint App
//
//  Created by albert renshaw on 4/12/10.
//  Copyright providence 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Paint_AppViewController : UIViewController {
    IBOutlet UIImageView *drawImage;
	int mouseMoved;
	BOOL mouseSwiped;
	CGPoint lastPoint;
    IBOutlet UIView *v1;
    IBOutlet UIButton *b1,*b2;
}
-(IBAction)zoom;
-(IBAction)done;
@end

