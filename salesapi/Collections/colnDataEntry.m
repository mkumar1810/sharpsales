//
//  colnDataEntry.m
//  salesapi
//
//  Created by Raja T S Sekhar on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "colnDataEntry.h"


@implementation colnDataEntry

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andModifiedReturnMethod:(METHODCALLBACK) p_returnMethod
{
    self = [super initWithFrame:frame];
    if (self) {
        initialFrame = frame;
        [self addNIBView:@"colnDataEntry" forFrame:frame];
        _returnMethod = p_returnMethod;
        intOrientation = p_intOrientation;
        __block id myself = self;
        _custSelect = ^(NSDictionary* p_dictInfo)
        {
            [myself showCustomerSelect:p_dictInfo];
        };
        _bankSelect = ^(NSDictionary* p_dictInfo)
        {
            [myself showBankSelect:p_dictInfo];
        };
    }
    return self;
}

- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:nibName
                                                      owner:self
                                                    options:nil];
    UIView *newview = [nibViews objectAtIndex:0];
    [newview setFrame:forframe];
    newview.tag = 10001;
    [self addSubview:newview];        // Initialization code
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    CGRect frame;
    intOrientation = p_forOrientation;
    if (UIInterfaceOrientationIsPortrait(p_forOrientation)) 
        frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 768, 1004);
    else
        frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 1028, 768);
    [self setFrame:frame];
    [_scrollview setFrame:CGRectMake(0, 45, 1028, 1028)];
    [_scrollview setContentOffset:CGPointMake(0, 0) animated:NO];
    [self addPrintButton];
    if (searchCust) 
    {
        [searchCust setForOrientation:p_forOrientation];
        return;
    }
    if (searchBank) {
        [searchBank setForOrientation:p_forOrientation];
        return;
    }
    
    if (colnObject) 
    {
        [colnObject setForOrientation:p_forOrientation];
        if (colnpv) 
            [colnpv setForOrientation:p_forOrientation];
        return;
    }
}

- (void) setEntrymode:(NSString*) p_entrymode andEntryId:(NSString*) p_entryid
{
    CGRect frame;
    _dataentryMode = [[NSString alloc] initWithFormat:@"%@", p_entrymode];
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 768, 1004);
    else
        frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 1028, 768);    
    if ([p_entrymode isEqualToString:@"A"]) 
    {
        /*if (colnObject) 
            [colnObject release];*/
        colnObject = [[colnDataObjects alloc] initWithFrame:frame forOrientation:intOrientation andScrollview:_scrollview  andDictdata:nil andMode:@"A" andCustSelectMethod:_custSelect andBankSelMethod:_bankSelect];
        rhsbutton.enabled = YES;
        [self setForOrientation:intOrientation];
    }
    else
    {
        _collectionid = [[NSString alloc] initWithFormat:@"%@",p_entryid];
        NSDictionary *getDispInputs = [[NSDictionary alloc] initWithObjectsAndKeys:p_entryid, @"p_collectionid", nil];
        METHODCALLBACK l_colnViewGenerated = ^(NSDictionary* p_dictInfo)
        {
            [self colnViewDataGenerated:p_dictInfo];
        };
        [[ssWSProxy alloc] initWithReportType:@"COLLECTIONVIEW" andInputParams:getDispInputs andReturnMethod:l_colnViewGenerated];
    }
}

- (void) colnViewDataGenerated:(NSDictionary *)colnInfo
{
    if ([_dataentryMode isEqualToString:@"L"]) 
    {
        CGRect frame;
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
            frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 768, 1004);
        else
            frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 1028, 768);    
        NSMutableArray *recdData = [[NSMutableArray alloc] initWithArray:[colnInfo valueForKey:@"data"] copyItems:YES] ;
        /*if (colnObject) 
            [colnObject release];*/
        colnObject = [[colnDataObjects alloc] initWithFrame:frame forOrientation:intOrientation andScrollview:_scrollview  andDictdata:[recdData objectAtIndex:0] andMode:_dataentryMode andCustSelectMethod:_custSelect andBankSelMethod:_bankSelect];
        [self setForOrientation:intOrientation];
        [forTitle setTitle:@"View Collection Entry"];
        [rhsbutton setTitle:@"Edit"];
        NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
        [nsdf setDateFormat:@"d-MMM-yyyy"];
        NSString *receiptdate = [[recdData objectAtIndex:0] valueForKey:@"RECEIPTDATE"];
        //NSLog(@"receipt date %@ and current date %@",receiptdate,[nsdf stringFromDate:[NSDate date]]);
        if ([receiptdate isEqualToString:[nsdf stringFromDate:[NSDate date]]]==NO) 
            rhsbutton.enabled = NO;
        
        [self addPrintButton];
        //rhsbutton.enabled = NO;
    }
}

- (void) showCustomerSelect:(NSDictionary *)custInfo
{
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        METHODCALLBACK l_searchCustReturn = ^(NSDictionary* p_dictInfo)
        {
            [self searchCustomerReturn:p_dictInfo];
        };
        searchCust = [[custSearch alloc] initWithFrame:self.frame forOrientation:intOrientation andReturnMethod:l_searchCustReturn];
        [self addSubview:searchCust];
    }
}

- (void) showBankSelect:(NSDictionary *)bankInfo
{
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        METHODCALLBACK l_bankReturn = ^(NSDictionary* p_dictInfo)
        {
            [self selectBankFromLOV:p_dictInfo];
        };
        searchBank = [[bankSearch alloc] initWithFrame:self.frame forOrientation:intOrientation andReturnMethod:l_bankReturn];
        [self addSubview:searchBank];
    }
}

- (void) selectBankFromLOV:(NSDictionary*) bankInfo
{
    NSDictionary *recdData = [bankInfo valueForKey:@"data"];
    [searchBank removeFromSuperview];
    if (colnObject) 
        [colnObject setBankValues:recdData];
    //[searchBank release];
    searchBank = nil;
    [self setForOrientation:intOrientation];
}

- (void) printingScreenBack:(NSDictionary*) printInfo
{
    [colnpv removeFromSuperview];
    /*if (colnpv) 
        [colnpv release];*/
    colnpv = nil;
    [self setForOrientation:intOrientation];
}

- (void) searchCustomerReturn:(NSDictionary *)custInfo
{
    NSDictionary *recdData = [custInfo valueForKey:@"data"];
    [searchCust removeFromSuperview];
    if (colnObject) 
        [colnObject setCustomerValues:recdData];
    //[searchCust release];
    searchCust = nil;
    [self setForOrientation:intOrientation];
}

- (void)dealloc
{
    //[[NSNotifixcationCenter defaultCenter] removeOxbserver:self];
    //[super dealloc];
}

- (IBAction) goBack:(id) sender
{
    NSString *opmode;
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"])
    {
        if (rhsbutton.enabled) 
            opmode = [[NSString alloc] initWithFormat:@"%@",_dataentryMode]; 
        else
            opmode = [[NSString alloc] initWithFormat:@"%@",@"S"]; 
    }   
    else 
        opmode = [[NSString alloc] initWithFormat:@"%@",_dataentryMode]; 
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:opmode forKey:@"opmode"];
    //[[NSNotificxationCenter defaultCenter] postNotifxicationName:@"colnEntryModified" object:self userInfo:returnInfo];
    _returnMethod(returnInfo);
}

- (void) collectionEntryUpdated:(NSDictionary *)colnAddResult
{
    NSArray *recdItems = [[NSArray alloc] initWithArray:[colnAddResult valueForKey:@"data"] copyItems:YES];
    NSDictionary *saveResult = [recdItems objectAtIndex:0];
    NSString *respCode = [[NSString alloc] initWithFormat:@"%@",[saveResult valueForKey:@"RESPONSECODE"]] ;
    NSString *respMessage = [[NSString alloc]  initWithFormat:@"%@",[saveResult valueForKey:@"RESPONSEMESSAGE"]];
    if ([respCode integerValue]!=0) 
    {
        [self showAlertMessage:respMessage];
        rhsbutton.enabled = YES;
    }
    else
    {
        if ([_dataentryMode isEqualToString:@"A"]) 
        {
            NSString *recptno = [[NSString alloc] initWithFormat:@"%@ / %@",[saveResult valueForKey:@"RECEIPTNO"],[saveResult valueForKey:@"RECEIPTDATE"]];
            [self showAlertMessage:@"New Collection Entry added"];
            [colnObject setReceiptNo: recptno];
        }
        else
            [self showAlertMessage:@"Collection details modified"];
        [[[self viewWithTag:10001] viewWithTag:1001] setHidden:NO];
        [colnObject changeModetoView];
        _collectionid = [[NSString alloc] initWithFormat:@"%@",  [saveResult valueForKey:@"COLLECTIONID"]];
        rhsbutton.enabled = NO;
    }
}

- (IBAction) saveData:(id) sender
{
    if ([rhsbutton.title isEqualToString:@"Save"]) 
    {
        rhsbutton.enabled = NO;
        NSDictionary *colnValidate = [colnObject validateData];
        int respCOde = [[colnValidate valueForKey:@"RESPONSECODE"] integerValue];
        if (respCOde) 
        {
            [self showAlertMessage:[colnValidate valueForKey:@"RESPONSEMESSAGE"]];
            rhsbutton.enabled = YES;
            return;
        }
        if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
        {
            NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[colnObject getXMLForPosting],@"p_colndata", nil];
            METHODCALLBACK l_colnSubmitReturn = ^(NSDictionary* p_dictInfo)
            {
                [self collectionEntryUpdated:p_dictInfo];
            };
            [[ssWSProxy alloc] initWithReportType:@"COLNSUBMIT" andInputParams:inputDict andReturnMethod:l_colnSubmitReturn];
        }
        return;
    }
    if ([rhsbutton.title isEqualToString:@"Edit"]) 
    {
        _dataentryMode = @"E";
        [colnObject setEditMode];
        [rhsbutton setTitle:@"Save"];
        [forTitle setTitle:@"Edit Collection Entry"];
        [[[self viewWithTag:10001] viewWithTag:1001] setHidden:YES];
    }
    
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}

- (void) addPrintButton
{
    UIButton *printButton;
    if([UIPrintInteractionController isPrintingAvailable]==NO) return;
    
    UIImage *leftbuttonImage = [UIImage imageNamed:@"print.png"];
    printButton =(UIButton*) [[self viewWithTag:10001] viewWithTag:1001] ;
    if (printButton) {
        if (UIInterfaceOrientationIsPortrait(intOrientation)==YES)
            [printButton setFrame:CGRectMake(670,10,30,30)];
        else
            [printButton setFrame:CGRectMake(900,10,30,30)];
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(intOrientation)==YES)
            printButton = [[UIButton alloc] initWithFrame:CGRectMake(670,10,30,30)];
        else
            printButton = [[UIButton alloc] initWithFrame:CGRectMake(900,10,30,30)];
        printButton.titleLabel.text=@"";
        [printButton setImage:leftbuttonImage forState:UIControlStateNormal];
        printButton.tag = 1001;
        [printButton addTarget:self action:@selector(sendViewToPrint:) forControlEvents:UIControlEventTouchDown];
        [[self viewWithTag:10001] addSubview:printButton];
        //[printButton release];
    }
}

- (IBAction) sendViewToPrint:(id) sender
{
    METHODCALLBACK l_printReturn = ^(NSDictionary* p_dictInfo)
    {
        [self printingScreenBack:p_dictInfo];
    };
    colnpv = [[genPrintView alloc] initWithCollectionId:_collectionid andOrientation:intOrientation andFrame:self.frame andReporttype:@"collectionpreview" andIdFldName:@"collectionid" andReturnMethod:l_printReturn];
    [colnpv setForOrientation:intOrientation];
    [self addSubview:colnpv];    
}

@end
