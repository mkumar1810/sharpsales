//
//  salesorderList.m
//  salesapi
//
//  Created by Imac on 4/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "salesOrderList.h"


@implementation salesOrderList

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"salesOrderList" forFrame:frame];
        intOrientation = p_intOrientation;
        _offsetday = 0;
        //[[NSNotificationCenter defaultCenter] removeObserver:self];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(salesOrderCoreDataGenerated:)  name:@"salesorderListGenerated" object:nil];
        __block id myself = self;
        _soModifyComplete = ^(NSDictionary* p_dictInfo)
        {
            [myself salesOrderEntryAddedModified:p_dictInfo];
        };
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(salesOrderEntryAddedModified:) name:@"salesorderEntryModified" object:nil];
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
        /*if (colnRC) [colnRC release];
        NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%d",_offsetday], @"p_offsetday", nil];
        colnRC = [[SSWSCallsCore alloc] initWithReportType:@"SALESORDERLIST" andInputParams:inputDict andNotificatioName:@"salesorderListGenerated"];*/
        /*if (ssWSCorecall) 
            [ssWSCorecall release];*/
        NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%d",_offsetday], @"p_offsetday", nil];
        METHODCALLBACK l_proxyReturn = ^(NSDictionary* p_dictInfo)
        {
            [self salesOrderCoreDataGenerated:p_dictInfo];
        };
        [[ssWSProxy alloc] initWithReportType:@"SALESORDERLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
        
        [self setTitleForDisplay];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    intOrientation = p_forOrientation;
    if (sode) 
        [sode setForOrientation:p_forOrientation];
    else
        [super setForOrientation:p_forOrientation]; 
}


- (void) salesOrderCoreDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) {
        [dataForDisplay removeAllObjects];
        //[dataForDisplay release];
    }
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    //NSLog(@"received so list data %@",dataForDisplay);
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    NSDictionary *sodata = (NSDictionary*) [dataForDisplay objectAtIndex:indexPath.row];
    sode = [[salesOrderDataEntry alloc] initWithFrame:self.frame forOrientation:intOrientation andSOModifiedMethod:_soModifyComplete];
    [sode setEntrymode:@"L" andEntryId:[sodata valueForKey:@"SOID"]];
    [self addSubview:sode];
    
    /*NSDictionary* colndata =(NSDictionary*) [dataForDisplay objectAtIndex:indexPath.row];
    cde = [[colnDataEntry alloc] initWithFrame:self.frame forOrientation:intOrientation];
    [cde setEntrymode:@"L" andEntryId:[colndata valueForKey:@"COLLECTIONID"]];
    [self addSubview:cde];*/
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UILabel *mainTitlelbl, *detailTitleLbl,*enqModelabel;
    int xStart, xWidth;
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    double totalAmount;
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
    NSString *mainTitle = [[NSString stringWithFormat:@" %@\n %@", [colndata valueForKey:@"DIVCODE"], [colndata valueForKey:@"SONO"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    NSString *detailTitle = [[NSString stringWithFormat:@" %@ - %@\n Ref : %@ / %@  Dlvry. Dt: %@", [colndata valueForKey:@"CUSTOMERCODE"], [colndata valueForKey:@"CUSTOMERNAME"],[colndata valueForKey:@"CUSTREFNO"],[colndata valueForKey:@"CUSTREFDATE"], [colndata valueForKey:@"DELIVERYDATE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
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
    enqModelabel=[[UILabel alloc]initWithFrame:CGRectMake(xStart, 1, xWidth, 60)];
    enqModelabel.textColor = [UIColor blueColor];
    enqModelabel.font = [UIFont boldSystemFontOfSize:20.0f];
    enqModelabel.textAlignment=UITextAlignmentRight;
    totalAmount = [[colndata valueForKey:@"TOTALAMOUNT"] doubleValue];
    NSString *st =[[[NSString alloc]initWithFormat:@"%@   ",[frm stringFromNumber:[NSNumber numberWithDouble:totalAmount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
   // =[[[NSString alloc]initWithFormat:@" %@\n %@",[colndata valueForKey:@"ENQMODE"],[colndata valueForKey:@"DIVCODE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    enqModelabel.text=st;
    enqModelabel.numberOfLines = 2;
    int l_importance = [[colndata valueForKey:@"IMPORTANCE"] intValue];
    if (l_importance==0) 
        enqModelabel.backgroundColor = [UIColor greenColor];
    else
        enqModelabel.backgroundColor = [UIColor redColor];
    enqModelabel.textAlignment=UITextAlignmentRight;
    [cell.contentView addSubview:enqModelabel];
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
    sode = [[salesOrderDataEntry alloc] initWithFrame:self.frame forOrientation:intOrientation andSOModifiedMethod:_soModifyComplete];
    [sode setEntrymode:@"A" andEntryId:@"0"];
    [self addSubview:sode];
}

- (void) salesOrderEntryAddedModified:(NSDictionary *)salesorderInfo
{
    NSString *modeReceived = [NSString stringWithFormat:@"%@",[salesorderInfo valueForKey:@"opmode"]];
    [sode removeFromSuperview];
    //[sode release];
    sode = nil;
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
        lblSalesOrderTitle.text = @"List of sales Orders done for Today :   ";
    else
        lblSalesOrderTitle.text = [[NSString alloc] initWithFormat:@"List of sales Orders done for %@ :   ",[nsdf stringFromDate:l_fordate]]; 
}


@end
