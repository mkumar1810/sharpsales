//
//  salesOrderDetailDataEntry.m
//  salesapi
//
//  Created by Imac on 5/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "salesOrderDetailDataEntry.h"


@implementation salesOrderDetailDataEntry

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andCustomerCode:(NSString*) p_custcode andReturnMethod:(METHODCALLBACK) p_returnMethod
{
    self = [super initWithFrame:frame];
    if (self) {
        initialFrame = frame;
        _custcode = [[NSString alloc] initWithFormat:@"%@",p_custcode];
        _returnMethod = p_returnMethod;
        [self addNIBView:@"salesOrderDetailDataEntry" forFrame:frame];
        //[[NSNotificaxtionCenter defaultCenter] removeObserver:self];
        __block id myself = self;
        _itemReturnMethod = ^(NSDictionary* p_dictInfo)
        {
            [myself showItemSelect:p_dictInfo];
        };
        _uomReturnMethod = ^(NSDictionary* p_dictInfo)
        {
            //[self showUOMSelect:p_dictInfo];
        };
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showItemSelect:) name:@"selectItemForSODetail" object:nil];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchItemReturn:) name:@"searchItemReturnToSODetail" object:nil];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUOMSelect:) name:@"selectUOMForSODetail" object:nil];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectUOMFromLOV:) name:@"searchUOMReturn" object:nil];
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
    if (searchItem) 
    {
        [searchItem setForOrientation:p_forOrientation];
        return;
    }
    
    if (soDetObj) 
    {
        [soDetObj setForOrientation:p_forOrientation];
        return;
    }
}

- (void) setEntrymode:(NSString*) p_entrymode andEntryId:(NSString*) p_entryid withDictData:(NSDictionary*) p_editDict
{
    CGRect frame;
    _dataentryMode = [[NSString alloc] initWithFormat:@"%@", p_entrymode];
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 768, 1004);
    else
        frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 1028, 768);    
    _dataentryid = [[NSString alloc] initWithFormat:@"%@", p_entryid];
    if ([p_entrymode isEqualToString:@"E"]) 
    {
        /*if (soDetObj) 
            [soDetObj release];*/
        soDetObj = [[salesOrderDetailObjects alloc] initWithFrame:frame forOrientation:intOrientation andScrollview:_scrollview  andDictdata:p_editDict andMode:@"E" andItemMethod:_itemReturnMethod andUOMMethod:_uomReturnMethod];
        rhsbutton.enabled = YES;
        rhsbutton.title = @"Update";
        [forTitle setTitle:@"Edit Sales Order Item"];
        [self setForOrientation:intOrientation];
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
    _dataentryid = [[NSString alloc] initWithFormat:@"%@", p_entryid];
    if ([p_entrymode isEqualToString:@"A"]) 
    {
        /*if (soDetObj) 
            [soDetObj release];*/
        soDetObj = [[salesOrderDetailObjects alloc] initWithFrame:frame forOrientation:intOrientation andScrollview:_scrollview  andDictdata:nil andMode:@"A" andItemMethod:_itemReturnMethod andUOMMethod:_uomReturnMethod];
        rhsbutton.enabled = YES;
        rhsbutton.title = @"Add";
        [self setForOrientation:intOrientation];
    }
}


- (void) showItemSelect:(NSDictionary *)custInfo
{
    if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        METHODCALLBACK l_itemReturn = ^(NSDictionary* p_dictInfo)
        {
            [self searchItemReturn:p_dictInfo];
        };
        searchItem = [[itemSearch alloc] initWithFrame:self.frame forOrientation:intOrientation andReturnMethod:l_itemReturn andCustCode:_custcode];
        [self addSubview:searchItem];
    }
}

- (void) showUOMSelect:(NSDictionary *)uomInfo
{
    /*if ([_dataentryMode isEqualToString:@"A"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        //NSDictionary *uomdata = [uomInfo userInfo];
        //NSLog(@"uom related info received %@",uomdata);
        NSString *uomlist = [uomInfo valueForKey:@"uomlist"];
        METHODCALLBACK l_setUOM = ^(NSDictionary* p_dictInfo)
        {
            [self selectUOMFromLOV:p_dictInfo];
        };
        searchUOM = [[uomSearch alloc] initWithFrame:self.frame forOrientation:intOrientation andUOMList:uomlist andReturnMethod:l_setUOM];
        [self addSubview:searchUOM];
    }*/
}

- (void) selectUOMFromLOV:(NSDictionary*) uomInfo
{
    NSDictionary *recdData = [uomInfo valueForKey:@"data"];
    [searchUOM removeFromSuperview];
    if (soDetObj) 
        [soDetObj setUOMValues:recdData];
    //[searchUOM release];
    searchUOM = nil;
    [self setForOrientation:intOrientation];
}

- (void) searchItemReturn:(NSDictionary *)itemInfo
{
    NSDictionary *recdData = [itemInfo valueForKey:@"data"];
    [searchItem removeFromSuperview];
    if (soDetObj) 
        [soDetObj setItemValues:recdData];
    //[searchItem release];
    searchItem = nil;
    [self setForOrientation:intOrientation];
}

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //[super dealloc];
}

- (IBAction) goBack:(id) sender
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:nil forKey:@"savedData"];
    //[[NSNotificxationCenter defaultCenter] postNotifxicationName:@"soDetailEntryUpdated" object:self userInfo:returnInfo];
    _returnMethod(returnInfo);
}

- (IBAction) saveData:(id) sender
{
    if ([rhsbutton.title isEqualToString:@"Add"] | [rhsbutton.title isEqualToString:@"Update"]) 
    {
        rhsbutton.enabled = NO;
        NSDictionary *colnValidate = [soDetObj validateData];
        int respCOde = [[colnValidate valueForKey:@"RESPONSECODE"] integerValue];
        if (respCOde) 
        {
            [self showAlertMessage:[colnValidate valueForKey:@"RESPONSEMESSAGE"]];
            rhsbutton.enabled = YES;
            return;
        }
        savedData = [[NSDictionary alloc] initWithDictionary:[soDetObj getEnteredDetails]];
        //NSLog(@"updated informations %@",savedData);
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:savedData forKey:@"savedData"];
        [returnInfo setValue:rhsbutton.title forKey:@"SAVEMODE"];
        [returnInfo setValue:_dataentryid forKey:@"EDITITEM"];
        //[[NSNotificxationCenter defaultCenter] postNotifixcationName:@"soDetailEntryUpdated" object:self userInfo:returnInfo];
        _returnMethod(returnInfo);
        rhsbutton.enabled = NO;
        return;
    }
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}

@end
