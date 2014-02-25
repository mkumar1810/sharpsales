//
//  signIn.m
//  dssapi
//
//  Created by Raja T S Sekhar on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "signIn.h"


@implementation signIn

static bool shouldScroll = true;

- (id) initWithReturnMethod:(METHODCALLBACK) p_returnMethod 
{
    self = [super initWithNibName:@"signIn" bundle:nil];
    if (self) {
        _loginReturn = p_returnMethod;
        // Custom initialization
        //[self addNIBView:@"signIn" forFrame:self.view.frame];
    }
    return  self;
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
    standardUserDefaults=[NSUserDefaults standardUserDefaults];
    currOrientation = self.interfaceOrientation;
    self.view.backgroundColor = [UIColor blackColor];
    //[Email setBorderStyle:UITextBorderStyleRoundedRect];
    [actview stopAnimating];
    Email.text= @"ed";
    Password.text = @"1234";
    actview.hidesWhenStopped = TRUE;
    actview.transform = CGAffineTransformMakeScale(5.00, 5.00);        
    [super viewDidLoad];
    [self setForOrientation:currOrientation];
    //[self Login];
    //[signLogin Login];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    //[[NSNotificxationCenter defaultCenter] removeOxbserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currOrientation = toInterfaceOrientation;
    [self setForOrientation:toInterfaceOrientation];
}

- (void) setForOrientation:(UIInterfaceOrientation) orientationType
{
    if (UIInterfaceOrientationIsPortrait(orientationType)) 
    {
        [scrollView setFrame:CGRectMake(0, 0, 768, 1024)];
        [mainImage setFrame:CGRectMake(255, 150, 257, 257)];
        [loginControl setFrame:CGRectMake(134, 405 , 500, 325)];
        [actview setFrame:CGRectMake(370, 300, 37, 37)];
    }
    else
    {
        [scrollView setFrame:CGRectMake(0, 0, 1024, 768)];
        [mainImage setFrame:CGRectMake(133, 200, 257, 257)];
        [loginControl setFrame:CGRectMake(390, 170 , 500, 325)];
        [actview setFrame:CGRectMake(498, 145, 37, 37)];
    }
}

- (void) loginSuccessful : (NSDictionary*) signInfo
{
    NSDictionary *returnedDict =  [[signInfo valueForKey:@"data"] objectAtIndex:0];
    NSString *respCode = [returnedDict valueForKey:@"RESPONSECODE"];
    NSString *respMsg = [returnedDict valueForKey:@"RESPONSEMESSAGE"];
    if ([respCode isEqualToString:@"0"]) {
        NSString *loginuser = [returnedDict valueForKey:@"LOGGEDUSER"];
        NSString *smCode = [returnedDict valueForKey:@"SHORTNAME"];
        [standardUserDefaults setObject:[loginuser uppercaseString] forKey:@"loggeduser"];    
        [standardUserDefaults setObject:[smCode uppercaseString] forKey:@"SALESMANCODE"];
        _loginReturn(nil);
    }
    else
        [self showAlertMessage:respMsg];
    [actview stopAnimating];
}


-(IBAction)Login
{
    [actview startAnimating];
    NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%@",Email.text], @"p_eMail",[[NSString alloc] initWithFormat:@"%@",Password.text], @"p_passWord" , nil];
    METHODCALLBACK l_loginNotify = ^(NSDictionary *p_dictInfo)
    {
        [self loginSuccessful:p_dictInfo];
    };
    [[ssWSProxy alloc] initWithReportType:@"USERLOGIN" andInputParams:inputDict andReturnMethod:l_loginNotify];
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
