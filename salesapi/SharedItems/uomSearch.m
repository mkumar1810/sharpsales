//
//  uomSearch.m
//  salesapi
//
//  Created by Imac on 5/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "uomSearch.h"


@implementation uomSearch

- (id)initWithFrame:(CGRect)frame andUOMList:(NSString*) p_uomlist andCallbackMethod:(METHODCALLBACK) p_callback
{
    self = [super initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if (self) {
        _uomlist= p_uomlist;
        //NSLog(@"received uom list is %@", _uomlist);
        _callbackMethod = p_callback;
        [self setFrame:frame];
        [self setBackgroundView:nil];
        [self setBackgroundView:[[UIView alloc] init]];
        [self setBackgroundColor:UIColor.clearColor];
        [self setDataSource:self];
        [self setDelegate:self];
        // Initialization code
        [self generateData];
    }
    return self;
}

- (void) generateData
{
    _dataforDisplay = [_uomlist componentsSeparatedByString: @","];
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataforDisplay count] - 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  35.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"UOMSET",@"message",[_dataforDisplay objectAtIndex:indexPath.row], @"data", nil];
    _callbackMethod(callbackInfo);    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"CellUOM";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSString *uomval = [_dataforDisplay objectAtIndex:indexPath.row];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
    }
    cell.textLabel.text = uomval;
    return cell;
}

@end
