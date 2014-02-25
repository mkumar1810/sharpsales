//
//  getSignature.m
//  salesapi
//
//  Created by Macintosh User on 27/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "getSignature.h"

@implementation getSignature

@synthesize signImage, dispLabel;

- (id) initWithTitle:(NSString*) p_title andCallBack:(METHODCALLBACK) p_callback withCurrImage:(UIImage*) p_currImage andreturnContext:(NSString*) p_retContext
{
    self = [super initWithNibName:@"getSignature" bundle:nil];
    if (self) 
    {
        _returnCallBack = p_callback;
        _prevImage = p_currImage;
        lblTitle = p_title;
        _returnSet = p_retContext;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.tabBarItem.image = [UIImage imageNamed:@"Database"];
        // Custom initialization
    }
    return self;
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (IBAction) cancelCapture:(id)sender
{
    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_returnSet ,@"message",nil];
    _returnCallBack(callbackInfo);
}

- (IBAction) imageCapture:(id)sender
{
    UIImage *img = [signImage.image copy];
    NSMutableDictionary *callbackInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_returnSet,@"message",  nil];
    [callbackInfo setValue:img forKey:@"signimage"];
    _returnCallBack(callbackInfo);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    mouseMoved = 0;
    [signImage setBackgroundColor:[UIColor whiteColor]];
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    if (_prevImage) 
        signImage.image = _prevImage;
    dispLabel.text = lblTitle;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	lastPoint = [touch locationInView:signImage];
	lastPoint.y -= 20;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:signImage];
	currentPoint.y -= 20; // only for 'kCGLineCapRound'
    //[self.view setNeedsDisplay];
    [self drawTheSignatureFrom:currentPoint andTill:lastPoint];
	/*UIGraphicsBeginImageContext(signImage.frame.size);
	//Albert Renshaw - Apps4Life
	[signImage.image drawInRect:CGRectMake(0, 0, signImage.frame.size.width, signImage.frame.size.height)]; //originally self.frame.size.width, self.frame.size.height)];
    
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0); // for size
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0); //values for R, G, B, and Alpha
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	signImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();*/
	
	lastPoint = currentPoint;
	
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
	
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if(!mouseSwiped) {
        [self drawTheSignatureFrom:lastPoint andTill:lastPoint];
		//if color == green
		/*UIGraphicsBeginImageContext(signImage.frame.size);
		[signImage.image drawInRect:CGRectMake(0, 0, signImage.frame.size.width, signImage.frame.size.height)]; //originally self.frame.size.width, self.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		signImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();*/
	}
}

- (void)drawTheSignatureFrom:(CGPoint) p_startpoint andTill:(CGPoint) p_endpoint
{
    //CGContextRef 
    //ctxref = NULL;
    UIGraphicsBeginImageContext(signImage.frame.size);
    [signImage.image drawInRect:CGRectMake(0, 0, signImage.frame.size.width, signImage.frame.size.height)]; //originally self.frame.size.width, self.frame.size.height)];
    //ctxref = UIGraphicsGetCurrentContext();
    //
    //colorSpace = CGColorSpaceCreateDeviceRGB();
    /*ctxref = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8,rect.size.width*4 , colorSpace, kCGImageAlphaPremultipliedFirst);*/
    //CGColorSpaceRelease(colorSpace);
    //CGContextDrawImage(ctxref, signImage.frame, signImage.image.CGImage);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);

    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), p_endpoint.x, p_endpoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), p_startpoint.x, p_startpoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    signImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (IBAction) clearImage:(id)sender
{
    signImage.image = nil;
}

- (IBAction) fromCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imgPicker animated:YES];
    }
    else
        [self showAlertMessage:@"Camera is not available"];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
    if (image != nil) 
    {
        signImage.image = image;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
