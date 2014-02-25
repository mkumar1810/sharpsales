//
//  reportsMain.m
//  salesapi
//
//  Created by Imac DOM on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "reportsMain.h"

@implementation reportsMain

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"preview"];
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
    CGRect tabViewFrame = self.view.frame;
    tabViewFrame.origin.x = 0;
    tabViewFrame.origin.y = 0;
    /*NSLog(@"tabview frame x %f and y %f and width %f and height %f", tabViewFrame.origin.x, tabViewFrame.origin.y, tabViewFrame.size.width, tabViewFrame.size.height);*/
    [self.view setFrame:tabViewFrame];
    [self initialize];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    [self generateAccountStatement];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) initialize
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchCustomerReturn:) name:@"searchCustReturn_For_SM" object:nil];   
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printingScreenBack:) name:@"printScreenReturnCustStmt" object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self setViewResizedForOrientation:toInterfaceOrientation];
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation
{
    /*CGRect tabViewFrame = self.view.frame;
    tabViewFrame.origin.x = 0;
    tabViewFrame.origin.y = 0;
    NSLog(@"tabview frame x %f and y %f and width %f and height %f", tabViewFrame.origin.x, tabViewFrame.origin.y, tabViewFrame.size.width, tabViewFrame.size.height);*/
    //[self.view setFrame:tabViewFrame];
    if (smCustSearch) 
        [smCustSearch setForOrientation:p_intOrientation];
    
    if (stmtPreview) 
        [stmtPreview setForOrientation:p_intOrientation];
}

- (void) generateAccountStatement
{
   // NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];
    CGRect myFrame = self.view.frame;
    myFrame.origin.y = 0;
    myFrame.origin.x = 0;
    METHODCALLBACK l_custReturn = ^(NSDictionary* p_dictInfo)
    {
        [self searchCustomerReturn:p_dictInfo];
    };
    smCustSearch = [[custSearch alloc] initWithFrame:myFrame forOrientation:currOrientation  andReturnMethod:l_custReturn ];//forSalesMan:[standardUserDefaults valueForKey:@"loggeduser"]];
    [self.view addSubview:smCustSearch];
}

- (void) searchCustomerReturn:(NSDictionary *)custInfo
{
    NSDictionary *recdData = [custInfo valueForKey:@"data"];
    [smCustSearch removeFromSuperview];
    //[smCustSearch release];
    smCustSearch = nil;
    if (recdData) 
    {
        METHODCALLBACK l_printReturn = ^(NSDictionary* p_dictInfo)
        {
            [self printingScreenBack:p_dictInfo];
        };
        NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"SALESMANCODE"], @"salesmancode",[recdData valueForKey:@"CD"]  ,@"sledcode", nil];
        stmtPreview = [[genPrintView alloc] initWithDictionary:inputDict andOrientation:currOrientation andFrame:self.view.frame andReporttype:@"Accountpreview" andReturnMethod:l_printReturn];
        [stmtPreview setForOrientation:currOrientation];
        [self.view addSubview:stmtPreview];    
    }
    [self setViewResizedForOrientation:currOrientation];
}

- (void) printingScreenBack:(NSDictionary*) printInfo
{
    [stmtPreview removeFromSuperview];
    /*if (stmtPreview) 
        [stmtPreview release];*/
    stmtPreview = nil;
    [self generateAccountStatement];
    [self setViewResizedForOrientation:currOrientation];
}

@end
