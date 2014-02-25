//
//  collectionMainHome.m
//  dssapi
//
//  Created by Raja T S Sekhar on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "collectionMainHome.h"

@implementation collectionMainHome

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"Database"];
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
    [self generateCollectionsList];
    [super viewDidLoad];
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    actView.transform = CGAffineTransformMakeScale(5.00, 5.00);        
    [self setNavigationForMode:@"COLNLIST"];
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
    //_intOrientation = toInterfaceOrientation;
    [self setViewResizedForOrientation:toInterfaceOrientation];
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation
{
    if (colnEntry) 
        [colnEntry setForOrientation:p_intOrientation];
    
    if (colnList) 
        [colnList setForOrientation:p_intOrientation];
    
    if (searchCust) 
        [searchCust setForOrientation:p_intOrientation];
    
    if (searchBank) 
        [searchBank setForOrientation:p_intOrientation];
    
    if (colnpv) 
        [colnpv setForOrientation:p_intOrientation];
    
}

- (void) generateCollectionsList
{
    colnList = [[colnListTV alloc] initWithOrientation:self.interfaceOrientation andCallBack:_callBackProcessor];
    [self.view addSubview:colnList];
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
        dispLabel.text = [colnList getTitleForDisplay];
        if ([[p_dict valueForKey:@"offset"] intValue]==0) 
            _addUpdateAllow = TRUE;
        else
            _addUpdateAllow = FALSE;
        [actView stopAnimating];
        [self setNavigationForMode:@"COLNLIST"];
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
        [colnEntry setCustomerInformation:recdData];
        return;
    }
    if ([procMessage isEqualToString:@"BANKSELECT"]) 
    {
        searchBank = [[bankSearch alloc] initWithFrame:self.view.frame forOrientation:self.interfaceOrientation andReturnMethod:_callBackProcessor];
        [self.view addSubview:searchBank];
        return;
    }
    if ([procMessage isEqualToString:@"BANKSET"]) 
    {
        
        NSDictionary *recdData = [p_dict valueForKey:@"data"];
        [searchBank removeFromSuperview];
        searchBank = nil;
        [colnEntry setBankValues:recdData];
        return;
    }
    if ([procMessage isEqualToString:@"COLLECTIONVIEW"]) 
    {
        NSString *l_colnid = [p_dict valueForKey:@"collectionid"];
        [self presentDataForColnId:l_colnid];
        return;
    }
    if ([procMessage isEqualToString:@"SMSIGNSELECT"]) 
    {
        UIImage *l_recdImage =(UIImage*)  [p_dict valueForKey:@"currimage"];
        getSign = [[getSignature alloc] initWithTitle:@"Salesman Signature" andCallBack:_callBackProcessor withCurrImage:l_recdImage andreturnContext:@"SMSIGNSET"];
        [self.view addSubview:getSign.view];
        return;
    }
    if ([procMessage isEqualToString:@"GBSIGNSELECT"]) 
    {
        UIImage *l_recdImage =(UIImage*)  [p_dict valueForKey:@"currimage"];
        getSign = [[getSignature alloc] initWithTitle:@"Customer Signature" andCallBack:_callBackProcessor withCurrImage:l_recdImage andreturnContext:@"GBSIGNSET"];
        [self.view addSubview:getSign.view];
        return;
    }
    if ([procMessage isEqualToString:@"SMSIGNSET"]) 
    {
        [getSign.view removeFromSuperview];
        getSign = nil;
        [colnEntry setSignature:p_dict forType:@"SM"];
        return;
    }
    if ([procMessage isEqualToString:@"GBSIGNSET"]) 
    {
        [getSign.view removeFromSuperview];
        getSign = nil;
        [colnEntry setSignature:p_dict forType:@"GB"];
        return;
    }
    if ([procMessage isEqualToString:@"CHEQUESELECT"]) 
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
        {
            imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
            [self presentModalViewController:imgPicker animated:YES];
        }
        else
            [self showAlertMessage:@"Camera is not available"];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    //image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
    image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    if (image != nil) 
    {
        [colnEntry setChequeImage:image];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void) presentDataForColnId:(NSString*) p_collectionId
{
    [actView startAnimating];
    colnEntry = [[collectionEntry alloc] initWithOrientation:self.interfaceOrientation andCallBack:_callBackProcessor andBackGround:self.view.backgroundColor];
    [self.view addSubview:colnEntry];
    NSDictionary *getDispInputs = [[NSDictionary alloc] initWithObjectsAndKeys:p_collectionId, @"p_collectionid", nil];
    METHODCALLBACK l_colnViewGenerated = ^(NSDictionary* p_dictInfo)
    {
        [self colnViewDataGenerated:p_dictInfo];
    };
    [[ssWSProxy alloc] initWithReportType:@"COLLECTIONVIEW" andInputParams:getDispInputs andReturnMethod:l_colnViewGenerated];
}

- (void) colnViewDataGenerated:(NSDictionary *)colnInfo
{
    NSMutableArray *recdData = [[NSMutableArray alloc] initWithArray:[colnInfo valueForKey:@"data"] copyItems:YES];
    NSDictionary *l_dict = [recdData objectAtIndex:0];
    [colnEntry setDataForDisplay:l_dict];
    [self setNavigationForMode:@"ENTRYVIEW"];
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
    
    if ([p_naviMode isEqualToString:@"COLNLIST"]) 
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
        navBar.topItem.title = @"Collections";
        
        //[navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }
    
    if ([p_naviMode isEqualToString:@"ENTRYADD"]) 
    {
        UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(ButtonPressed:)];
        btnSave.tag = 102;
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ButtonPressed:)];
        btnCancel.tag = 103;
        
        navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnSave, btnCancel, nil];
        navBar.topItem.leftBarButtonItems = [NSArray arrayWithObjects:btnUser, nil];;
        navBar.topItem.title = @"Add Collection";
        
        //[navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }

    if ([p_naviMode isEqualToString:@"ENTRYVIEW"]) 
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
        navBar.topItem.title = @"View Collection";
        
       // [navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
        return;
    }
    if ([p_naviMode isEqualToString:@"COLNEDIT"]) 
    {
        UIBarButtonItem *btnUpdate = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        btnUpdate.tag = 102;
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ButtonPressed:)];
        btnCancel.tag = 103;
        
        navBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:btnUpdate, btnCancel, nil];
        navBar.topItem.leftBarButtonItems = [NSArray arrayWithObjects:btnUser, nil];
        navBar.topItem.title = @"Edit/Update Collection";
        
        //[navBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
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
            [colnList populateForOffsetDays];
            break;
        case 101:
            colnEntry = [[collectionEntry alloc] initWithOrientation:self.interfaceOrientation andCallBack:_callBackProcessor andBackGround:self.view.backgroundColor];
            [self.view addSubview:colnEntry];
            [self setNavigationForMode:@"ENTRYADD"];
            break;
        case 102:
            //l_recdBtn.enabled = NO;
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
            [colnEntry removeFromSuperview];
            colnEntry = nil;
            [colnList populateForOffsetDays];
            [self setNavigationForMode:@"COLNLIST"];
            break;
        case 106:
            [colnEntry setEditMode];
            [self setNavigationForMode:@"COLNEDIT"];
            break;
        case 201:
            [actView startAnimating];
            [colnList populateForOffsetDays:1];
            break;
        case 202:
            [actView stopAnimating];
            [colnList populateForOffsetDays:-1];
            break;
        default:
            break;
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) 
    {
        if ([[colnEntry getCurrentMode] isEqualToString:@"A"]) 
        {
            [colnEntry removeFromSuperview];
            colnEntry = nil;
            [self setNavigationForMode:@"COLNLIST"];
            return;
        }
        else
        {
            [colnEntry displayDictValues];
            [self setNavigationForMode:@"ENTRYVIEW"];
            return;
        }
    }
}

- (void) saveData
{
     [actView startAnimating];
    NSDictionary *colnValidate = [colnEntry validateData];
    int respCode = [[colnValidate valueForKey:@"RESPONSECODE"] integerValue];
    if (respCode) 
    {
        [self showAlertMessage:[colnValidate valueForKey:@"RESPONSEMESSAGE"]];
        for (UIBarButtonItem *tmpBtn in navBar.topItem.rightBarButtonItems) 
            tmpBtn.enabled=YES;
        return;
    }
    NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[colnEntry getXMLForPosting],@"p_colndata", [colnEntry getImageStringFor:@"SM"], @"p_smsign", [colnEntry getImageStringFor:@"GB"], @"p_gbsign", [colnEntry getImageStringFor:@"CHQ"], @"p_chqphoto", nil];
    METHODCALLBACK l_colnSubmitReturn = ^(NSDictionary* p_dictInfo)
    {
        [self collectionEntryUpdated:p_dictInfo];
    };
    [[ssWSProxy alloc] initWithReportType:@"COLNSUBMIT" andInputParams:inputDict andReturnMethod:l_colnSubmitReturn];
}

- (void) collectionEntryUpdated:(NSDictionary *) p_colnUpdateResult
{
    //NSLog(@"The result of save %@", p_colnUpdateResult);
    NSArray *recdItems = [[NSArray alloc] initWithArray:[p_colnUpdateResult valueForKey:@"data"] copyItems:YES];
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
        [self showAlertMessage:[colnEntry setAfterSaveOptions:saveResult]];
        [colnEntry setViewListMode];
        [self setNavigationForMode:@"ENTRYVIEW"];
    }
    [actView stopAnimating];
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
    colnpv = [[genPrintView alloc] initWithCollectionId:[colnEntry getCollectionId] andOrientation:self.interfaceOrientation andFrame:self.view.frame andReporttype:@"collectionpreview" andIdFldName:@"collectionid" andReturnMethod:l_printReturn];
    [self.view addSubview:colnpv];    
}

- (void) printingScreenBack:(NSDictionary*) printInfo
{
    [colnpv removeFromSuperview];
    colnpv = nil;
}

@end
