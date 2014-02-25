//
//  salesOrderMain.m
//  salesapi
//
//  Created by Imac on 4/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "salesOrderMain.h"


@implementation salesOrderMain

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.tabBarItem.image = [UIImage imageNamed:@"Person-black"];
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
    __block id myself = self;
    _callBackProcessor = ^(NSDictionary* p_dictInfo)
    {
        [myself handleCallBack:p_dictInfo];
    };
    [self generateSalesOrderList];
    [super viewDidLoad];
    actView.transform = CGAffineTransformMakeScale(5.00, 5.00);        
    [self setNavigationForMode:@"SOLIST"];
    _addUpdateAllow = TRUE;
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

- (BOOL) shouldAutorotate
{
    return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setViewResizedForOrientation:toInterfaceOrientation];
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation
{
    if (soEntry) 
        [soEntry setForOrientation:p_intOrientation];
    
    if (soList) 
        [soList setForOrientation:p_intOrientation];
    
    if (searchCust) 
        [searchCust setForOrientation:p_intOrientation];
    
    if (searchDiv) 
        [searchDiv setForOrientation:p_intOrientation];
    
    /*if (searchBank) 
        [searchBank setForOrientation:p_intOrientation];
    
    if (colnpv) 
        [colnpv setForOrientation:p_intOrientation];*/
    
}

- (void) generateSalesOrderList
{
    soList = [[salesOrderListTV alloc] initWithOrientation:self.interfaceOrientation andCallBack:_callBackProcessor];
    [self.view addSubview:soList];
}

- (void) handleCallBack:(NSDictionary*) p_dict
{
    NSString *procMessage = [p_dict valueForKey:@"message"];  
    /*[[NSDictionary alloc] initWithObjectsAndKeys:@"STARTROTATE",@"message", nil];    */
    if ([procMessage isEqualToString:@"STARTANIMATE"]) 
    {
        [actView startAnimating];
        return;
    }
    if ([procMessage isEqualToString:@"STOPANIMATE"]) 
    {
        dispLabel.text = [soList getTitleForDisplay];
        if ([[p_dict valueForKey:@"offset"] intValue]==0) 
            _addUpdateAllow = TRUE;
        else
            _addUpdateAllow = FALSE;
        [actView stopAnimating];
        [self setNavigationForMode:@"SOLIST"];
        return;
    }
    if ([procMessage isEqualToString:@"CUSTOMERSELECT"]) 
    {
        searchCust = [[custSearch alloc] initWithFrame:self.view.frame forOrientation:self.interfaceOrientation andReturnMethod:_callBackProcessor];
        [self.view addSubview:searchCust];
        return;
    }
    if ([procMessage isEqualToString:@"CUSTOMERSET"]) 
    {
        
        NSDictionary *recdData = [p_dict valueForKey:@"data"];
        [searchCust removeFromSuperview];
        searchCust = nil;
        [soEntry setCustomerInformation:recdData];
        return;
    }
    if ([procMessage isEqualToString:@"DIVSELECT"]) 
    {
        searchDiv = [[divSelect alloc] initWithFrame:self.view.frame forOrientation:self.interfaceOrientation andReturnMethod:_callBackProcessor];
        [self.view addSubview:searchDiv];
        return;
    }
    if ([procMessage isEqualToString:@"DIVSET"]) 
    {
        
        NSDictionary *recdData = [p_dict valueForKey:@"data"];
        [searchDiv removeFromSuperview];
        searchDiv = nil;
        [soEntry setDivisionValues:recdData];
        return;
    }
    if ([procMessage isEqualToString:@"ITEMSELECT"]) 
    {
        searchItem = [[itemSearch alloc] initWithFrame:self.view.frame forOrientation:self.interfaceOrientation andReturnMethod:_callBackProcessor andCustCode:[p_dict valueForKey:@"custcode"]];
        [self.view addSubview:searchItem];
        return;
    }
    if ([procMessage isEqualToString:@"ITEMSET"]) 
    {
        
        NSDictionary *recdData = [p_dict valueForKey:@"data"];
        [searchItem removeFromSuperview];
        searchItem = nil;
        [soEntry setItemValues:recdData];
        return;
    }
    
    if ([procMessage isEqualToString:@"SOVIEW"]) 
    {
        NSString *l_soid = [p_dict valueForKey:@"soid"];
        [self presentDataForSOId:l_soid];
        return;
    }
    
    if ([procMessage isEqualToString:@"UOMSET"]) 
    {
        [soEntry setUOMSelected:[p_dict valueForKey:@"data"]];
        return;
    }
    
    if ([procMessage isEqualToString:@"SODETAILCHANGE"]) 
    {
        [self setNavigationForMode:@"SODETAILCHANGE"];
        return;
    }
    
    if ([procMessage isEqualToString:@"SOADD"]) 
    {
        [self setNavigationForMode:@"SOADD"];
        return;
    }
    
    if ([procMessage isEqualToString:@"SOEDIT"]) 
    {
        [self setNavigationForMode:@"SOEDIT"];
        return;
    }
    if ([procMessage isEqualToString:@"SMSIGNSELECT"]) 
    {
        UIImage *l_recdImage =(UIImage*)  [p_dict valueForKey:@"currimage"];
        getSign = [[getSignature alloc] initWithTitle:@"Salesman Signature" andCallBack:_callBackProcessor withCurrImage:l_recdImage andreturnContext:@"SMSIGNSET"];
        [self.view addSubview:getSign.view];
        return;
    }
    if ([procMessage isEqualToString:@"CUSIGNSELECT"]) 
    {
        UIImage *l_recdImage =(UIImage*)  [p_dict valueForKey:@"currimage"];
        getSign = [[getSignature alloc] initWithTitle:@"Customer Signature" andCallBack:_callBackProcessor withCurrImage:l_recdImage andreturnContext:@"CUSIGNSET"];
        [self.view addSubview:getSign.view];
        return;
    }
    if ([procMessage isEqualToString:@"SMSIGNSET"]) 
    {
        [getSign.view removeFromSuperview];
        getSign = nil;
        [soEntry setSignature:p_dict forType:@"SM"];
        return;
    }
    if ([procMessage isEqualToString:@"CUSIGNSET"]) 
    {
        [getSign.view removeFromSuperview];
        getSign = nil;
        [soEntry setSignature:p_dict forType:@"CU"];
        return;
    }
}

- (void) presentDataForSOId:(NSString*) p_soId
{
    [actView startAnimating];
    soEntry = [[salesOrderEntry alloc] initWithOrientation:self.interfaceOrientation andCallBack:_callBackProcessor andBackGround:self.view.backgroundColor];
    [self.view addSubview:soEntry];
    NSDictionary *getDispInputs = [[NSDictionary alloc] initWithObjectsAndKeys:p_soId, @"p_soid", nil];
    METHODCALLBACK l_soViewGenerated = ^(NSDictionary* p_dictInfo)
    {
        [self soViewDataGenerated:p_dictInfo];
    };
    [[ssWSProxy alloc] initWithReportType:@"DATAFORSOID" andInputParams:getDispInputs andReturnMethod:l_soViewGenerated];
}

- (void) soViewDataGenerated:(NSDictionary *)soInfo
{
    [soEntry setDataForDisplay:soInfo];
    [self setNavigationForMode:@"SOVIEW"];
    [actView stopAnimating];
}

- (void) setNavigationForMode:(NSString*) p_naviMode
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevButton setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [prevButton addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [prevButton setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
    prevButton.tag = 201;
    UIBarButtonItem *prevBarButton = [[UIBarButtonItem alloc] initWithCustomView:prevButton];
    //prevBarButton.tag = 201;
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [nextButton addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"Next.png"] forState:UIControlStateNormal];
    nextButton.tag = 202;
    UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    //nextBarButton.tag = 202;
    
    
    
    UIBarButtonItem *btnUser = [[UIBarButtonItem alloc] initWithTitle:[standardUserDefaults valueForKey:@"loggeduser"] style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
    btnUser.tag = 200;
    
    if ([p_naviMode isEqualToString:@"SOLIST"]) 
    {
        UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
        btnRefresh.tag = 100;
        UIBarButtonItem *btnADD = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ButtonPressed:)];
        btnADD.tag = 101;
        if (_addUpdateAllow) 
            navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnRefresh, btnADD, nil];
        else
            navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnRefresh,nil];
        
        navBar.topItem.leftBarButtonItems = [NSArray arrayWithObjects:btnUser, prevBarButton, nextBarButton, nil];;
        navBar.topItem.title = @"Sales Orders";
        
        //[navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }
    
    if ([p_naviMode isEqualToString:@"SOADD"]) 
    {
        UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(ButtonPressed:)];
        btnSave.tag = 102;
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ButtonPressed:)];
        btnCancel.tag = 103;
        
        navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnSave, btnCancel, nil];
        navBar.topItem.leftBarButtonItems = [NSArray arrayWithObjects:btnUser, nil];;
        navBar.topItem.title = @"Add Sales Order";
        
        //[navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }
    
    if ([p_naviMode isEqualToString:@"SOVIEW"]) 
    {
        UIBarButtonItem *btnPrint = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        btnPrint.tag = 104;
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        btnBack.tag = 105;
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        btnEdit.tag = 106;
        
        if (_addUpdateAllow) 
            navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnPrint, btnBack,btnEdit, nil];
        else
            navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnPrint, btnBack, nil];
        
        navBar.topItem.leftBarButtonItems = [NSArray arrayWithObjects:btnUser, nil];
        navBar.topItem.title = @"View Sales Order";
        
        // [navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }
    if ([p_naviMode isEqualToString:@"SOEDIT"]) 
    {
        UIBarButtonItem *btnUpdate = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        btnUpdate.tag = 102;
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ButtonPressed:)];
        btnCancel.tag = 103;
        
        navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnUpdate, btnCancel, nil];
        navBar.topItem.leftBarButtonItems = [NSArray arrayWithObjects:btnUser, nil];
        navBar.topItem.title = @"Edit/Update Sales Order";
        
        //[navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }
    if ([p_naviMode isEqualToString:@"SOVIEW"]) 
    {
        UIBarButtonItem *btnPrint = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        btnPrint.tag = 104;
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        btnBack.tag = 105;
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        btnEdit.tag = 106;
        
        if (_addUpdateAllow) 
            navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnPrint, btnBack,btnEdit, nil];
        else
            navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnPrint, btnBack, nil];
        
        navBar.topItem.leftBarButtonItems = [NSArray arrayWithObjects:btnUser, nil];
        navBar.topItem.title = @"View Sales Order";
        
        // [navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }
    if ([p_naviMode isEqualToString:@"SODETAILCHANGE"]) 
    {
        
        /*if (_addUpdateAllow) 
            navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnPrint, btnBack,btnEdit, nil];
        else
            navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnPrint, btnBack, nil];*/
        navBar.topItem.rightBarButtonItems = nil;
        
        
        // [navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }
    
}

- (IBAction)ButtonPressed:(id)sender
{
    int l_recdItemTag = 0;
    UIBarButtonItem *l_recdBtn = (UIBarButtonItem*) sender;
    l_recdItemTag = l_recdBtn.tag;
    switch (l_recdItemTag) 
    {
        case 100:
            [soList populateForOffsetDays];
            break;
        case 101:
            soEntry = [[salesOrderEntry alloc] initWithOrientation:self.interfaceOrientation andCallBack:_callBackProcessor andBackGround:self.view.backgroundColor];
            [self.view addSubview:soEntry];
            [self setNavigationForMode:@"SOADD"];
            break;
        case 102:
            for (UIBarButtonItem *tmpBtn in navBar.topItem.rightBarButtonItems) 
                tmpBtn.enabled=NO;
            [self saveData];
            break;
        case 103:
            dAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Are you sure\nto Cancel?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            dAlert.cancelButtonIndex = 0;
            dAlert.delegate = self;
            dAlert.tag = 100;
            [dAlert show];
            break;
        case 104:
            [self sendViewToPrint];
            break;
        case 105:
            [soEntry removeFromSuperview];
            soEntry = nil;
            [soList populateForOffsetDays];
            [self setNavigationForMode:@"SOLIST"];
            break;
        case 106:
            [soEntry setEditMode];
            [self setNavigationForMode:@"SOEDIT"];
            break;
        case 201:
            [actView startAnimating];
            [soList populateForOffsetDays:1];
            break;
        case 202:
            [actView stopAnimating];
            [soList populateForOffsetDays:-1];
            break;
        default:
            break;
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) 
    {
        if ([[soEntry getCurrentMode] isEqualToString:@"A"]) 
        {
            [soEntry removeFromSuperview];
            soEntry = nil;
            [self setNavigationForMode:@"SOLIST"];
            return;
        }
        else
        {
            [soEntry setViewListMode];
            [self setNavigationForMode:@"SOVIEW"];
            return;
        }
    }
}

- (void) saveData
{
    [actView startAnimating];
    NSDictionary *soValidate = [soEntry validateData];
    int respCode = [[soValidate valueForKey:@"RESPONSECODE"] integerValue];
    if (respCode) 
    {
        [self showAlertMessage:[soValidate valueForKey:@"RESPONSEMESSAGE"]];
        for (UIBarButtonItem *tmpBtn in navBar.topItem.rightBarButtonItems) 
            tmpBtn.enabled=YES;
        return;
    }
    METHODCALLBACK l_soSubmitReturn = ^(NSDictionary* p_dictInfo)
    {
        [self soEntryUpdated:p_dictInfo];
    };
    //NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[colnEntry getXMLForPosting],@"p_colndata", [colnEntry getImageStringFor:@"SM"], @"p_smsign", [colnEntry getImageStringFor:@"GB"], @"p_gbsign", [colnEntry getImageStringFor:@"CHQ"], @"p_chqphoto", nil];
    NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[soEntry getXMLForPosting],@"p_sodata", [soEntry getImageStringFor:@"SM"], @"p_smsign", [soEntry getImageStringFor:@"CU"], @"p_custsign",  nil];
    [[ssWSProxy alloc] initWithReportType:@"SOSUBMIT" andInputParams:inputDict andReturnMethod:l_soSubmitReturn];
}

- (void) soEntryUpdated:(NSDictionary *) p_soUpdateResult
{
    [actView stopAnimating];
    NSArray *recdItems = [[NSArray alloc] initWithArray:[p_soUpdateResult valueForKey:@"data"] copyItems:YES];
    NSDictionary *saveResult = [recdItems objectAtIndex:0];
    NSString *respCode = [[NSString alloc] initWithFormat:@"%@",[saveResult valueForKey:@"RESPONSECODE"]] ;
    NSString *respMessage = [[NSString alloc]  initWithFormat:@"%@",[saveResult valueForKey:@"RESPONSEMESSAGE"]];
    if ([respCode integerValue]!=0) 
    {
        [self showAlertMessage:respMessage];
        for (UIBarButtonItem *tmpBtn in navBar.topItem.rightBarButtonItems) 
            tmpBtn.enabled=YES;
    }
    else
    {
        [self showAlertMessage:[soEntry setAfterSaveOptions:saveResult]];
        [soEntry setViewListMode];
        [self setNavigationForMode:@"SOVIEW"];
    }
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}

- (void) sendViewToPrint
{
    METHODCALLBACK l_printReturn = ^(NSDictionary* p_dictInfo)
    {
        [self printingScreenBack:p_dictInfo];
    };
    soPreview = [[genPrintView alloc] initWithCollectionId:[soEntry getSOId] andOrientation:self.interfaceOrientation andFrame:self.view.frame andReporttype:@"sopreview" andIdFldName:@"soid" andReturnMethod:l_printReturn];
    [soPreview setForOrientation:self.interfaceOrientation];
    [self.view addSubview:soPreview];    
}

- (void) printingScreenBack:(NSDictionary*) printInfo
{
    [soPreview removeFromSuperview];
    soPreview = nil;
}

@end
