//
//  colnListTV.m
//  salesapi
//
//  Created by Macintosh User on 23/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "colnListTV.h"

@implementation colnListTV

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
        [self colnCoreDataGenerated:p_dictInfo];
    };
    [[ssWSProxy alloc] initWithReportType:@"COLLECTIONSTODAYLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
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

- (void) colnCoreDataGenerated:(NSDictionary *)generatedInfo
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
        NSDictionary* colndata =(NSDictionary*) [dataForDisplay objectAtIndex:indexPath.row];
        NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"COLLECTIONVIEW",@"message", [colndata valueForKey:@"COLLECTIONID"], @"collectionid", nil];
        _returnCallBack(callbackInfo);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"CellCollection";
    UILabel *mainTitlelbl, *detailTitleLbl,*amtlabel;
    int xStart, xMainWidth, xDetWidth, xAmtWidth;
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
    [frm setCurrencySymbol:@""];
    [frm setMaximumFractionDigits:2];
    NSDictionary* colndata;
    NSString *mainTitle, *detailTitle, *amtPart;
    CGRect mainFrame, detFrame, amtFrame;
    int indexrow = indexPath.row;
    int arrayCount = [dataForDisplay count] -1;
    //NSLog(@"index row %d  and disp objects count -1 %d", indexPath.row, [dataForDisplay count]-1 );
    if (indexrow > arrayCount) 
        colndata = nil;
    else
         colndata = (NSDictionary*) [dataForDisplay objectAtIndex:indexPath.row];
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        xMainWidth = 120;
    else
        xMainWidth = 156;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        xDetWidth = 432;
    else
        xDetWidth = 566;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        xAmtWidth = 135;
    else
        xAmtWidth = 178;
    xStart = 1;
    mainFrame = CGRectMake(xStart, 1, xMainWidth, 60);
    xStart += xMainWidth + 2;
    detFrame = CGRectMake(xStart, 1, xDetWidth, 60);
    xStart += xDetWidth + 2;
    amtFrame = CGRectMake(xStart, 1, xAmtWidth, 60);
    
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
        detailTitleLbl = [[UILabel alloc]initWithFrame:detFrame];
        detailTitleLbl.lineBreakMode = UILineBreakModeWordWrap;
        detailTitleLbl.backgroundColor = [UIColor whiteColor];
        detailTitleLbl.textColor = [UIColor blueColor];
        detailTitleLbl.numberOfLines = 2;
        detailTitleLbl.tag = 102;
        [cell.contentView addSubview:detailTitleLbl];
        amtlabel=[[UILabel alloc]initWithFrame:amtFrame];
        amtlabel.backgroundColor = [UIColor whiteColor];
        amtlabel.textColor = [UIColor redColor];
        amtlabel.font = [UIFont boldSystemFontOfSize:18.0f];
        amtlabel.textAlignment=UITextAlignmentRight;
        amtlabel.tag = 103;
        [cell.contentView addSubview:amtlabel];
    }
    mainTitlelbl = (UILabel*) [cell.contentView viewWithTag:101];
    detailTitleLbl = (UILabel*) [cell.contentView viewWithTag:102];
    amtlabel = (UILabel*) [cell.contentView viewWithTag:103];
    if (colndata) {
        mainTitle = [[NSString stringWithFormat:@" %@\n %@", [colndata valueForKey:@"CUSTOMERCODE"], [colndata valueForKey:@"RECEIPTNO"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        detailTitle = [[NSString stringWithFormat:@" %@\n %@", [colndata valueForKey:@"CUSTOMERNAME"],[colndata valueForKey:@"PAYMENTMODE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        double colnamount  =[[colndata valueForKey:@"AMOUNT"] doubleValue];
        amtPart =[[[NSString alloc]initWithFormat:@" %@   ",[frm stringFromNumber:[NSNumber numberWithDouble:colnamount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    }
    else
    {
        mainTitle = @"";
        detailTitle = @"";
        amtPart =@"";
    }
    [mainTitlelbl setFrame:mainFrame];
    [detailTitleLbl setFrame:detFrame];
    [amtlabel setFrame:amtFrame];
    mainTitlelbl.text = mainTitle;
    detailTitleLbl.text = detailTitle;
    amtlabel.text=amtPart;
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
        return @"List of Collections done from customers for Today :   ";
    else
        return [[NSString alloc] initWithFormat:@"List of Collections done from customers for %@ :   ",[nsdf stringFromDate:l_fordate]]; 
}


@end
