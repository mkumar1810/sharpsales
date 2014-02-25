//
//  collectionsList.m
//  salesapi
//
//  Created by Raja T S Sekhar on 4/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "collectionsList.h"

@implementation collectionsList

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation
{
    self = [super initWithFrame:frame];
    if (self) {
        //[super addNIBView:@"collectionsList" forFrame:frame];
        intOrientation = p_intOrientation;
        _offsetday = 0;
        __block id myself = self;
        _cdeReturnMethod = ^(NSDictionary* p_dictInfo)
        {
            [myself collectionEntryAdded:p_dictInfo];
        };
        _navigationNeeded = YES;
        [actIndicator startAnimating];
        [self generateData];
        [self addPreviousNextButtons];
    }
    return self;
}

- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        /*if (ssWSCorecall) 
            [ssWSCorecall release];*/
        NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%d",_offsetday], @"p_offsetday", nil];
        METHODCALLBACK l_proxyReturn = ^(NSDictionary* p_dictInfo)
        {
            [self colnCoreDataGenerated:p_dictInfo];
        };
        [[ssWSProxy alloc] initWithReportType:@"COLLECTIONSTODAYLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    intOrientation = p_forOrientation;
    if (cde) 
        [cde setForOrientation:p_forOrientation];
    else
        [super setForOrientation:p_forOrientation]; 
}


- (void) colnCoreDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) {
        [dataForDisplay removeAllObjects];
        //[dataForDisplay release];
    }
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    populationOnProgress = NO;
    [self setForOrientation:intOrientation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) generateTableView
{
    [super generateTableView];
    [dispTV setDelegate:self];
    [dispTV setDataSource:self];
    [dispTV reloadData];
}

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //[super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataForDisplay count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat l_retval;
    l_retval = 62.0f;
    return  l_retval;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* colndata =(NSDictionary*) [dataForDisplay objectAtIndex:indexPath.row];
    cde = [[colnDataEntry alloc] initWithFrame:self.frame forOrientation:intOrientation andModifiedReturnMethod:_cdeReturnMethod];
    [cde setEntrymode:@"L" andEntryId:[colndata valueForKey:@"COLLECTIONID"]];
    [self addSubview:cde];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UILabel *mainTitlelbl, *detailTitleLbl,*amtlabel;
    int xStart, xWidth;
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
    [frm setCurrencySymbol:@""];
    [frm setMaximumFractionDigits:2];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    NSDictionary* colndata =(NSDictionary*) [dataForDisplay objectAtIndex:indexPath.row];
    NSString *mainTitle = [[NSString stringWithFormat:@" %@\n %@", [colndata valueForKey:@"CUSTOMERCODE"], [colndata valueForKey:@"RECEIPTNO"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    NSString *detailTitle = [[NSString stringWithFormat:@" %@\n %@", [colndata valueForKey:@"CUSTOMERNAME"],[colndata valueForKey:@"PAYMENTMODE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    xStart = 1;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        xWidth = 120;
    else
        xWidth = 156;
    mainTitlelbl = [[UILabel alloc]initWithFrame:CGRectMake(xStart,1, xWidth, 60)];
    mainTitlelbl.text = mainTitle;
    mainTitlelbl.lineBreakMode = UILineBreakModeWordWrap;
    mainTitlelbl.backgroundColor = [UIColor whiteColor];
    mainTitlelbl.textColor = [UIColor blueColor];
    mainTitlelbl.numberOfLines = 2;
    [cell.contentView addSubview:mainTitlelbl];
    //[mainTitlelbl release];
    xStart += xWidth + 2;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        xWidth = 432;
    else
        xWidth = 566;
    detailTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(xStart,1, xWidth, 60)];
    detailTitleLbl.text = detailTitle;
    detailTitleLbl.lineBreakMode = UILineBreakModeWordWrap;
    detailTitleLbl.backgroundColor = [UIColor whiteColor];
    detailTitleLbl.textColor = [UIColor blueColor];
    detailTitleLbl.numberOfLines = 2;
    [cell.contentView addSubview:detailTitleLbl];
    //[detailTitleLbl release];
    xStart += xWidth + 2;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        xWidth = 135;
    else
        xWidth = 178;
    amtlabel=[[UILabel alloc]initWithFrame:CGRectMake(xStart, 1, xWidth, 60)];
    amtlabel.backgroundColor = [UIColor whiteColor];
    amtlabel.textColor = [UIColor redColor];
    amtlabel.font = [UIFont boldSystemFontOfSize:18.0f];
    amtlabel.textAlignment=UITextAlignmentRight;
    double colnamount  =[[colndata valueForKey:@"AMOUNT"] doubleValue];
    NSString *st=[[[NSString alloc]initWithFormat:@" %@   ",[frm stringFromNumber:[NSNumber numberWithDouble:colnamount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    amtlabel.text=st;
    amtlabel.textAlignment=UITextAlignmentRight;
    [cell.contentView addSubview:amtlabel];
    return cell;
}

- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    [dispTV removeFromSuperview];
    [self generateData];
}

- (IBAction) addItemData:(id) sender
{
    cde = [[colnDataEntry alloc] initWithFrame:self.frame forOrientation:intOrientation andModifiedReturnMethod:_cdeReturnMethod];
    [cde setEntrymode:@"A" andEntryId:@"0"];
    [self addSubview:cde];
}

- (void) collectionEntryAdded:(NSDictionary *)colnInfo
{
    NSString *modeReceived = [NSString stringWithFormat:@"%@",[colnInfo valueForKey:@"opmode"]];
    [cde removeFromSuperview];
    //[cde release];
    cde = nil;
    if ([modeReceived isEqualToString:@"S"]) 
        [self generateData];
    else
        [self setForOrientation:intOrientation];
}

- (IBAction) previousButtonPressed:(id) sender
{
    _offsetday++;
    [self generateData];
    [self setTitleForDisplay];
}

- (IBAction) nextButtonPressed:(id) sender
{
    _offsetday--;
    if (_offsetday<0) _offsetday =0;
    [self generateData];
    [self setTitleForDisplay];
}

- (void) setTitleForDisplay
{
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    NSTimeInterval secondsforNdays = - 24 * 60 * 60 * _offsetday;
    [nsdf setDateFormat:@"d-MMM-yyyy"];
    NSDate *l_fordate = [NSDate date];
    l_fordate = [l_fordate dateByAddingTimeInterval:secondsforNdays];
    if (_offsetday==0) 
        lblCollectionTitle.text = @"List of Collections done from customers for Today :   ";
    else
        lblCollectionTitle.text = [[NSString alloc] initWithFormat:@"List of Collections done from customers for %@ :   ",[nsdf stringFromDate:l_fordate]]; 
}

@end
