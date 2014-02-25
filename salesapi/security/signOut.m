//
//  signOut.m
//  dssapi
//
//  Created by Raja T S Sekhar on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "signOut.h"


@implementation signOut

- (id) initWithMethod:(METHODCALLBACK) p_reLogin
{
    self = [super initWithNibName:@"signOut" bundle:nil];
    if (self) {
        _reLoginMethod = p_reLogin;
        self.tabBarItem.image = [UIImage imageNamed:@"5"];
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(logOutApplication:) userInfo:nil repeats:NO];
}

-(void) logOutApplication:(NSTimer *)timer
{
    _reLoginMethod(nil);
}

- (void)viewDidUnload
{
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
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) 
        [logoutView setFrame:CGRectMake(85, 250, logoutView.bounds.size.width, logoutView.bounds.size.height)];
    else
        [logoutView setFrame:CGRectMake(200, 140, logoutView.bounds.size.width, logoutView.bounds.size.height)];
}



@end
