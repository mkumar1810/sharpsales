//
//  salesOrderDetailObjects.m
//  salesapi
//
//  Created by Imac on 5/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "salesOrderDetailObjects.h"


@implementation salesOrderDetailObjects
static bool shouldScroll = true;

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode andItemMethod:(METHODCALLBACK) p_ItemMethod andUOMMethod:(METHODCALLBACK) p_uomMethod
{
    self = [super init];
    if (self) {
        initialFrame = frame;
        _parentScroll = p_scrollview;
        _itemReturnMethod = p_ItemMethod;
        _uomReturnMethod = p_uomMethod;
        intOrientation = p_intOrientation;
        _dispMode = [[NSString alloc] initWithFormat:@"%@", p_dispmode];
        _initialData = [[NSDictionary alloc] initWithDictionary:p_dictData];
        if ([_initialData valueForKey:@"SODETAILID"]==nil) 
            _detailEntryId = [[NSString alloc] initWithFormat:@"%@",@""];
        else
            _detailEntryId = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"SODETAILID"]];
        [self displayDictDataForMode:p_dispmode];
        [self setForOrientation:p_intOrientation];
    }
    return self;
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    intOrientation = p_forOrientation;
    [self generateTableView];
}


- (void) generateTableView
{
    //return;
    if (entryTV) {
        [self storeDispValues];
        [entryTV removeFromSuperview];
        //[entryTV release];
    }
    CGRect tvrect;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        tvrect = CGRectMake(0, 50, 768, 768);
    else
        tvrect = CGRectMake(0, 20, 1004, 600);
    entryTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStyleGrouped];
    [entryTV setDelegate:self];
    [entryTV setDataSource:self];
    [entryTV setBackgroundView:nil];
    [entryTV setBackgroundView:[[UIView alloc] init] ];
    [entryTV setBackgroundColor:UIColor.clearColor];
    [_parentScroll addSubview:entryTV];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
    //[super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int l_retval;
    switch (section) {
        case 0:
            l_retval = 2;
            break;
        default:
            l_retval = 1;
            break;
    }
    return l_retval;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float l_retval;
    switch (indexPath.section) {
        case 0:
            l_retval = 50.0f;
            break;
        default:
            l_retval = 50.0f;
            break;
    }
    return  l_retval;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) 
        if (indexPath.row==0) 
            //[[NSNotifxicationCenter defaultCenter] postNotifxicationName:@"selectItemForSODetail" object:self];
            _itemReturnMethod(nil);
    
    if (indexPath.section==1) 
    {
        NSMutableDictionary *uomlist_dict = [[NSMutableDictionary alloc] init];
        [uomlist_dict setValue:_uomlist forKey:@"uomlist"];
        if (indexPath.row==0) 
        {
            switch (_noofUOMs) {
                case 0:
                    [self showAlertMessage:@"Select a valid item first"];
                    break;
                case 1:
                    break;
                default:
                    //[[NSNotificaxtionCenter defaultCenter] postNotxificationName:@"selectUOMForSODetail" object:self userInfo:uomlist_dict];
                    _uomReturnMethod(uomlist_dict);
                    break;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int l_retval;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        l_retval = 15;
    else
        l_retval = 15;
    return l_retval;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
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
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Item Code"];
                    
                    txtItemCode = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
                    if (itemCode) 
                        txtItemCode.text = itemCode;
                    else
                        txtItemCode.text = @"";
                    txtItemCode.enabled = NO;
                    txtItemCode.delegate = self;
                    txtItemCode.placeholder = @"(Select Item....)";
                    txtItemCode.font =reqfont;
                    txtItemCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    if ([_dispMode isEqualToString:@"L"]) 
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    else
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:txtItemCode];
                    break;
                case 1:
                    lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Item Name"];
                    
                    txtItemName = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
                    if (itemName) 
                        txtItemName.text = itemName;
                    else
                        txtItemName.text = @"";
                    txtItemName.enabled = NO;
                    txtItemName.delegate = self;
                    txtItemName.font =reqfont;
                    txtItemName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [cell.contentView addSubview:txtItemName];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"UOM"];
            txtUOM = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
            if (uomVal) 
                txtUOM.text = uomVal;
            else
                txtUOM.text = @"";
            txtUOM.enabled = NO;
            txtUOM.delegate = self;
            txtUOM.placeholder = @"(Select UOM....)";
            txtUOM.font =reqfont;
            txtUOM.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            if ([_dispMode isEqualToString:@"L"]) 
                cell.accessoryType = UITableViewCellAccessoryNone;
            else
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:txtUOM];
            break;
        case 2:
            lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Qty"];
            txtQty = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
            if (qty) 
                txtQty.text = qty;
            else
                txtQty.text = @"";
            txtQty.enabled = YES;
            txtQty.delegate = self;
            txtQty.placeholder = @"Enter the quantity";
            txtQty.font =reqfont;
            [txtQty setKeyboardType:UIKeyboardTypeNumberPad];
            txtQty.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:txtQty];
            break;
        case 3:
            lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Rate"];
            txtRate = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
            if (rate) 
                txtRate.text = rate;
            else
                txtRate.text = @"";
            txtRate.enabled = YES;
            txtRate.delegate = self;
            txtRate.placeholder = @"Enter the rate";
            txtRate.font =reqfont;
            [txtRate setKeyboardType:UIKeyboardTypeNumberPad];
            txtRate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:txtRate];
            break;
        case 4:
            lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Notes"];
            txtNotes = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
            if (notes) 
                txtNotes.text = notes;
            else
                txtNotes.text = @"";
            txtNotes.enabled = YES;
            txtNotes.delegate = self;
            txtNotes.placeholder = @"Enter the notes";
            txtNotes.font =reqfont;
            txtNotes.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:txtNotes];
            break;
        default:
            break;
    }
    lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
    lbltitle.numberOfLines = 2;
    lbltitle.font = [UIFont systemFontOfSize:18.0f];
    lbltitle.text = lblcaption;
    [lbltitle setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:lbltitle];
    //[lbltitle release];
    if (dividerNeeded==YES) 
    {
        lbldivider = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth+4, 0, 2, labelHeight)];
        [lbldivider setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider];
        //[lbldivider release];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *key;
    key =  [[NSString alloc] initWithString:@"   "];
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    return key;
}
*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    shouldScroll = true;
    [_parentScroll setContentOffset:scrollOffset animated:NO]; 
     if ([textField isEqual:txtQty]) 
     [txtRate becomeFirstResponder];
     else if([textField isEqual:txtRate])
     [txtNotes becomeFirstResponder];
     else if ([textField isEqual:txtNotes])
     [txtNotes resignFirstResponder];

	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (shouldScroll) {
        scrollOffset = _parentScroll.contentOffset;
        shouldScroll = false;
    }
}

- (void) storeDispValues
{
    if (txtItemCode) 
        itemCode = [[NSString alloc] initWithFormat:@"%@", txtItemCode.text];
    if (txtItemName) 
        itemName = [[NSString alloc] initWithFormat:@"%@", txtItemName.text];
    
    if (txtUOM) 
        uomVal = [[NSString alloc] initWithFormat:@"%@", txtUOM.text];
    
    if (txtQty) 
        qty = [[NSString alloc] initWithFormat:@"%@", txtQty.text];
    
    if (txtRate) 
        rate = [[NSString alloc] initWithFormat:@"%@", txtRate.text];
    
    if (txtNotes) 
        notes = [[NSString alloc] initWithFormat:@"%@", txtNotes.text];
    
}

- (void) setItemValues:(NSDictionary*) itemInfo
{
    if (itemInfo) {
        if (txtItemCode) 
        {
            itemCode = [[NSString alloc] initWithFormat:@"%@", [itemInfo valueForKey:@"CD"]];
            itemName = [[NSString alloc] initWithFormat:@"%@", [itemInfo valueForKey:@"CN"]];
            txtItemCode.text = [[NSString alloc] initWithFormat:@"%@", [itemInfo valueForKey:@"CD"]];
            txtItemName.text = [[NSString alloc] initWithFormat:@"%@", [itemInfo valueForKey:@"CN"]];
            _uomlist = [[NSString alloc] initWithFormat:@"%@",[itemInfo valueForKey:@"UOMLIST"]];
            _noofUOMs = [[itemInfo valueForKey:@"NOOFUOMS"] intValue];
            _uomdesc = [[NSString alloc] initWithFormat:@"%@",[itemInfo valueForKey:@"UOMDESC"]];
            uomCode = [[NSString alloc] initWithFormat:@"%@", [itemInfo valueForKey:@"UOM"]];
            uomVal = [[NSString alloc] initWithFormat:@"%@ - %@", [itemInfo valueForKey:@"UOM"], [itemInfo valueForKey:@"UOMDESC"]];
            txtUOM.text = uomVal;
        }
        else
        {
            itemCode = [[NSString alloc] initWithFormat:@"%@",""];
            itemName = [[NSString alloc] initWithFormat:@"%@",""];
            _uomlist = [[NSString alloc] initWithFormat:@"%@",""];
            _noofUOMs =0;
            _uomdesc = [[NSString alloc] initWithFormat:@"%@",""];
            uomCode = [[NSString alloc] initWithFormat:@"%@",""];
            uomVal = [[NSString alloc] initWithFormat:@"%@",""];
        }
    }
}

- (void) setUOMValues:(NSDictionary*) uomInfo
{
    if (uomInfo) {
        if (txtUOM) 
        {
            uomCode = [[NSString alloc] initWithFormat:@"%@", [uomInfo valueForKey:@"UOMCODE"]];
            uomVal = [[NSString alloc] initWithFormat:@"%@ - %@", [uomInfo valueForKey:@"UOMCODE"], [uomInfo valueForKey:@"UOMDESC"]];
            txtUOM.text = uomVal;
        }
        else
            uomCode = [[NSString alloc] initWithFormat:@"%@",""];
    }
}


- (NSDictionary*) getEnteredDetails
{
    [self storeDispValues];
    NSDictionary *entDetails = [[NSDictionary alloc] initWithObjectsAndKeys:_detailEntryId, @"SODETAILID", itemCode,@"ITEMCODE",itemName,@"ITEMNAME",qty,@"QTY",rate,@"RATE",notes,@"DETAILNOTES",_uomlist, @"UOMLIST",[NSString stringWithFormat:@"%d",_noofUOMs],@"NOOFUOMS",uomCode,@"UOMCODE", _uomdesc,@"UOMDESC", nil];
    return entDetails;
}

- (void) displayDictDataForMode:(NSString*) p_dispmode
{
    _dispMode = [[NSString alloc] initWithFormat:@"%@", p_dispmode];
    if ([p_dispmode isEqualToString:@"L"] | [p_dispmode isEqualToString:@"E"]) 
    {
        itemCode = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"ITEMCODE"]];
        itemName = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"ITEMNAME"]];
        uomCode = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"UOMCODE"]];
        qty = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"QTY"]];
        rate = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"RATE"]];
        //notes = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"NOTES"]];
        if ([_initialData valueForKey:@"DETAILNOTES"]) 
            notes = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"DETAILNOTES"]];
        else
            notes = [[NSString alloc] initWithFormat:@"%@",@""];
        _uomlist = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"UOMLIST"]];
        //NSLog(@"uom list %@", _uomlist);
        _uomdesc = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"UOMDESC"]];
        uomVal = [[NSString alloc] initWithFormat:@"%@ - %@", [_initialData valueForKey:@"UOMCODE"], [_initialData valueForKey:@"UOMDESC"]];
    }
}

- (NSDictionary*) validateData
{
    NSDictionary *returnDict;
    if ([txtItemCode.text isEqualToString:@""]) 
    {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Please Select a valid Item",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    if ([txtUOM.text isEqualToString:@""]) 
    {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Enter a valid UOM",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    if ([txtQty.text isEqualToString:@""]) 
    {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Enter a valid quantity",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    if ([txtRate.text isEqualToString:@""]) 
    {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Enter a valid rate",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"RESPONSECODE",@"Successfully Validated",@"RESPONSEMESSAGE"  , nil];
    return returnDict;
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    if ([string isEqualToString:@"."]==YES) 
        return YES;
    
    if ([textField isEqual:txtQty] | [textField isEqual:txtRate]) 
        return [self isNumericValue:string];
    else
        return YES;
    
    
}
 
- (BOOL) isNumericValue:(NSString*) p_passedval
{
    BOOL l_returnval = NO;
    NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *recdStrSet = [NSCharacterSet characterSetWithCharactersInString:p_passedval];
    l_returnval = [decimalSet isSupersetOfSet:recdStrSet];
    return l_returnval;
    
}

- (void) setEditMode
{
    _dispMode = @"E";
    [self generateTableView];
}

 
 - (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}

@end
