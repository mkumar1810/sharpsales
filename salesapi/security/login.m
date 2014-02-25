//
//  login.m
//  aahg
//
//  Created by Raja T S Sekhar on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "login.h"

@implementation login

static bool shouldScroll = true;

- (id) initWithFrame:(CGRect)frame andLoginMethod:(METHODCALLBACK) p_returnMethod
{
    self = [self initWithFrame:frame];
    _loginReturn = p_returnMethod;
    //_notificationName = [[NSString alloc] initWithString:p_notifyName];
    self.backgroundColor = [UIColor blackColor];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"login"
                                                          owner:self
                                                        options:nil];
    //self = [nibViews objectAtIndex:0];
    //[[nibViews objectAtIndex:0] setFrame:frame];
    [self addSubview:[nibViews objectAtIndex:0]];
    //Email.text= @"ed";
    //Password.text = @"1234";
    actview.hidesWhenStopped = TRUE;
    if (frame.size.width<800) 
        intOrientationType = UIInterfaceOrientationPortrait;
    else
        intOrientationType = UIInterfaceOrientationLandscapeRight;
    //_notificationName = [[NSString alloc] initWithString:@"loginSuccessful"];
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 }
 
*/

- (void)dealloc
{
    //[super dealloc];
}

- (void) setForOrientation:(UIInterfaceOrientation) orientationType
{
    CGRect newframe;
    if (UIInterfaceOrientationIsPortrait(orientationType)) 
    {
        newframe = CGRectMake(0, 0, 768, 1028);
        intOrientationType = UIInterfaceOrientationPortrait;
        [mainImage setFrame:CGRectMake(255, 155, 257, 188)];
        [loginControl setFrame:CGRectMake(134, 327 , 500, 350)];
    }
    else
    {
        newframe = CGRectMake(0, 0, 1028, 768);
        intOrientationType = UIInterfaceOrientationLandscapeRight;
        [mainImage setFrame:CGRectMake(373, 110, 257, 188)];
        [loginControl setFrame:CGRectMake(252, 285 , 500, 350)];
    }
    self.frame = newframe;
}


-(IBAction)Login
{
    [actview startAnimating];
    //if (_wsProxy) [_wsProxy release];
    NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%@",Email.text], @"p_eMail",[[NSString alloc] initWithFormat:@"%@",Password.text], @"p_passWord" , nil];
    [[ssWSProxy alloc] initWithReportType:@"USERLOGIN" andInputParams:inputDict andReturnMethod:_loginReturn];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}


-(BOOL)validate
{
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    shouldScroll = true;
    [scrollView setContentOffset:scrollOffset animated:YES]; 
    if([textField isEqual:Email])
    {
        [Password becomeFirstResponder];
    }
    else if([textField isEqual:Password])
    {
        [textField resignFirstResponder];
        scrollOffset = scrollView.contentOffset;
        scrollOffset.y = 0;
        if (UIInterfaceOrientationIsPortrait(intOrientationType)==NO)
            [scrollView setContentOffset:scrollOffset animated:YES];  
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (shouldScroll) {
        scrollOffset = scrollView.contentOffset;
        CGPoint scrollPoint;
        CGRect inputFieldBounds = [textField bounds];
        inputFieldBounds = [textField convertRect:inputFieldBounds toView:scrollView];
        scrollPoint = inputFieldBounds.origin;
        scrollPoint.x = 0;
        if([textField isEqual:Email])
            scrollPoint.y = 60;
        else if([textField isEqual:Password])
            scrollPoint.y = 150;
        else
            scrollPoint.y=0;
        
        if (UIInterfaceOrientationIsPortrait(intOrientationType)==NO)
            [scrollView setContentOffset:scrollPoint animated:YES];  
        shouldScroll = false;
    }
}

- (BOOL) textFieldDidEndEditing:(UITextField *) textField {
    
    return YES;
}

@end
