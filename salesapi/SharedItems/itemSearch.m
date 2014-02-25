//
//  itemSearch.m
//  salesapi
//
//  Created by Imac on 5/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "itemSearch.h"


@implementation itemSearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andCustCode:(NSString*) p_custcode
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"getSearch" forFrame:frame];
        intOrientation = p_intOrientation;
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemListDataGenerated:)  name:@"soItemListGenerated" object:nil];
        _itemReturnMethod = p_returnMethod;
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = NO;
        _custcode = [[NSString alloc] initWithFormat:@"%@",p_custcode];
        [navTitle setTitle:@"Select Item"];
        [self generateData];
    }
    return self;
}

- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sBar.text, @"p_searchtext", _custcode ,@"p_custcode" ,nil];
        METHODCALLBACK l_proxyReturn = ^(NSDictionary* p_dictInfo)
        {
            [self itemListDataGenerated:p_dictInfo];
        };
        if (refreshTag==1) 
        {
            [inputDict setValue:@"" forKey:@"p_searchtext"];
            /*if (colnRC) [colnRC release];
            colnRC = [[SSWSCallsCore alloc] initWithReportType:@"SOITEMSLIST" andInputParams:inputDict andNotificatioName:@"soItemListGenerated"];*/
            /*if (ssWSCorecall) 
                [ssWSCorecall release];*/
            [[ssWSProxy alloc] initWithReportType:@"SOITEMSLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
            
        }
        else
        {
            if ([sBar.text isEqualToString:@""]) 
            {
                [inputDict setValue:@"" forKey:@"p_searchtext"];
                /*if (colnRC) [colnRC release];
                colnRC = [[SSWSCallsCore alloc] initWithReportType:@"SOITEMSLIST" andInputParams:inputDict andNotificatioName:@"soItemListGenerated"];*/
                /*if (ssWSCorecall) 
                    [ssWSCorecall release];*/
                [[ssWSProxy alloc] initWithReportType:@"SOITEMSLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
            }
            else
            {
                /*if (colnRC) [colnRC release];
                colnRC = [[SSWSCallsCore alloc] initWithReportType:@"SOITEMSLIST" andInputParams:inputDict andNotificatioName:@"soItemListGenerated"];*/
                /*if (ssWSCorecall) 
                    [ssWSCorecall release];*/
                [[ssWSProxy alloc] initWithReportType:@"SOITEMSLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
            }
        }
        refreshTag = 0;
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [super setForOrientation:p_forOrientation]; 
}


- (void) itemListDataGenerated:(NSDictionary *)generatedInfo
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key;
    if (UIInterfaceOrientationIsPortrait(intOrientation))
        key =  @"     Item Code                       Item Name";
    else
        key =  @"     Item Code                                              Item Name";
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    return key;
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
    return  50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"ITEMSET",@"message",[dataForDisplay objectAtIndex:indexPath.row], @"data", nil];
    _itemReturnMethod(callbackInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblcode, *lbldivider, *lblname;
    NSString *itemcode, *itemname ;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
    }
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    itemcode = [[[NSString alloc] initWithFormat:@"  %@", [tmpDict valueForKey:@"CD"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"]; 
    itemname = [[[NSString alloc] initWithFormat:@"  %@", [tmpDict valueForKey:@"CN"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lblcode = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
    lblcode.font = [UIFont systemFontOfSize:18.0f];
    lblcode.text = itemcode;
    [lblcode setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:lblcode];
    //[lblcode release];
    
    lbldivider = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth+4, 0, 2, labelHeight)];
    [lbldivider setBackgroundColor:[UIColor grayColor]];
    [cell.contentView addSubview:lbldivider];
    //[lbldivider release];
    
    lblname = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth+6, 1, dataEntryWidth, labelHeight-2)];
    lblname.font = [UIFont systemFontOfSize:18.0f];
    lblname.text = itemname;
    [lblname setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:lblname];
    //[lblname release];
    return cell;
}

- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    [dispTV removeFromSuperview];
    refreshTag = 1;
    [self generateData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [super searchBarTextDidBeginEditing:searchBar];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [super searchBarTextDidEndEditing:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
}

// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarSearchButtonClicked:searchBar];
    [self generateData];
}

- (IBAction) goBack:(id) sender
{
    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"ITEMSET",@"message",nil, @"data", nil];
    _itemReturnMethod(callbackInfo);
}

- (void)dealloc
{
    //[super dealloc];
}

@end
