//
//  divSelect.m
//  salesapi
//
//  Created by Imac on 5/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "divSelect.h"


@implementation divSelect

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"getSearch" forFrame:frame];
        intOrientation = p_intOrientation;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(divListDataGenerated:)  name:@"divListGenerated" object:nil];
        [actIndicator startAnimating];
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        _returnMethod = p_returnMethod;
        sBar.text = @"";
        sBar.hidden = YES;
        [navTitle setTitle:@"Select Division"];
        [self generateData];
    }
    return self;
}

- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        METHODCALLBACK l_proxyReturn = ^(NSDictionary* p_dictInfo)
        {
            [self divListDataGenerated:p_dictInfo];
        };
        NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys: nil];
        if (refreshTag==1) 
        {
            /*if (colnRC) [colnRC release];
            colnRC = [[SSWSCallsCore alloc] initWithReportType:@"DIVLIST" andInputParams:inputDict andNotificatioName:@"divListGenerated"];*/
            /*if (ssWSCorecall) 
                [ssWSCorecall release];*/
            [[ssWSProxy alloc] initWithReportType:@"DIVLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
        }
        else
        {
            NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
            if ([stdDefaults valueForKey:@"ALLDIVISIONS"]==nil) 
            {
                /*if (colnRC) [colnRC release];
                colnRC = [[SSWSCallsCore alloc] initWithReportType:@"DIVLIST" andInputParams:inputDict andNotificatioName:@"divListGenerated"];*/
                /*if (ssWSCorecall) 
                    [ssWSCorecall release];*/
                [[ssWSProxy alloc] initWithReportType:@"DIVLIST" andInputParams:inputDict andReturnMethod:l_proxyReturn];
            }
            else
            {
                NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
                [returnInfo setValue:[stdDefaults valueForKey:@"ALLDIVISIONS"] forKey:@"data"];
                //[[NSNotificxationCenter defaultCenter] postNotificxationName:@"divListGenerated" object:self userInfo:returnInfo];
                l_proxyReturn(returnInfo);
            }
        }
        refreshTag = 0;
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [super setForOrientation:p_forOrientation]; 
}

- (void) divListDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) {
        [dataForDisplay removeAllObjects];
        //[dataForDisplay release];
    }
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    if ([sBar.text isEqualToString:@""]) 
    {
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        [stdDefaults setValue:dataForDisplay forKey:@"ALLDIVISIONS"];
    }         [self setForOrientation:intOrientation];
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
        key =  @"     Division Code                       Division Name";
    else
        key =  @"     Division Code                                              Division Name";
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
    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"DIVSET",@"message",[dataForDisplay objectAtIndex:indexPath.row], @"data", nil];
    _returnMethod(callbackInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblcode, *lbldivider, *lblname;
    NSString *custcode, *custname ;
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
    //NSLog(@"values in temp dictionary %@", tmpDict);
    
    custcode = [[[NSString alloc] initWithFormat:@"  %@", [tmpDict valueForKey:@"DIVCODE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"]; 
    custname = [[[NSString alloc] initWithFormat:@"  %@", [tmpDict valueForKey:@"DIVDESC"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lblcode = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
    lblcode.font = [UIFont systemFontOfSize:18.0f];
    lblcode.text = custcode;
    [lblcode setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:lblcode];
    //[lblcode release];
    
    lbldivider = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth+4, 0, 2, labelHeight)];
    [lbldivider setBackgroundColor:[UIColor grayColor]];
    [cell.contentView addSubview:lbldivider];
    //[lbldivider release];
    
    lblname = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth+6, 1, dataEntryWidth, labelHeight-2)];
    lblname.font = [UIFont systemFontOfSize:18.0f];
    lblname.text = custname;
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
    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"DIVSET",@"message",nil, @"data", nil];
    _returnMethod(callbackInfo);
}

- (void)dealloc
{
    //[super dealloc];
}


@end
