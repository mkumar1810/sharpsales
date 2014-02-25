//
//  salesOrderDataEntry.m
//  salesapi
//
//  Created by Imac on 5/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "salesOrderDataEntry.h"


@implementation salesOrderDataEntry

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andSOModifiedMethod:(METHODCALLBACK) p_soModifyReturn
{
    self = [super initWithFrame:frame];
    if (self) {
        initialFrame = frame;
        [self addNIBView:@"salesOrderDataEntry" forFrame:frame];
        //[[NSNotifixcationCenter defaultCenter] removexObserver:self];
        //[[NSNotifixcationCenter defaultCenter] addObserver:self selector:@selector(addNewDetailItemtoSO:) name:@"addNewDetailItemtoSO" object:nil];
        _soModifyCompleteMethod = p_soModifyReturn;
        __block id myself = self;
    
        _soObjectsReturn = ^(NSDictionary* p_dictInfo)
        {
            [myself addNewDetailItemtoSO:p_dictInfo];  
        };
        _divSelectMethod = ^(NSDictionary* p_dictInfo)
        {
            [myself showDivSelect:p_dictInfo];
        };
        _smSelMethod = ^(NSDictionary* p_dictInfo)
        {
            
        };
        _updateReturnMethod = ^(NSDictionary* p_dictInfo)
        {
            [myself soDetailRecordUpdated:p_dictInfo];
        };
        _soDetailItemEditMethod = ^(NSDictionary* p_dictInfo)
        {
            [myself editDetailItemofSO:p_dictInfo];
        };
        _custSelMethod = ^(NSDictionary* p_dictInfo)
        {
            [myself showCustomerSelect:p_dictInfo];
        };
    
        intOrientation = p_intOrientation;
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
        /*if (soObject) 
            [soObject release];*/
        soObject = [[salesOrderDataObjects alloc] initWithFrame:frame forOrientation:intOrientation andScrollview:_scrollview  andDictdata:nil andMode:@"A" andnewDetailReturn:_soObjectsReturn andDivSelectMethod:_divSelectMethod andSalesManSelMethod:_smSelMethod andDetailEditMethod:_soDetailItemEditMethod andCustSelMethod:_custSelMethod];
        rhsbutton.enabled = YES;
        _soid = [[NSString alloc] initWithFormat:@"%@",@"0"];
        [self addPrintButton];
        [[[self viewWithTag:10001] viewWithTag:1001] setHidden:YES];
        [self setForOrientation:intOrientation];
    }
    else
    {
        _soid = [[NSString alloc] initWithFormat:@"%@",p_entryid];
        METHODCALLBACK l_soDataGenerate = ^(NSDictionary* p_dictInfo)
        {
            [self SOViewDataGenerated:p_dictInfo];
        };
        NSDictionary *getDispInputs = [[NSDictionary alloc] initWithObjectsAndKeys:p_entryid, @"p_soid", nil];
        [[ssWSProxy alloc] initWithReportType:@"DATAFORSOID" andInputParams:getDispInputs andReturnMethod:l_soDataGenerate];
    }
}

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
    if ([_dataentryMode isEqualToString:@"L"]) [self addPrintButton];
    if (soPreview) {
        [soPreview setForOrientation:p_forOrientation];
        return;
    }
    if (searchCust) 
    {
        [searchCust setForOrientation:p_forOrientation];
        return;
    }
    if (searchSalesman) {
        [searchSalesman setForOrientation:p_forOrientation];
        return;
    }
    if (searchDiv) {
        [searchDiv setForOrientation:p_forOrientation];
        return;
    }
    if (searchPayterm) {
        [searchPayterm setForOrientation:p_forOrientation];
        return;
    }
    if (soDetEntry) {
        [soDetEntry setForOrientation:p_forOrientation];
        return;
    }
    if (soObject) 
    {
        [soObject setForOrientation:p_forOrientation];
        return;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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
    soPreview = [[genPrintView alloc] initWithCollectionId:_soid andOrientation:intOrientation andFrame:self.frame andReporttype:@"sopreview" andIdFldName:@"soid" andReturnMethod:l_printReturn];
    [soPreview setForOrientation:intOrientation];
    [self addSubview:soPreview];    
}

- (void) showCustomerSelect:(NSDictionary *)custInfo
{
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        METHODCALLBACK l_custReturn = ^(NSDictionary* p_dictInfo)
        {
            [self searchCustomerReturn:p_dictInfo];
        };
        searchCust = [[custSearch alloc] initWithFrame:self.frame forOrientation:intOrientation andReturnMethod:l_custReturn];
        [self addSubview:searchCust];
    }
}

- (void) showDivSelect:(NSDictionary *)divInfo
{
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        METHODCALLBACK l_divReturn = ^(NSDictionary* p_dictInfo)
        {
            [self searchDivReturn:p_dictInfo];
        };
        searchDiv = [[divSelect alloc] initWithFrame:self.frame forOrientation:intOrientation andReturnMethod:l_divReturn];
        [self addSubview:searchDiv];
    }
}

/*- (void) showSalesmanSelect:(NSDictionary *)salesmanInfo
{
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        METHODCALLBACK l_smSearchReturn = ^(NSDictionary* p_dictInfo)
        {
            [self searchSalesmanReturn:p_dictInfo];
        };
        searchSalesman = [[salesmanSelect alloc] initWithFrame:self.frame forOrientation:intOrientation andReturnMethod:l_smSearchReturn];
        [self addSubview:searchSalesman];
    }
}*/

- (void)dealloc
{
    //[[NSNotificxationCenter defaultCenter] removeOxbserver:self];
    //[super dealloc];
}

- (void) searchCustomerReturn:(NSDictionary *)custInfo
{
    NSDictionary *recdData = [custInfo valueForKey:@"data"];
    [searchCust removeFromSuperview];
    if (soObject) 
        [soObject setCustomerValues:recdData];
    //[searchCust release];
    searchCust = nil;
    [self setForOrientation:intOrientation];
}

- (void) searchDivReturn:(NSDictionary *)divInfo
{
    NSDictionary *recdData = [divInfo valueForKey:@"data"];
    [searchDiv removeFromSuperview];
    if (soObject) 
        [soObject setDivisionValues:recdData];
    //[searchDiv release];
    searchDiv = nil;
    [self setForOrientation:intOrientation];
}

/*- (void) searchSalesmanReturn:(NSDictionary *)salesmanInfo
{
    NSDictionary *recdData = [salesmanInfo valueForKey:@"data"];
    [searchSalesman removeFromSuperview];
    if (soObject) 
        [soObject setSalesmanValues:recdData];
    //[searchSalesman release];
    searchSalesman = nil;
    [self setForOrientation:intOrientation];
}*/

/*
- (void) searchPaytermReturn:(NSNotification *)paytermInfo
{
    NSDictionary *recdData = [[paytermInfo userInfo] valueForKey:@"data"];
    [searchPayterm removeFromSuperview];
    if (soObject) 
        [soObject setPaytermValues:recdData];
    [searchPayterm release];
    searchPayterm = nil;
    [self setForOrientation:intOrientation];
}
*/
- (void) SOViewDataGenerated : (NSDictionary*) soViewDataInfo
{
    if ([_dataentryMode isEqualToString:@"L"]) 
    {
        CGRect frame;
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
            frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 768, 1004);
        else
            frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 1028, 768);    
        NSMutableArray *recdData = [[NSMutableArray alloc] initWithArray:[soViewDataInfo valueForKey:@"data"] copyItems:YES] ;
        /*if (soObject) 
            [soObject release];*/
        soObject = [[salesOrderDataObjects alloc] initWithFrame:frame forOrientation:intOrientation andScrollview:_scrollview  andDictdata:soViewDataInfo andMode:_dataentryMode andnewDetailReturn:_soObjectsReturn andDivSelectMethod:_divSelectMethod andSalesManSelMethod:_smSelMethod andDetailEditMethod:_soDetailItemEditMethod andCustSelMethod:_custSelMethod];
        [self setForOrientation:intOrientation];
        [forTitle setTitle:@"View Sales order Entry"];
        [rhsbutton setTitle:@"Edit"];
        NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
        [nsdf setDateFormat:@"d-MMM-yyyy"];
        NSString *sodate = [[recdData objectAtIndex:0] valueForKey:@"SODATE"];
        if ([sodate isEqualToString:[nsdf stringFromDate:[NSDate date]]]==NO) 
            rhsbutton.enabled = NO;
        
        [self addPrintButton];
    }
}

- (void) addNewDetailItemtoSO : (NSDictionary*) newItemInfo
{
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        NSString *l_custcode = [[NSString alloc] initWithFormat:@"%@",[newItemInfo valueForKey:@"custcode"]];
        soDetEntry = [[salesOrderDetailDataEntry alloc] initWithFrame:self.frame forOrientation:intOrientation andCustomerCode:l_custcode andReturnMethod:_updateReturnMethod];
        [soDetEntry setEntrymode:@"A" andEntryId:@"0"];
        [self addSubview:soDetEntry];
    }
}

- (void) editDetailItemofSO : (NSDictionary*) editItemInfo
{
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        NSString *l_custcode = [[NSString alloc] initWithFormat:@"%@",[editItemInfo valueForKey:@"custcode"]];
        soDetEntry = [[salesOrderDetailDataEntry alloc] initWithFrame:self.frame forOrientation:intOrientation andCustomerCode:l_custcode andReturnMethod:_updateReturnMethod];
        [soDetEntry setEntrymode:@"E" andEntryId:[editItemInfo valueForKey:@"EDITITEM"] withDictData:[editItemInfo valueForKey:@"EDITDATA"]];
        [self addSubview:soDetEntry];
    }
}


- (void) soDetailRecordUpdated : (NSDictionary*) updatedDetailInfo
{
    NSDictionary *recdData = [updatedDetailInfo valueForKey:@"savedData"];
    NSString *updatedMode = [updatedDetailInfo valueForKey:@"SAVEMODE"];
    [soDetEntry removeFromSuperview];
    //[soDetEntry release];
    soDetEntry = nil;
    if (!recdData) return;
    if ([updatedMode isEqualToString:@"Add"]) 
        [soObject addNewlyAddedDetail:recdData];
    else
    {
        int slNo = [[updatedDetailInfo  valueForKey:@"EDITITEM"] intValue];
        [soObject updateModifiedDetail:recdData inSlNo:slNo];
    }
}


- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
} 

- (IBAction) saveData:(id) sender
{
    if ([rhsbutton.title isEqualToString:@"Save"]) 
    {
        rhsbutton.enabled = NO;
        NSDictionary *soValidate = [soObject validateData];
        int respCOde = [[soValidate valueForKey:@"RESPONSECODE"] integerValue];
        if (respCOde) 
        {
            [self showAlertMessage:[soValidate valueForKey:@"RESPONSEMESSAGE"]];
            rhsbutton.enabled = YES;
            return;
        }
        if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
        {
            METHODCALLBACK l_soSubmitReturn = ^(NSDictionary* p_dictInfo)
            {
                [self salesOrderSubmitted:p_dictInfo];
            };
            NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[soObject getXMLForPosting],@"p_sodata", nil];
            [[ssWSProxy alloc] initWithReportType:@"SOSUBMIT" andInputParams:inputDict andReturnMethod:l_soSubmitReturn];
        }
        
        return;
    }
    if ([rhsbutton.title isEqualToString:@"Edit"]) 
    {
        _dataentryMode = @"E";
        [soObject setEditMode];
        [rhsbutton setTitle:@"Save"];
        [forTitle setTitle:@"Edit Sales Order Entry"];
        [[[self viewWithTag:10001] viewWithTag:1001] setHidden:YES];
    }
}

- (void) salesOrderSubmitted : (NSDictionary*) soSubmitInfo
{
    NSArray *recdItems = [[NSArray alloc] initWithArray:[soSubmitInfo valueForKey:@"data"] copyItems:YES];
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
            NSString *sono = [[NSString alloc] initWithFormat:@"%@ / %@",[saveResult valueForKey:@"SONO"],[saveResult valueForKey:@"SODATE"]];
            [self showAlertMessage:@"New Sales Order Entry added"];
            [soObject setSONo: sono];
        }
        else
            [self showAlertMessage:@"Sales Order details modified"];
        [[[self viewWithTag:10001] viewWithTag:1001] setHidden:NO];
        [soObject changeModetoView];
        _soid = [[NSString alloc] initWithFormat:@"%@",  [saveResult valueForKey:@"SOID"]];
        rhsbutton.enabled = NO;
    }
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
    //[[NSNotificxationCenter defaultCenter] postNotifxicationName:@"salesorderEntryModified" object:self userInfo:returnInfo];
    _soModifyCompleteMethod(returnInfo);
}

                 
- (void) printingScreenBack:(NSDictionary*) printInfo
{
    [soPreview removeFromSuperview];
    /*if (soPreview) 
        [soPreview release];*/
    soPreview = nil;
    [self setForOrientation:intOrientation];
}

@end
