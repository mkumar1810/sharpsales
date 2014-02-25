//
//  salesOrderListTV.m
//  salesapi
//
//  Created by Macintosh User on 28/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "salesOrderListTV.h"

@implementation salesOrderListTV

- (id)initWithOrientation:(UIInterfaceOrientation) p_intOrientation andCallBack:(METHODCALLBACK) p_callback
{
    self = [super initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if (self) {
        _intOrientation = p_intOrientation;
        _returnCallBack = p_callback;
        _currOffset = 0;
        [self setFrame:[self getFrameForOrientation:p_intOrientation]];
        [self setBackgroundView:nil];
        [self setBackgroundView:[[UIView alloc] init]];
        [self setBackgroundColor:UIColor.clearColor];
        [self setDataSource:self];
        [self setDelegate:self];
        // Initialization code
        [self populateForOffsetDays];
    }
    return self;
}


- (CGRect) getFrameForOrientation:(UIInterfaceOrientation) p_intOrientation
{
    if UIInterfaceOrientationIsPortrait(p_intOrientation)
        return CGRectMake(0, 110, 768, 820);
    else
        return CGRectMake(0, 110, 980, 560);
}

- (void) setForOrientation:(UIInterfaceOrientation)p_forOrientation
{
    _intOrientation = p_forOrientation;
    [self setFrame:[self getFrameForOrientation:_intOrientation]];
    [self reloadData];
}

- (void) populateForOffsetDays
{
    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"STARTANIMATE",@"message", nil];
    _returnCallBack(callbackInfo);
    NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%d",_currOffset], @"p_offsetday", nil];
    METHODCALLBACK l_proxyReturn = ^(NSDictionary* p_dictInfo)
    {
        [self soCoreDataGenerated:p_dictInfo];
    };
    [[ssWSProxy alloc] initWithReportType:@"SALESORDERLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
}

- (void) populateForOffsetDays:(int) p_shift
{
    if (p_shift>0) 
        _currOffset++;
    
    if (p_shift<0) 
        _currOffset--;
    
    if (_currOffset<0) _currOffset=0;
    
    [self populateForOffsetDays];
}

- (void) soCoreDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) {
        [dataForDisplay removeAllObjects];
        dataForDisplay = nil;
    }
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    [self reloadData];
    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"STOPANIMATE",@"message", [NSString stringWithFormat:@"%d", _currOffset], @"offset", nil];
    _returnCallBack(callbackInfo);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataForDisplay count]> 5) 
        return [dataForDisplay count];
    else
        return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat l_retval;
    l_retval = 62.0f;
    return  l_retval;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= [dataForDisplay count] -1) 
    {
        NSDictionary* sodata =(NSDictionary*) [dataForDisplay objectAtIndex:indexPath.row];
        NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"SOVIEW",@"message", [sodata valueForKey:@"SOID"], @"soid", nil];
        NSLog(@"the selected item info %@", callbackInfo);
        if ([sodata valueForKey:@"SOID"]) 
            _returnCallBack(callbackInfo);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"CellDetail";
    UILabel *mainTitlelbl, *detailTitleLbl,*enqModelabel;
    int xStart, xWidth, l_importance;
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    double totalAmount;
    NSString *mainTitle, *detailTitle, *stAmount;
    NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
    [frm setCurrencySymbol:@""];
    [frm setMaximumFractionDigits:2];
    int indexrow = indexPath.row;
    int arrayCount = [dataForDisplay count] -1;
    CGRect mainFrame, detailFrame, enqFrame;
    NSDictionary* soData ;
    if (indexrow > arrayCount) 
        soData = nil;
    else
        soData = (NSDictionary*) [dataForDisplay objectAtIndex:indexPath.row];
    xStart = 1;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        xWidth = 120;
    else
        xWidth = 156;
    mainFrame = CGRectMake(xStart,1, xWidth, 60);
    xStart += xWidth + 2;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        xWidth = 432;
    else
        xWidth = 566;
    detailFrame = CGRectMake(xStart,1, xWidth, 60);
    xStart += xWidth + 2;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        xWidth = 135;
    else
        xWidth = 178;
    enqFrame = CGRectMake(xStart, 1, xWidth, 60);
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
        mainTitlelbl = [[UILabel alloc]initWithFrame:mainFrame];
        mainTitlelbl.lineBreakMode = UILineBreakModeWordWrap;
        mainTitlelbl.backgroundColor = [UIColor whiteColor];
        mainTitlelbl.textColor = [UIColor blueColor];
        mainTitlelbl.numberOfLines = 2;
        mainTitlelbl.tag = 101;
        [cell.contentView addSubview:mainTitlelbl];
        detailTitleLbl = [[UILabel alloc]initWithFrame:detailFrame];
        detailTitleLbl.lineBreakMode = UILineBreakModeWordWrap;
        detailTitleLbl.backgroundColor = [UIColor whiteColor];
        detailTitleLbl.textColor = [UIColor blueColor];
        detailTitleLbl.numberOfLines = 2;
        detailTitleLbl.tag = 102;
        [cell.contentView addSubview:detailTitleLbl];
        enqModelabel=[[UILabel alloc]initWithFrame:enqFrame];
        enqModelabel.textColor = [UIColor blueColor];
        enqModelabel.font = [UIFont boldSystemFontOfSize:20.0f];
        enqModelabel.textAlignment=UITextAlignmentRight;
        enqModelabel.numberOfLines = 2;
        enqModelabel.tag = 103;
        enqModelabel.textAlignment=UITextAlignmentRight;
        [cell.contentView addSubview:enqModelabel];
    }
    mainTitlelbl = (UILabel*) [cell.contentView viewWithTag:101];
    detailTitleLbl = (UILabel*) [cell.contentView viewWithTag:102];
    enqModelabel = (UILabel*) [cell.contentView viewWithTag:103];
    [mainTitlelbl setFrame:mainFrame];
    [detailTitleLbl setFrame:detailFrame];
    [enqModelabel setFrame:enqFrame];
    if (soData) 
    {
        mainTitle = [[NSString stringWithFormat:@" %@\n %@", [soData valueForKey:@"DIVCODE"], [soData valueForKey:@"SONO"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        detailTitle  = [[NSString stringWithFormat:@" %@ - %@\n Ref : %@ / %@  Dlvry. Dt: %@", [soData valueForKey:@"CUSTOMERCODE"], [soData valueForKey:@"CUSTOMERNAME"],[soData valueForKey:@"CUSTREFNO"],[soData valueForKey:@"CUSTREFDATE"], [soData valueForKey:@"DELIVERYDATE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        totalAmount = [[soData valueForKey:@"TOTALAMOUNT"] doubleValue];
        stAmount =[[[NSString alloc]initWithFormat:@"%@   ",[frm stringFromNumber:[NSNumber numberWithDouble:totalAmount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        l_importance  = [[soData valueForKey:@"IMPORTANCE"] intValue];
        if (l_importance==0) 
            enqModelabel.backgroundColor = [UIColor greenColor];
        else
            enqModelabel.backgroundColor = [UIColor redColor];
    }
    else
    {
        mainTitle = @"";
        detailTitle = @"";
        stAmount = @"";
        l_importance = 0;
        enqModelabel.backgroundColor = [UIColor whiteColor];
    }
    mainTitlelbl.text = mainTitle;
    detailTitleLbl.text = detailTitle;
    enqModelabel.text=stAmount;
    return cell;
}

- (NSString*) getTitleForDisplay
{
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    NSTimeInterval secondsforNdays = - 24 * 60 * 60 * _currOffset;
    [nsdf setDateFormat:@"d-MMM-yyyy"];
    NSDate *l_fordate = [NSDate date];
    l_fordate = [l_fordate dateByAddingTimeInterval:secondsforNdays];
    if (_currOffset==0) 
        return @"List of Sales Orders for Today :   ";
    else
        return [[NSString alloc] initWithFormat:@"List of Sales Orders for %@ :   ",[nsdf stringFromDate:l_fordate]]; 
}


@end
