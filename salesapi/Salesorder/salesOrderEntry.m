//
//  salesOrderEntry.m
//  salesapi
//
//  Created by Macintosh User on 29/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "salesOrderEntry.h"

@implementation salesOrderEntry

static bool shouldScroll = true;

- (id)initWithOrientation:(UIInterfaceOrientation) p_intOrientation andCallBack:(METHODCALLBACK) p_callback andBackGround:(UIColor*) p_color
{
    self = [super initWithFrame:CGRectMake(0, 44, 1024, 1004)];
    if (self) 
    {
        [self setBackgroundColor:p_color];
        _dataentryMode = @"A";
        _soid = @"0";
        _intOrientation = p_intOrientation;
        _returnCallBack = p_callback;
        _viewImages = NO;
        detailData = [[NSMutableArray alloc] init];
        frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];
        [self generateTableView];
        // Initialization code
    }
    return self;
}

- (void) generateTableView
{
    entryTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [entryTV setFrame:[self getFrameForOrientation:_intOrientation]];
    [entryTV setBackgroundView:nil];
    [entryTV setBackgroundView:[[UIView alloc] init]];
    [entryTV setBackgroundColor:UIColor.clearColor];
    [entryTV setDataSource:self];
    [entryTV setDelegate:self];
    
    [self setContentOffset:CGPointMake(0, 44)];
    [self addSubview:entryTV];
}

- (CGRect) getFrameForOrientation:(UIInterfaceOrientation) p_intOrientation
{
    if UIInterfaceOrientationIsPortrait(p_intOrientation)
        return CGRectMake(0, 80, 768, 830);
    else
        return CGRectMake(0, 80, 1024, 570);
}

- (void) setForOrientation:(UIInterfaceOrientation)p_forOrientation
{
    _intOrientation = p_forOrientation;
    [entryTV setFrame:[self getFrameForOrientation:_intOrientation]];
    [entryTV reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noofRows;
    switch (section) {
        case 0:
            noofRows = 4;
            break;
        case 1:
            noofRows = 4;
            break;
        case 2:
            noofRows = [detailData count] + 1;
            break;
        case 3:
            noofRows = 1;
            break;
        case 4:
            if (_viewImages) 
                noofRows = 2;
            else
                noofRows = 1;
            break;
        default:
            noofRows = 0;
            break;
    }
    return noofRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat l_retval;
    NSDictionary *detData;
    l_retval = 50.0f;
    if (indexPath.section==2) 
    {
        switch (indexPath.row) {
            case 0:
                l_retval = 50.0f;
                break;
            default:
                detData = [detailData objectAtIndex:indexPath.row-1];
                if ([detData valueForKey:@"datamode"]) 
                {
                    if ([[detData valueForKey:@"datamode"] isEqualToString:@"A"]) 
                        l_retval = 135.0f;
                    else
                        l_retval = 90.0f;
                }
                else
                    l_retval = 90.0f;
                break;
        }
    }
    if (indexPath.section==4) 
    {
        if (_viewImages) 
            l_retval = 90.0f;
    }
    
    return  l_retval;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataentryMode isEqualToString:@"L"]==NO) 
    {
        if ([detailData count]==0) 
        {
            if (indexPath.section==0) 
                if (indexPath.row==1)
                { 
                    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"CUSTOMERSELECT",@"message", nil];
                    _returnCallBack(callbackInfo);
                }
            
            if (indexPath.section==0) 
                if (indexPath.row==2) 
                {
                    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"DIVSELECT",@"message", nil];
                    _returnCallBack(callbackInfo);
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
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        l_retval = 30;
    else
        l_retval = 15;
    return l_retval;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSDictionary *detData;
    switch (indexPath.section) 
    {
        case 0:
            return [self getMasterViewCellForSection:indexPath.section andRow:indexPath.row];
            break;
        case 1:
            return [self getMasterViewCellForSection2:indexPath.section andRow:indexPath.row];
            break;
        case 2:
            if (indexPath.row==0) 
                return [self getDetailViewCellForSection:indexPath.section andRow:indexPath.row];
            detData = [detailData objectAtIndex:indexPath.row-1];
            if ([detData valueForKey:@"datamode"]) 
            {
                if ([[detData valueForKey:@"datamode"] isEqualToString:@"A"]) 
                    return [self getCellToAddUpdDetail:entryTV forMode:@"A" ofItem:0];
                
                if ([[detData valueForKey:@"datamode"] isEqualToString:@"E"]) 
                    return [self getCellToAddUpdDetail:entryTV forMode:@"E" ofItem:indexPath.row];

                return [self getDetailViewCellForSection:indexPath.section andRow:indexPath.row];
            }
            else
                return [self getDetailViewCellForSection:indexPath.section andRow:indexPath.row];
            
            break;
        case 3:
            return [self getTotAmountViewCellForSection:indexPath.section andRow:indexPath.row];
            break;
        case 4:
            if (_viewImages) 
            {
                switch (indexPath.row) {
                    case 0:
                        return [self getSMSignatureCellFor:tableView];
                        break;
                    case 1:
                        return [self getGivenSignatureCellFor:tableView];
                        break;
                    default:
                        break;
                }
            }
            else
                return [self getImagesEnableButtonCell:tableView];
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell*) getImagesEnableButtonCell:(UITableView*) p_tv
{
    static NSString *cellid=@"CellImagesHeader";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UIButton *btnshow;
    CGRect reqFrame;
    int btnshowXPos;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        btnshowXPos = 625;
    else
        btnshowXPos = 860;
    reqFrame = CGRectMake(btnshowXPos, 0, 50, 50);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor clearColor];
        btnshow = [[UIButton alloc] initWithFrame:reqFrame];
        btnshow.titleLabel.text=@"";
        btnshow.tag = 101;
        btnshow.enabled = YES;
        [btnshow setImage:[UIImage imageNamed:@"addiconnew1.PNG"] forState:UIControlStateNormal];
        [btnshow addTarget:self action:@selector(showSignChequeImages:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnshow];
    }
    btnshow =(UIButton*) [cell.contentView viewWithTag:101];
    [btnshow setFrame:reqFrame];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",@"View Salesman, Customer Signature and Cheque Image"];
    btnshow.enabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*) getGivenSignatureCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellGivenSign";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    NSString *lblcaption ;
    UIButton *btncalender;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 320;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame,titleFrame,btnFrame;
    
    labelHeight = 90;
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 320;
        chequeDataWidth = 323;
    }
    reqFrame = CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight-1);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    titleFrame = CGRectMake(4, 1, labelWidth, labelHeight-2);
    btnFrame = CGRectMake(labelWidth+8+2*chequeDataWidth, 0, 30, labelHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];                    
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Customer Sign"];
        givensignImage = [[UIImageView alloc] initWithFrame:reqFrame];
        givensignImage.tag = 101;
        [cell.contentView addSubview:givensignImage];
        if ([txtsono.text isEqualToString:@""]==NO) 
        {
            //NSURL *urlPath;
            NSArray *sonoarray = [txtsono.text componentsSeparatedByString:@" / "];
            [self setImageFromServer:[sonoarray objectAtIndex:0] forType:@"CU"];
            /*urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/Images/csgn%@.jpeg",MAIN_URL, WS_ENV, [receiptno objectAtIndex:0]]];
             NSLog(@"url path is %@ and txtreceiptno %@", urlPath,txtReceiptNo.text);
             signImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPath]];*/
            
        }
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:titleFrame];
        lbltitle.font = [UIFont systemFontOfSize:18.0f];
        lbltitle.text = lblcaption;
        lbltitle.tag = 103;
        [lbltitle setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle];
        //[lbltitle release];
        if (dividerNeeded==YES) 
        {
            lbldivider = [[UILabel alloc] initWithFrame:dividerFrame];
            [lbldivider setBackgroundColor:[UIColor grayColor]];
            lbldivider.tag = 102;
            [cell.contentView addSubview:lbldivider];
            //[lbldivider release];
        }
        btncalender = [[UIButton alloc] initWithFrame:btnFrame];
        btncalender.titleLabel.text=@"CUSIGN";
        btncalender.tag = 104;
        [btncalender setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalender addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btncalender];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    givensignImage = (UIImageView*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    lbltitle = (UILabel*) [cell.contentView viewWithTag:103];
    btncalender = (UIButton*) [cell.contentView viewWithTag:104];
    [givensignImage setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    [lbltitle setFrame:titleFrame];
    [btncalender setFrame:btnFrame];
    if ([_dataentryMode isEqualToString:@"L"])  
        btncalender.enabled = NO;
    else
        btncalender.enabled = YES;
    return cell;
}

- (UITableViewCell*) getSMSignatureCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellSMSign";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    NSString *lblcaption ;
    UIButton *btncalender;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 320;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame,titleFrame,btnFrame;
    labelHeight = 90;
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 320;
        chequeDataWidth = 323;
    }
    reqFrame = CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight-1);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    titleFrame = CGRectMake(4, 1, labelWidth, labelHeight-2);
    btnFrame = CGRectMake(labelWidth+8+2*chequeDataWidth, 0, 30, labelHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];                    
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Salesman Sign"];
        smsignImage = [[UIImageView alloc] initWithFrame:reqFrame];
        smsignImage.tag = 101;
        [cell.contentView addSubview:smsignImage];
        if ([txtsono.text isEqualToString:@""]==NO) 
        {
            //NSURL *urlPath;
            NSArray *sonoarray = [txtsono.text componentsSeparatedByString:@" / "];
            [self setImageFromServer:[sonoarray objectAtIndex:0] forType:@"SM"];
            /*urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/Images/csgn%@.jpeg",MAIN_URL, WS_ENV, [receiptno objectAtIndex:0]]];
             NSLog(@"url path is %@ and txtreceiptno %@", urlPath,txtReceiptNo.text);
             signImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPath]];*/
            
        }
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:titleFrame];
        lbltitle.font = [UIFont systemFontOfSize:18.0f];
        lbltitle.text = lblcaption;
        lbltitle.tag = 103;
        [lbltitle setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle];
        //[lbltitle release];
        if (dividerNeeded==YES) 
        {
            lbldivider = [[UILabel alloc] initWithFrame:dividerFrame];
            [lbldivider setBackgroundColor:[UIColor grayColor]];
            lbldivider.tag = 102;
            [cell.contentView addSubview:lbldivider];
            //[lbldivider release];
        }
        btncalender = [[UIButton alloc] initWithFrame:btnFrame];
        btncalender.titleLabel.text=@"SMSIGN";
        btncalender.tag = 104;
        [btncalender setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalender addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btncalender];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    smsignImage = (UIImageView*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    lbltitle = (UILabel*) [cell.contentView viewWithTag:103];
    btncalender = (UIButton*) [cell.contentView viewWithTag:104];
    [smsignImage setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    [lbltitle setFrame:titleFrame];
    [btncalender setFrame:btnFrame];
    if ([_dataentryMode isEqualToString:@"L"])  
        btncalender.enabled = NO;
    else
        btncalender.enabled = YES;
    return cell;
}

- (UITableViewCell*) getCellToAddUpdDetail:(UITableView*) p_tv forMode:(NSString*) p_mode ofItem:(int) p_editRowNo
{
    static NSString *cellid=@"CellAddDetail";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    UILabel *lblSlno, *lblDivider1, *lblDivider2, *lblDivider3, *lblDivider4, *lblDivider5;
    UIButton *btnConfirm, *btnCancel, *btnItemSelect;
    int itemWidth, otherDetailWidth, startposition, otherDetailHeight, btnaddXPos;
    int dataHeight = 90;
    int  slNowidth = 40;
    startposition = 0;
    otherDetailHeight = 44;
    CGRect slNoFrame, divider1Frame, itemFrame, divider2Frame, uomFrame, divider3Frame, qtyFrame, divider4Frame, rateFrame, divider5Frame, notesFrame, btnConfFrame, btnCancelFrame, btnitemSelctFrame;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        itemWidth = 290;
        otherDetailWidth = 80;
        btnaddXPos = 625;
    }
    else
    {
        itemWidth = 420;
        otherDetailWidth = 115;
        btnaddXPos = 860;
    }
    slNoFrame = CGRectMake(startposition, 0, slNowidth, dataHeight-1);
    startposition = startposition + 40;
    divider1Frame = CGRectMake(startposition, 0, 1, dataHeight);
    startposition = startposition + 1;
    itemFrame = CGRectMake(startposition, 0, itemWidth, dataHeight-1);
    btnitemSelctFrame = CGRectMake(startposition+itemWidth-30, 0, 30, 45);
    startposition = startposition + itemWidth;
    divider2Frame = CGRectMake(startposition, 0, 1, dataHeight);
    startposition = startposition + 1;
    uomFrame = CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight);
    startposition = startposition + otherDetailWidth;
    divider3Frame = CGRectMake(startposition, 0, 1, otherDetailHeight+1);
    startposition = startposition + 1;
    qtyFrame = CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight);
    startposition = startposition + otherDetailWidth;
    divider4Frame = CGRectMake(startposition, 0, 1, otherDetailHeight+1);
    startposition = startposition + 1;
    rateFrame = CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight);
    startposition = startposition + otherDetailWidth;
    divider5Frame = CGRectMake(startposition, 0, 1, dataHeight);
    notesFrame = CGRectMake(slNowidth+2+itemWidth,otherDetailHeight+1, otherDetailWidth*3+101, otherDetailHeight);
    btnConfFrame = CGRectMake(startposition+1, 0, 49, 49);
    btnCancelFrame = CGRectMake(startposition+50, 0, 49, 49);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        lblSlno = [[UILabel alloc] initWithFrame:slNoFrame];
        lblSlno.font = reqfont;
        lblSlno.textAlignment = UITextAlignmentCenter;
        lblSlno.tag = 101;
        [lblSlno setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblSlno];
        //[lblSlno release];
        
        lblDivider1 = [[UILabel alloc] initWithFrame:divider1Frame];
        [lblDivider1 setBackgroundColor:[UIColor grayColor]];
        lblDivider1.tag = 102;
        [cell.contentView addSubview:lblDivider1];
        //[lblDivider release];
        
        lblItemAddUpdate = [[UILabel alloc] initWithFrame:itemFrame];
        lblItemAddUpdate.font = reqfont;
        lblItemAddUpdate.textAlignment = UITextAlignmentLeft;
        lblItemAddUpdate.numberOfLines = 3;
        [lblItemAddUpdate setBackgroundColor:[UIColor whiteColor]];
        lblItemAddUpdate.tag = 103;
        [cell.contentView addSubview:lblItemAddUpdate];
        
        //[lblItem release];
        btnItemSelect = [[UIButton alloc] initWithFrame:btnitemSelctFrame];
        btnItemSelect.titleLabel.text=[NSString stringWithFormat:@"%d", [detailData count]];
        [btnItemSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnItemSelect addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        btnItemSelect.tag = 54;
        [cell.contentView addSubview:btnItemSelect];
        
        lblDivider2 = [[UILabel alloc] initWithFrame:divider2Frame];
        [lblDivider2 setBackgroundColor:[UIColor grayColor]];
        lblDivider2.tag = 104;
        [cell.contentView addSubview:lblDivider2];
        //[lblDivider release];
        
        lblUOMAddUpdate = [[UILabel alloc] initWithFrame:uomFrame];
        lblUOMAddUpdate.font = reqfont;
        lblUOMAddUpdate.textAlignment = UITextAlignmentLeft;
        [lblUOMAddUpdate setBackgroundColor:[UIColor whiteColor]];
        lblUOMAddUpdate.tag = 105;
        [cell.contentView addSubview:lblUOMAddUpdate];
        //[lblUOM release];
        
        lblDivider3 = [[UILabel alloc] initWithFrame:divider3Frame];
        [lblDivider3 setBackgroundColor:[UIColor grayColor]];
        lblDivider3.tag = 106;
        [cell.contentView addSubview:lblDivider3];
        //[lblDivider release];
        
        txtQty = [[UITextField alloc] initWithFrame:qtyFrame];
        txtQty.font = reqfont;
        txtQty.textAlignment = UITextAlignmentRight;
        [txtQty setBackgroundColor:[UIColor whiteColor]];
        txtQty.tag = 107;
        txtQty.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtQty.delegate = self;
        [txtQty setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:txtQty];
        //[lblQty release];
        
        [frm setMaximumFractionDigits:2];
        lblDivider4 = [[UILabel alloc] initWithFrame:divider4Frame];
        [lblDivider4 setBackgroundColor:[UIColor grayColor]];
        lblDivider4.tag = 108;
        [cell.contentView addSubview:lblDivider4];
        //[lblDivider release];
        
        txtRate = [[UITextField alloc] initWithFrame:rateFrame];
        txtRate.font = reqfont;
        txtRate.textAlignment=UITextAlignmentRight;
        txtRate.tag = 109;
        txtRate.delegate = self;
        txtRate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [txtRate setBackgroundColor:[UIColor whiteColor]];
        [txtRate setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:txtRate];
        //[lblRate release];
        
        lblDivider5 = [[UILabel alloc] initWithFrame:divider5Frame];
        [lblDivider5 setBackgroundColor:[UIColor grayColor]];
        lblDivider5.tag = 110;
        [cell.contentView addSubview:lblDivider5];
        //[lblDivider release];
        
        txtDetailNotes = [[UITextField alloc] initWithFrame:notesFrame];
        txtDetailNotes.font = reqfont;
        txtDetailNotes.textAlignment = UITextAlignmentLeft;
        txtDetailNotes.tag = 111;
        txtDetailNotes.delegate = self;
        txtDetailNotes.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [txtDetailNotes setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:txtDetailNotes];
        //[lblNotes release];
        
        btnConfirm = [[UIButton alloc] initWithFrame:btnConfFrame];
        [btnConfirm setImage:[UIImage imageNamed:@"Checkmark.png"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(addUpdConfButtonClicked:) forControlEvents:UIControlEventTouchDown];
        //btnedit = p_rowno;
        btnConfirm.tag = 112;
        
        [cell.contentView addSubview:btnConfirm];
        //[btnedit release];
        
        btnCancel = [[UIButton alloc] initWithFrame:btnCancelFrame];
        [btnCancel setImage:[UIImage imageNamed:@"No.png"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(addUpdCancButtonClicked:) forControlEvents:UIControlEventTouchDown];
        //btndelete.tag = p_rowno;
        btnCancel.tag = 113;
        [cell.contentView addSubview:btnCancel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    lblSlno = (UILabel*) [cell.contentView viewWithTag:101];
    [lblSlno setFrame:slNoFrame];
    lblDivider1 = (UILabel*) [cell.contentView viewWithTag:102];
    [lblDivider1 setFrame:divider1Frame];
    lblItemAddUpdate = (UILabel*) [cell.contentView viewWithTag:103];
    [lblItemAddUpdate setFrame:itemFrame];
    lblDivider2 = (UILabel*) [cell.contentView viewWithTag:104];
    [lblDivider2 setFrame:divider2Frame];
    lblUOMAddUpdate = (UILabel*) [cell.contentView viewWithTag:105];
    [lblUOMAddUpdate setFrame:uomFrame];
    lblDivider3 = (UILabel*) [cell.contentView viewWithTag:106];
    [lblDivider3 setFrame:divider3Frame];
    txtQty = (UITextField*) [cell.contentView viewWithTag:107];
    [txtQty setFrame:qtyFrame];
    lblDivider4 = (UILabel*) [cell.contentView viewWithTag:108];
    [lblDivider4 setFrame:divider4Frame];
    txtRate = (UITextField*) [cell.contentView viewWithTag:109];
    [txtRate setFrame:rateFrame];
    lblDivider5 = (UILabel*) [cell.contentView viewWithTag:110];
    [lblDivider5 setFrame:divider5Frame];
    txtDetailNotes = (UITextField*) [cell.contentView viewWithTag:111];
    [txtDetailNotes setFrame:notesFrame];
    btnConfirm = (UIButton*) [cell.contentView viewWithTag:112];
    [btnConfirm setFrame:btnConfFrame];
    btnCancel = (UIButton*) [cell.contentView viewWithTag:113];
    [btnCancel setFrame:btnCancelFrame];

    if ([p_mode isEqualToString:@"A"]) 
    {
        lblSlno.text = [NSString stringWithFormat:@"%d",[detailData count]];
        btnConfirm.titleLabel.text= [NSString stringWithFormat:@"%d", [detailData count]];
        btnCancel.titleLabel.text=[NSString stringWithFormat:@"%d", [detailData count]];
    }
    else
    {
        lblSlno.text = [NSString stringWithFormat:@"%d",p_editRowNo];
        btnConfirm.titleLabel.text= [NSString stringWithFormat:@"%d", p_editRowNo];
        btnCancel.titleLabel.text=[NSString stringWithFormat:@"%d", p_editRowNo];
    }
    return cell;
}

- (IBAction) addUpdConfButtonClicked:(id)sender
{
    NSString *validationres = [self validateDataForDetailUpdate];
    UIButton *l_btn = (UIButton*) sender;
    int l_detailno = [l_btn.titleLabel.text intValue];
    if ([validationres isEqualToString:@"Success"]) 
    {
        NSArray *itemData = [lblItemAddUpdate.text componentsSeparatedByString:@" - "];
        NSMutableDictionary *addItemData = [[NSMutableDictionary alloc] initWithDictionary:[detailData objectAtIndex:l_detailno-1]  copyItems:YES];
        [addItemData setValue:[itemData objectAtIndex:0] forKey:@"ITEMCODE"];
        [addItemData setValue:[itemData objectAtIndex:1] forKey:@"ITEMNAME"];
        [addItemData removeObjectForKey:@"datamode"];
        [addItemData setValue:lblUOMAddUpdate.text forKey:@"UOMCODE"];
        [addItemData setValue:txtQty.text forKey:@"QTY"];
        [addItemData setValue:txtRate.text forKey:@"RATE"];
        [addItemData setValue:txtDetailNotes.text forKey:@"DETAILNOTES"];
        itemData = nil;
        [detailData replaceObjectAtIndex:l_detailno-1 withObject:addItemData];
        NSIndexPath *curIndPath = [NSIndexPath indexPathForRow:l_detailno inSection:2];

        [entryTV reloadRowsAtIndexPaths:[NSArray arrayWithObject:curIndPath] withRowAnimation:UITableViewRowAnimationNone];        
        [self updateTotalAmount];
        if ([_dataentryMode isEqualToString:@"A"]) 
        {
            NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"SOADD",@"message", nil];
            _returnCallBack(callbackInfo);
            return;
        }
        if ([_dataentryMode isEqualToString:@"E"]) 
        {
            NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"SOEDIT",@"message", nil];
            _returnCallBack(callbackInfo);
            return;
        }
    }
}

- (BOOL) checkDetailModeForModification
{
    for (NSDictionary *tmpdict in detailData) 
    {
        if ([tmpdict valueForKey:@"datamode"]) 
        {
            if ([[tmpdict valueForKey:@"datamode"] isEqualToString:@"A"])
                return NO;
            if ([[tmpdict valueForKey:@"datamode"] isEqualToString:@"E"])
                return NO;
        }
        
    }
    return YES;
}

- (NSString*) validateDataForDetailUpdate
{
    if ([lblItemAddUpdate.text isEqualToString:@""]) 
        return @"Please Select a valid Item";

    if ([lblUOMAddUpdate.text isEqualToString:@""]) 
        return @"UOM is not valid";
        
    if ([txtQty.text isEqualToString:@""]) 
        return @"Enter a valid quantity";
        
    if ([txtRate.text isEqualToString:@""]) 
        return @"Enter a valid rate";

    return @"Success";
}

- (IBAction) addUpdCancButtonClicked:(id)sender
{
    UIButton *l_btn = (UIButton*) sender;
    int l_rowno = [l_btn.titleLabel.text intValue];
    dAlert = [[UIAlertView alloc] initWithTitle:@"Are you \nSure to Cancel?" message:@"\n" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"NO", nil];
    dAlert.cancelButtonIndex = 0;
    dAlert.delegate = self;
    dAlert.tag = 300 + l_rowno - 1;
    [dAlert show];
}

- (IBAction) deleteDetailsButtonClicked:(id)sender
{
    if ([self checkDetailModeForModification]) 
    {
        UIButton *l_btn = (UIButton*) sender;
        int l_rowno = [l_btn.titleLabel.text intValue];
        dAlert = [[UIAlertView alloc] initWithTitle:@"Are you \nSure to Delete?" message:@"\n" delegate:self cancelButtonTitle:@"DELETE" otherButtonTitles:@"NO", nil];
        dAlert.cancelButtonIndex = 0;
        dAlert.delegate = self;
        dAlert.tag = 300 + l_rowno - 1;
        [dAlert show];
    }
    else
        [self showAlertMessage:@"Already it is in Add/Modify mode"];
        
}

- (IBAction) editDetailsButtonClicked:(id)sender
{
    if ([self checkDetailModeForModification]) 
    {
        UIButton *l_btn = (UIButton*) sender;
        int l_rowno = [l_btn.titleLabel.text intValue];
        NSMutableDictionary *editItemdata = [[NSMutableDictionary alloc] initWithDictionary:[detailData objectAtIndex:l_rowno-1] copyItems:YES];
        [editItemdata setValue:@"E" forKey:@"datamode"];
        [detailData replaceObjectAtIndex:l_rowno-1 withObject:editItemdata];
        NSIndexPath *curIndPath = [NSIndexPath indexPathForRow:l_rowno inSection:2];
        /*[entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];*/
        [entryTV reloadRowsAtIndexPaths:[NSArray arrayWithObject:curIndPath] withRowAnimation:UITableViewRowAnimationNone];
        lblItemAddUpdate.text = [[NSString alloc] initWithFormat:@"%@ - %@", [editItemdata valueForKey:@"ITEMCODE"], [editItemdata valueForKey:@"ITEMNAME"]];
        lblUOMAddUpdate.text = [editItemdata valueForKey:@"UOMCODE"];
        double colnamount  =[[editItemdata valueForKey:@"QTY"] doubleValue];
        if (colnamount<9999) 
            [frm setMaximumFractionDigits:2];
        else
            [frm setMaximumFractionDigits:0];

        NSString *st=[[[NSString alloc]initWithFormat:@"%@ ",[frm stringFromNumber:[NSNumber numberWithDouble:colnamount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        txtQty.text=st;

        colnamount  =[[editItemdata valueForKey:@"RATE"] doubleValue];
        st=[[[NSString alloc]initWithFormat:@"%@ ",[frm stringFromNumber:[NSNumber numberWithDouble:colnamount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        txtRate.text=st;
        txtRate.text = [editItemdata valueForKey:@"RATE"];
        txtDetailNotes.text = [editItemdata valueForKey:@"DETAILNOTES"];
        NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"SODETAILCHANGE",@"message", nil];
        _returnCallBack(callbackInfo);
    }
    else
        [self showAlertMessage:@"Already it is in Add/Modify mode"];
    
}

- (UITableViewCell*) getDetailViewCellForSection:(int) p_sectionno andRow:(int) p_rowno
{
    
    if (p_rowno ==0) 
        return [self getDetaillViewHeaderFor:entryTV];
    
    static NSString *cellid=@"CellDetail";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    UIButton *btnedit, *btndelete;
    int dataHeight = 90;
    int  slNowidth = 40;
    UILabel *lblSlno, *lblItem, *lblUOM, *lblQty, *lblRate, *lblDivider1, *lblDivider2, *lblDivider3, *lblDivider4, *lblDivider5,*lblNotes;
    int itemWidth, otherDetailWidth, startposition, otherDetailHeight, btnaddXPos;
    startposition = 0;
    otherDetailHeight = 44;
    CGRect slNoFrame, divider1Frame, itemFrame, divider2Frame, uomFrame, divider3Frame, qtyFrame, divider4Frame, rateFrame, divider5Frame, notesFrame, btneditFrame, btndelFrame;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        itemWidth = 290;
        otherDetailWidth = 80;
        btnaddXPos = 625;
    }
    else
    {
        itemWidth = 420;
        otherDetailWidth = 115;
        btnaddXPos = 860;
    }
    slNoFrame = CGRectMake(startposition, 0, slNowidth, dataHeight-1);
    startposition = startposition + 40;
    divider1Frame = CGRectMake(startposition, 0, 1, dataHeight);
    startposition = startposition + 1;
    itemFrame = CGRectMake(startposition, 0, itemWidth, dataHeight-1);
    startposition = startposition + itemWidth;
    divider2Frame = CGRectMake(startposition, 0, 1, dataHeight);
    startposition = startposition + 1;
    uomFrame = CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight);
    startposition = startposition + otherDetailWidth;
    divider3Frame = CGRectMake(startposition, 0, 1, otherDetailHeight+1);
    startposition = startposition + 1;
    qtyFrame = CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight);
    startposition = startposition + otherDetailWidth;
    divider4Frame = CGRectMake(startposition, 0, 1, otherDetailHeight+1);
    startposition = startposition + 1;
    rateFrame = CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight);
    startposition = startposition + otherDetailWidth;
    divider5Frame = CGRectMake(startposition, 0, 1, dataHeight);
    notesFrame = CGRectMake(slNowidth+2+itemWidth,otherDetailHeight+1, otherDetailWidth*3+101, otherDetailHeight);
    btneditFrame = CGRectMake(startposition+1, 0, 49, 49);
    btndelFrame = CGRectMake(startposition+50, 0, 49, 49);
    NSDictionary *tmpDetData = [[NSDictionary alloc] initWithDictionary:[detailData objectAtIndex:p_rowno-1] copyItems:YES];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        lblSlno = [[UILabel alloc] initWithFrame:slNoFrame];
        lblSlno.font = reqfont;
        lblSlno.textAlignment = UITextAlignmentCenter;
        lblSlno.tag = 101;
        [lblSlno setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblSlno];
        //[lblSlno release];
        
        lblDivider1 = [[UILabel alloc] initWithFrame:divider1Frame];
        [lblDivider1 setBackgroundColor:[UIColor grayColor]];
        lblDivider1.tag = 102;
        [cell.contentView addSubview:lblDivider1];
        //[lblDivider release];
        
        lblItem = [[UILabel alloc] initWithFrame:itemFrame];
        lblItem.font = reqfont;
        lblItem.textAlignment = UITextAlignmentLeft;
        lblItem.numberOfLines = 3;
        [lblItem setBackgroundColor:[UIColor whiteColor]];
        lblItem.tag = 103;
        [cell.contentView addSubview:lblItem];
        //[lblItem release];
        
        lblDivider2 = [[UILabel alloc] initWithFrame:divider2Frame];
        [lblDivider2 setBackgroundColor:[UIColor grayColor]];
        lblDivider2.tag = 104;
        [cell.contentView addSubview:lblDivider2];
        //[lblDivider release];
        
        lblUOM = [[UILabel alloc] initWithFrame:uomFrame];
        lblUOM.font = reqfont;
        lblUOM.textAlignment = UITextAlignmentLeft;
        [lblUOM setBackgroundColor:[UIColor whiteColor]];
        lblUOM.tag = 105;
        [cell.contentView addSubview:lblUOM];
        //[lblUOM release];
        
        lblDivider3 = [[UILabel alloc] initWithFrame:divider3Frame];
        [lblDivider3 setBackgroundColor:[UIColor grayColor]];
        lblDivider3.tag = 106;
        [cell.contentView addSubview:lblDivider3];
        //[lblDivider release];
        
        lblQty = [[UILabel alloc] initWithFrame:qtyFrame];
        lblQty.font = reqfont;
        lblQty.textAlignment = UITextAlignmentLeft;
        [lblQty setBackgroundColor:[UIColor whiteColor]];
        lblQty.textAlignment=UITextAlignmentRight;
        lblQty.tag = 107;
        [cell.contentView addSubview:lblQty];
        //[lblQty release];
        
        [frm setMaximumFractionDigits:2];
        lblDivider4 = [[UILabel alloc] initWithFrame:divider4Frame];
        [lblDivider4 setBackgroundColor:[UIColor grayColor]];
        lblDivider4.tag = 108;
        [cell.contentView addSubview:lblDivider4];
        //[lblDivider release];
        
        lblRate = [[UILabel alloc] initWithFrame:rateFrame];
        lblRate.font = reqfont;
        lblRate.textAlignment=UITextAlignmentRight;
        lblRate.tag = 109;
        [lblRate setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblRate];
        //[lblRate release];
        
        lblDivider5 = [[UILabel alloc] initWithFrame:divider5Frame];
        [lblDivider5 setBackgroundColor:[UIColor grayColor]];
        lblDivider5.tag = 110;
        [cell.contentView addSubview:lblDivider5];
        //[lblDivider release];
        
        lblNotes = [[UILabel alloc] initWithFrame:notesFrame];
        lblNotes.font = reqfont;
        lblNotes.textAlignment = UITextAlignmentLeft;
        lblNotes.tag = 111;
        [lblNotes setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblNotes];
        //[lblNotes release];
        
        btnedit = [[UIButton alloc] initWithFrame:btneditFrame];
        [btnedit setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnedit addTarget:self action:@selector(editDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        //btnedit = p_rowno;
        btnedit.tag = 112;
        
        [cell.contentView addSubview:btnedit];
        //[btnedit release];
        
        btndelete = [[UIButton alloc] initWithFrame:btndelFrame];
        [btndelete setImage:[UIImage imageNamed:@"deleteicon.JPG"] forState:UIControlStateNormal];
        [btndelete addTarget:self action:@selector(deleteDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        //btndelete.tag = p_rowno;
        btndelete.tag = 113;
        [cell.contentView addSubview:btndelete];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    lblSlno = (UILabel*) [cell.contentView viewWithTag:101];
    [lblSlno setFrame:slNoFrame];
    lblDivider1 = (UILabel*) [cell.contentView viewWithTag:102];
    [lblDivider1 setFrame:divider1Frame];
    lblItem = (UILabel*) [cell.contentView viewWithTag:103];
    [lblItem setFrame:itemFrame];
    lblDivider2 = (UILabel*) [cell.contentView viewWithTag:104];
    [lblDivider2 setFrame:divider2Frame];
    lblUOM = (UILabel*) [cell.contentView viewWithTag:105];
    [lblUOM setFrame:uomFrame];
    lblDivider3 = (UILabel*) [cell.contentView viewWithTag:106];
    [lblDivider3 setFrame:divider3Frame];
    lblQty = (UILabel*) [cell.contentView viewWithTag:107];
    [lblQty setFrame:qtyFrame];
    lblDivider4 = (UILabel*) [cell.contentView viewWithTag:108];
    [lblDivider4 setFrame:divider4Frame];
    lblRate = (UILabel*) [cell.contentView viewWithTag:109];
    [lblRate setFrame:rateFrame];
    lblDivider5 = (UILabel*) [cell.contentView viewWithTag:110];
    [lblDivider5 setFrame:divider5Frame];
    lblNotes = (UILabel*) [cell.contentView viewWithTag:111];
    [lblNotes setFrame:notesFrame];
    btnedit = (UIButton*) [cell.contentView viewWithTag:112];
    btnedit.titleLabel.text= [NSString stringWithFormat:@"%d", p_rowno];
    [btnedit setFrame:btneditFrame];
    btndelete = (UIButton*) [cell.contentView viewWithTag:113];
    btndelete.titleLabel.text=[NSString stringWithFormat:@"%d", p_rowno];
    [btndelete setFrame:btndelFrame];
    lblSlno.text = [NSString stringWithFormat:@"%d",p_rowno];
    lblItem.text = [NSString stringWithFormat:@"%@ - %@",[tmpDetData valueForKey:@"ITEMCODE"],[tmpDetData valueForKey:@"ITEMNAME"]];
    lblUOM.text =  [NSString stringWithFormat:@" %@",  [tmpDetData valueForKey:@"UOMCODE"]];
    double colnamount  =[[tmpDetData valueForKey:@"QTY"] doubleValue];
    if (colnamount<9999) 
        [frm setMaximumFractionDigits:2];
    else
        [frm setMaximumFractionDigits:0];
    
    NSString *st=[[[NSString alloc]initWithFormat:@"%@ ",[frm stringFromNumber:[NSNumber numberWithDouble:colnamount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lblQty.text=st;
    
    colnamount  =[[tmpDetData valueForKey:@"RATE"] doubleValue];
    st=[[[NSString alloc]initWithFormat:@"%@ ",[frm stringFromNumber:[NSNumber numberWithDouble:colnamount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lblRate.text=st;
    lblNotes.text =[NSString stringWithFormat:@" %@",[tmpDetData valueForKey:@"DETAILNOTES"]];
    if ([_dataentryMode isEqualToString:@"L"])  
        btnedit.enabled = NO;
    else
        btnedit.enabled = YES;
    if ([_dataentryMode isEqualToString:@"L"])  
        btndelete.enabled = NO;
    else
        btndelete.enabled = YES;
    //[btndelete release];
    return cell;
}

- (UITableViewCell*) getTotAmountViewCellForSection:(int) p_sectionno andRow:(int) p_rowno
{
    static NSString *cellid=@"CellTotalAmount";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    CGRect reqFrame;
    int itemWidth;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        itemWidth = 668;
    else
        itemWidth = 910;
    reqFrame = CGRectMake(2, 0, itemWidth, 50);
    UIFont *reqfont = [UIFont boldSystemFontOfSize:20.0f];
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        txtTotalAmount = [[UITextField alloc] initWithFrame:reqFrame];
        txtTotalAmount.text = @"";
        txtTotalAmount.enabled = NO;
        txtTotalAmount.font =reqfont;
        txtTotalAmount.textAlignment = UITextAlignmentRight;
        txtTotalAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtTotalAmount.tag = 101;
        [cell.contentView addSubview:txtTotalAmount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtTotalAmount = (UITextField*) [cell.contentView viewWithTag:101];
    [txtTotalAmount setFrame:reqFrame];
    [self updateTotalAmount];
    return cell;
}


- (UITableViewCell*) getDetaillViewHeaderFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellDetailHeader";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UIButton *btnadd;
    CGRect reqFrame;
    int btnaddXPos;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        btnaddXPos = 625;
    else
        btnaddXPos = 860;
    reqFrame = CGRectMake(btnaddXPos, 0, 50, 50);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor clearColor];
        btnadd = [[UIButton alloc] initWithFrame:reqFrame];
        btnadd.titleLabel.text=@"";
        btnadd.tag = 101;
        [btnadd setImage:[UIImage imageNamed:@"addiconnew1.PNG"] forState:UIControlStateNormal];
        [btnadd addTarget:self action:@selector(addDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [cell.contentView addSubview:btnadd];
        
    }
    btnadd =(UIButton*) [cell.contentView viewWithTag:101];
    [btnadd setFrame:reqFrame];
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        cell.textLabel.text = [NSString stringWithFormat:@"%@",@"Sl#                        Item                              UOM         Qty           Rate"];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@",@"Sl#                                   Item                                                UOM               Qty                  Rate"];
    if ([_dataentryMode isEqualToString:@"L"])  
        btnadd.enabled = NO;
    else
        btnadd.enabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*) getMasterViewCellForSection2:(int) p_sectionno andRow:(int) p_rowno
{
    switch (p_sectionno) {
        case 1:
        {
            switch (p_rowno) {
                case 0:
                    return [self getCustRefCell:entryTV];
                    break;                    
                case 1:
                    return [self getQuoteDtDlvryDtFor:entryTV];
                    break;                    
                case 2:
                    return [self getDlvryImportanceFor:entryTV];
                    break;
                case 3:
                    return [self getNotesCellFor:entryTV];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell*) getNotesCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellNotes";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1;
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    CGRect notesFrame, titleFrame, divider1Frame;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    notesFrame = CGRectMake(captionWidth+6, 0, 2*entryWidth+captionWidth, cellHeight);
    titleFrame = CGRectMake(4, 0, captionWidth, cellHeight-1);
    divider1Frame = CGRectMake(captionWidth+4, 0, 1, cellHeight);
    
    dividerNeeded = YES;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Notes"];
        txtnotes = [[UITextField alloc] initWithFrame:notesFrame];
        txtnotes.text = @"";
        txtnotes.placeholder = @"Enter any notes or remarks";
        txtnotes.font =reqfont;
        txtnotes.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtnotes.delegate = self;
        txtnotes.tag = 101;
        [cell.contentView addSubview:txtnotes];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:titleFrame];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        lbltitle1.tag = 102;
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:divider1Frame];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        lbldivider1.tag = 103;
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
    }
    txtnotes = (UITextField*) [cell.contentView viewWithTag:101];
    lbltitle1 = (UILabel*) [cell.contentView viewWithTag:102];
    lbldivider1 = (UILabel*) [cell.contentView viewWithTag:103];
    [txtnotes setFrame:notesFrame];
    [lbltitle1 setFrame:titleFrame];
    [lbldivider1 setFrame:divider1Frame];
    if ([_dataentryMode isEqualToString:@"L"])  
        txtnotes.enabled = NO;
    else
        txtnotes.enabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*) getDlvryImportanceFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellDlvryImport";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    int captionWidth, entryWidth, cellHeight;
    CGRect delyFrame, importanceFrame, title1Frame, divider1Frame, divider2Frame, title2Frame, divider3Frame;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    delyFrame = CGRectMake(captionWidth+6, 0, entryWidth, cellHeight);
    importanceFrame = CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth, cellHeight);
    title1Frame = CGRectMake(4, 0, captionWidth, cellHeight-1);
    divider1Frame = CGRectMake(captionWidth+4, 0, 1, cellHeight);
    divider2Frame = CGRectMake(captionWidth+6+entryWidth, 0, 1, cellHeight);
    title2Frame = CGRectMake(captionWidth+8+entryWidth, 0, captionWidth, cellHeight-1);
    divider3Frame = CGRectMake(2*captionWidth+8+entryWidth, 0, 1, cellHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Dlvry. At"];
        lblcaption2 = [[NSString alloc] initWithFormat:@"  %@",@"Importance"];
        txtdeliveryat = [[UITextField alloc] initWithFrame:delyFrame];
        txtdeliveryat.text = @"";
        txtdeliveryat.placeholder = @"Delivery Location";
        txtdeliveryat.font =reqfont;
        txtdeliveryat.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtdeliveryat.delegate = self;
        txtdeliveryat.tag = 101;
        [cell.contentView addSubview:txtdeliveryat];
        NSArray *item2Array = [NSArray arrayWithObjects: @"Normal", @"High", nil];
        scimportance = [[UISegmentedControl alloc] initWithItems:item2Array];
        [scimportance setFrame:importanceFrame];
        [scimportance setSelectedSegmentIndex:0];
        scimportance.tag = 102;
        [cell.contentView addSubview:scimportance];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:title1Frame];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        lbltitle1.tag = 103;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:divider1Frame];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        lbldivider1.tag = 104;
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        lbldivider2 = [[UILabel alloc] initWithFrame:divider2Frame];
        [lbldivider2 setBackgroundColor:[UIColor grayColor]];
        lbldivider2.tag = 105;
        [cell.contentView addSubview:lbldivider2];
        //[lbldivider2 release];
        
        lbltitle2 = [[UILabel alloc] initWithFrame:title2Frame];
        lbltitle2.font = reqfont;
        lbltitle2.text = lblcaption2;
        lbltitle2.tag = 106;
        [lbltitle2 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle2];
        //[lbltitle2 release];
        
        lbldivider3 = [[UILabel alloc] initWithFrame:divider3Frame];
        [lbldivider3 setBackgroundColor:[UIColor grayColor]];
        lbldivider3.tag = 107;
        [cell.contentView addSubview:lbldivider3];
        //[lbldivider3 release];
    }
    txtdeliveryat = (UITextField*) [cell.contentView viewWithTag:101];
    scimportance = (UISegmentedControl*) [cell.contentView viewWithTag:102];
    lbltitle1 = (UILabel*) [cell.contentView viewWithTag:103];
    lbldivider1 = (UILabel*) [cell.contentView viewWithTag:104];
    lbldivider2 = (UILabel*) [cell.contentView viewWithTag:105];
    lbltitle2 = (UILabel*) [cell.contentView viewWithTag:106];
    lbldivider3 = (UILabel*) [cell.contentView viewWithTag:107];
    [txtdeliveryat setFrame:delyFrame];
    [scimportance setFrame:importanceFrame];
    [lbltitle1 setFrame:title1Frame];
    [lbldivider1 setFrame:divider1Frame];
    [lbldivider2 setFrame:divider2Frame];
    [lbldivider3 setFrame:divider3Frame];
    [lbltitle2 setFrame:title2Frame];
    if ([_dataentryMode isEqualToString:@"L"])  
        scimportance.enabled = NO;
    else
        scimportance.enabled = YES;
    if ([_dataentryMode isEqualToString:@"L"])  
        txtdeliveryat.enabled = NO;
    else
        txtdeliveryat.enabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*) getQuoteDtDlvryDtFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellQuoteDlvry";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIButton *btncalenderQuote, *btnCalenderDlvry;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    int captionWidth, entryWidth, cellHeight;
    CGRect qtDtframe, dlyDtframe, title1Frame, title2Frame, divider1Frame, divider2Frame, divider3Frame, calenderQtFrame,calenderDlyFrame;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    qtDtframe = CGRectMake(captionWidth+6, 0, entryWidth-30, cellHeight);
    calenderQtFrame = CGRectMake(captionWidth+6+entryWidth-30, 0, 30, cellHeight);
    dlyDtframe = CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth-30, cellHeight);
    calenderDlyFrame = CGRectMake(2*captionWidth-22+2*entryWidth, 0, 30, cellHeight);
    title1Frame = CGRectMake(4, 0, captionWidth, cellHeight-1);
    divider1Frame = CGRectMake(captionWidth+4, 0, 1, cellHeight);
    divider2Frame = CGRectMake(captionWidth+6+entryWidth, 0, 1, cellHeight);
    title2Frame = CGRectMake(captionWidth+8+entryWidth, 0, captionWidth, cellHeight-1);
    divider3Frame = CGRectMake(2*captionWidth+8+entryWidth, 0, 1, cellHeight);
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Quote Dt"];
        lblcaption2 = [[NSString alloc] initWithFormat:@"  %@",@"Dlvry. Dt"];
        txtquotedate = [[UITextField alloc] initWithFrame:qtDtframe];
        txtquotedate.text = @"";
        txtquotedate.enabled=NO;
        txtquotedate.placeholder = @"Pick Quote Date";
        txtquotedate.font =reqfont;
        txtquotedate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtquotedate.tag = 101;
        [cell.contentView addSubview:txtquotedate];
        btncalenderQuote = [[UIButton alloc] initWithFrame:calenderQtFrame];
        btncalenderQuote.titleLabel.text=@"";
        [btncalenderQuote setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalenderQuote addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        btncalenderQuote.tag = 52;
        [cell.contentView addSubview:btncalenderQuote];
        //[btncalender release];
        
        txtdeliverydate = [[UITextField alloc] initWithFrame:dlyDtframe];
        txtdeliverydate.text = @"";
        txtdeliverydate.enabled = NO;
        txtdeliverydate.placeholder = @"Pick dely. Dt";
        txtdeliverydate.delegate = self;
        txtdeliverydate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtdeliverydate.tag = 102;
        [cell.contentView addSubview:txtdeliverydate];
        btnCalenderDlvry = [[UIButton alloc] initWithFrame:calenderDlyFrame];
        btnCalenderDlvry.titleLabel.text=@"";
        [btnCalenderDlvry setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnCalenderDlvry addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnCalenderDlvry];
        btnCalenderDlvry.tag = 53;
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:title1Frame];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        lbltitle1.tag = 103;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:divider1Frame];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        lbldivider1.tag = 104;
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        lbldivider2 = [[UILabel alloc] initWithFrame:divider2Frame];
        [lbldivider2 setBackgroundColor:[UIColor grayColor]];
        lbldivider2.tag = 105;
        [cell.contentView addSubview:lbldivider2];
        //[lbldivider2 release];
        
        lbltitle2 = [[UILabel alloc] initWithFrame:title2Frame];
        lbltitle2.font = reqfont;
        lbltitle2.text = lblcaption2;
        [lbltitle2 setBackgroundColor:[UIColor whiteColor]];
        lbltitle2.tag = 106;
        [cell.contentView addSubview:lbltitle2];
        //[lbltitle2 release];
        
        lbldivider3 = [[UILabel alloc] initWithFrame:divider3Frame];
        [lbldivider3 setBackgroundColor:[UIColor grayColor]];
        lbldivider3.tag = 107;
        [cell.contentView addSubview:lbldivider3];
        //[lbldivider3 release];
    }
    btncalenderQuote = (UIButton*) [cell.contentView viewWithTag:52];
    btnCalenderDlvry = (UIButton*) [cell.contentView viewWithTag:53];
    txtquotedate = (UITextField*) [cell.contentView viewWithTag:101];
    txtdeliverydate = (UITextField*) [cell.contentView viewWithTag:102];
    lbltitle1 = (UILabel*) [cell.contentView viewWithTag:103];
    lbldivider1 = (UILabel*) [cell.contentView viewWithTag:104];
    lbldivider2 = (UILabel*) [cell.contentView viewWithTag:105];
    lbltitle2 = (UILabel*) [cell.contentView viewWithTag:106];
    lbldivider3 = (UILabel*) [cell.contentView viewWithTag:107];
    [txtquotedate setFrame:qtDtframe];
    [txtdeliverydate setFrame:dlyDtframe];
    [lbltitle1 setFrame:title1Frame];
    [lbldivider1 setFrame:divider1Frame];
    [lbldivider2 setFrame:divider2Frame];
    [lbltitle2 setFrame:title2Frame];
    [lbldivider3 setFrame:divider3Frame];
    [btncalenderQuote setFrame:calenderQtFrame];
    [btnCalenderDlvry setFrame:calenderDlyFrame];
    //if ([_dataentryMode isEqualToString:@"L"])  btnCalenderDlvry.enabled = NO;
    //if ([_dataentryMode isEqualToString:@"L"])  btncalenderQuote.enabled = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*) getCustRefCell:(UITableView*) p_tv
{
    static NSString *cellid=@"CellCustRefInfo";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIButton *btncalender;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    int captionWidth, entryWidth, cellHeight;
    CGRect crFrame, crdtFrame, title1Frame, title2Frame, divider1Frame, divider2Frame, divider3Frame, btnCalenderDtFrame;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    crFrame = CGRectMake(captionWidth+6, 0, entryWidth, cellHeight);
    crdtFrame = CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth-30, cellHeight);
    btnCalenderDtFrame = CGRectMake(2*captionWidth-22+2*entryWidth, 0, 30, cellHeight);
    title1Frame = CGRectMake(4, 0, captionWidth, cellHeight-1);
    divider1Frame = CGRectMake(captionWidth+4, 0, 1, cellHeight);
    divider2Frame = CGRectMake(captionWidth+6+entryWidth, 0, 1, cellHeight);
    title2Frame = CGRectMake(captionWidth+8+entryWidth, 0, captionWidth, cellHeight-1);
    divider3Frame = CGRectMake(2*captionWidth+8+entryWidth, 0, 1, cellHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Ref no"];
        lblcaption2 = [[NSString alloc] initWithFormat:@"  %@",@"Ref Date"];
        txtcustrefno = [[UITextField alloc] initWithFrame:crFrame];
        txtcustrefno.text = @"";
        txtcustrefno.placeholder = @"Enter Ref No";
        txtcustrefno.font =reqfont;
        txtcustrefno.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtcustrefno.delegate = self;
        txtcustrefno.tag = 101;
        [txtcustrefno setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:txtcustrefno];
        
        txtcustrefdate = [[UITextField alloc] initWithFrame:crdtFrame];
        txtcustrefdate.text = @"";
        txtcustrefdate.enabled = NO;
        txtcustrefdate.placeholder = @"Pick Ref date";
        //txtcustrefdate.delegate = self;
        txtcustrefdate.tag = 102;
        txtcustrefdate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtcustrefdate];
        btncalender = [[UIButton alloc] initWithFrame:btnCalenderDtFrame];
        btncalender.titleLabel.text=@"";
        [btncalender setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalender addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        btncalender.tag = 51;
        [cell.contentView addSubview:btncalender];
        
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:title1Frame];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        lbltitle1.tag = 103;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        
        lbldivider1 = [[UILabel alloc] initWithFrame:divider1Frame];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        lbldivider1.tag = 104;
        [cell.contentView addSubview:lbldivider1];
        
        
        lbldivider2 = [[UILabel alloc] initWithFrame:divider2Frame];
        [lbldivider2 setBackgroundColor:[UIColor grayColor]];
        lbldivider2.tag = 105;
        [cell.contentView addSubview:lbldivider2];
        //[lbldivider2 release];
        
        lbltitle2 = [[UILabel alloc] initWithFrame:title2Frame];
        lbltitle2.font = reqfont;
        lbltitle2.text = lblcaption2;
        lbltitle2.tag = 106;
        [lbltitle2 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle2];
        //[lbltitle2 release];
        
        lbldivider3 = [[UILabel alloc] initWithFrame:divider3Frame];
        [lbldivider3 setBackgroundColor:[UIColor grayColor]];
        lbldivider3.tag = 107;
        [cell.contentView addSubview:lbldivider3];
        //[lbldivider3 release];
    }
    txtcustrefno = (UITextField*) [cell.contentView viewWithTag:101];
    txtcustrefdate = (UITextField*) [cell.contentView viewWithTag:102];
    btncalender = (UIButton*) [cell.contentView viewWithTag:51];
    lbltitle1 = (UILabel*) [cell.contentView viewWithTag:103];
    lbltitle2 = (UILabel*) [cell.contentView viewWithTag:106];
    lbldivider1 = (UILabel*) [cell.contentView viewWithTag:104];
    lbldivider2 = (UILabel*) [cell.contentView viewWithTag:105];
    lbldivider3 = (UILabel*) [cell.contentView viewWithTag:107];
    [txtcustrefno setFrame:crFrame];
    [txtcustrefdate setFrame:crdtFrame];
    [btncalender setFrame:btnCalenderDtFrame];
    [lbltitle1 setFrame:title1Frame];
    [lbltitle2 setFrame:title2Frame];
    [lbldivider1 setFrame:divider1Frame];
    [lbldivider2 setFrame:divider2Frame];
    [lbldivider3 setFrame:divider3Frame];
    if ([_dataentryMode isEqualToString:@"L"])  
        txtcustrefno.enabled = NO;
    else
        txtcustrefno.enabled = YES;
    //if ([_dataentryMode isEqualToString:@"L"])  btncalender.enabled = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*) getMasterViewCellForSection:(int) p_sectionno andRow:(int) p_rowno
{
    switch (p_sectionno) 
    {
        case 0:
        {
            switch (p_rowno) {
                case 0:
                    return [self getOrderNoCellFor:entryTV];
                    break;
                case 1:
                    return [self getCustomerCellFor:entryTV];
                    break;
                case 2:
                    return [self getDivisionSalesCellFor:entryTV];
                    break;                    
                case 3:
                    return [self getPayTermCellFor:entryTV];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell*) getPayTermCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellPayTerm";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1 ;
    int captionWidth, entryWidth, cellHeight;
    CGRect payTermFrame, titleFrame, dividerFrame;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    payTermFrame = CGRectMake(captionWidth+6, 0, 2*entryWidth+captionWidth+4, cellHeight);
    titleFrame = CGRectMake(4, 0, captionWidth, cellHeight-1);
    dividerFrame = CGRectMake(captionWidth+4, 0, 1, cellHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Pay Term"];
        txtPaymentTerm = [[UITextField alloc] initWithFrame:payTermFrame];
        txtPaymentTerm.text = @"";
        txtPaymentTerm.enabled = NO;
        txtPaymentTerm.placeholder = @"Select a Pay term";
        txtPaymentTerm.font =reqfont;
        txtPaymentTerm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //txtPaymentTerm.delegate = self;
        txtPaymentTerm.tag = 101;
        [cell.contentView addSubview:txtPaymentTerm];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:titleFrame];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        lbltitle1.tag = 102;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:dividerFrame];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        lbldivider1.tag = 103;
        [cell.contentView addSubview:lbldivider1];
        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    txtPaymentTerm = (UITextField*) [cell.contentView viewWithTag:101];
    lbltitle1 = (UILabel*) [cell.contentView viewWithTag:102];
    lbldivider1 = (UILabel*) [cell.contentView viewWithTag:103];
    [txtPaymentTerm setFrame:payTermFrame];
    [lbltitle1 setFrame:titleFrame];
    [lbldivider1 setFrame:dividerFrame];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /*if ([_dispMode isEqualToString:@"L"]==NO)  //scenqmode.enabled = NO;
     cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
     else*/
    cell.accessoryType =UITableViewCellAccessoryNone;
    return cell;
}

- (UITableViewCell*) getDivisionSalesCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellDivSales";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    int captionWidth, entryWidth, cellHeight;
    CGRect divisionFrame, titleFrame, dividerFrame;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    divisionFrame = CGRectMake(captionWidth+6, 0, 2*entryWidth+captionWidth+4, cellHeight);
    titleFrame = CGRectMake(4, 0, captionWidth, cellHeight-1);
    dividerFrame = CGRectMake(captionWidth+4, 0, 1, cellHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Division"];
        lblcaption2 = @"";
        txtdivCode = [[UITextField alloc] initWithFrame:divisionFrame];
        /*txtdivCode = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, entryWidth-30, cellHeight)];*/
        txtdivCode.text = @"";
        txtdivCode.enabled=NO;
        txtdivCode.placeholder = @"Select Division";
        txtdivCode.font =reqfont;
        txtdivCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //txtdivCode.delegate = self;
        txtdivCode.tag = 101;
        [cell.contentView addSubview:txtdivCode];
        /*btnSelectDiv = [[UIButton alloc] initWithFrame:CGRectMake(captionWidth+6+entryWidth-30, 0, 30, cellHeight)];
         btnSelectDiv.titleLabel.text=@"";
         [btnSelectDiv setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
         [btnSelectDiv addTarget:self action:@selector(selectDivSalesman:) forControlEvents:UIControlEventTouchDown];
         [cell.contentView addSubview:btnSelectDiv];
         btnSelectDiv.tag = 55;*/
        //[btnSelect release];
        
        /*txtSalesman = [[UITextField alloc] initWithFrame:CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth-30, cellHeight)];
         txtSalesman.text = @"";
         if (smValue) 
         txtSalesman.text = smValue;
         txtSalesman.enabled = NO;
         txtSalesman.placeholder = @"Select Salesman";
         txtSalesman.delegate = self;
         txtSalesman.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
         txtSalesman.tag = 102;
         [cell.contentView addSubview:txtSalesman];
         btnSelectSM = [[UIButton alloc] initWithFrame:CGRectMake(2*captionWidth-22+2*entryWidth, 0, 30, cellHeight)];
         btnSelectSM.titleLabel.text=@"";
         [btnSelectSM setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
         [btnSelectSM addTarget:self action:@selector(selectDivSalesman:) forControlEvents:UIControlEventTouchDown];
         [cell.contentView addSubview:btnSelectSM];
         btnSelectSM.tag = 56;*/
        //[btnSelect release];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        //lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:titleFrame];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        lbltitle1.tag = 102;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:dividerFrame];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        lbldivider1.tag = 103;
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        /*if ([lblcaption2 isEqualToString:@""]==NO) {
            lbldivider2 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+6+entryWidth, 0, 1, cellHeight)];
            [lbldivider2 setBackgroundColor:[UIColor grayColor]];
            [cell.contentView addSubview:lbldivider2];
            //[lbldivider2 release];
            
            lbltitle2 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+8+entryWidth, 0, captionWidth, cellHeight-1)];
            lbltitle2.font = reqfont;
            lbltitle2.text = lblcaption2;
            [lbltitle2 setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:lbltitle2];
            //[lbltitle2 release];
            
            lbldivider3 = [[UILabel alloc] initWithFrame:CGRectMake(2*captionWidth+8+entryWidth, 0, 1, cellHeight)];
            [lbldivider3 setBackgroundColor:[UIColor grayColor]];
            [cell.contentView addSubview:lbldivider3];
            //[lbldivider3 release];
        }*/
    }
    txtdivCode = (UITextField*) [cell.contentView viewWithTag:101];
    lbltitle1 = (UILabel*) [cell.contentView viewWithTag:102];
    lbldivider1 = (UILabel*) [cell.contentView viewWithTag:103];
    [txtdivCode setFrame:divisionFrame];
    [lbltitle1 setFrame:titleFrame];
    [lbldivider1 setFrame:dividerFrame];
                              
    /*txtSalesman = (UITextField*) [cell.contentView viewWithTag:102];
     btnSelectDiv = (UIButton*) [cell.contentView viewWithTag:55];
     btnSelectSM = (UIButton*) [cell.contentView viewWithTag:56];
     if ([_dispMode isEqualToString:@"L"])  btnSelectDiv.enabled = NO;
     if ([_dispMode isEqualToString:@"L"])  btnSelectSM.enabled = NO;*/
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_dataentryMode isEqualToString:@"L"]==NO)  //scenqmode.enabled = NO;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType =UITableViewCellAccessoryNone;
    
    return cell;
}

- (UITableViewCell*) getCustomerCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellCustomer";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1;
    int captionWidth, entryWidth, cellHeight;
    CGRect custFrame, titleFrame, dividerFrame;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    custFrame = CGRectMake(captionWidth+6, 0, 2*entryWidth+captionWidth+4, cellHeight);
    titleFrame = CGRectMake(4, 0, captionWidth, cellHeight-1);
    dividerFrame = CGRectMake(captionWidth+4, 0, 1, cellHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Customer"];
        txtcustomer = [[UITextField alloc] initWithFrame:custFrame];
        txtcustomer.text = @"";
        txtcustomer.enabled = NO;
        txtcustomer.placeholder = @"Select a Customer";
        txtcustomer.font =reqfont;
        txtcustomer.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //txtcustomer.delegate = self;
        txtcustomer.tag = 101;
        [cell.contentView addSubview:txtcustomer];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:titleFrame];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        lbltitle1.tag = 102;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:dividerFrame];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        lbldivider1.tag = 103;
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
    }
    txtcustomer = (UITextField*) [cell.contentView viewWithTag:101];
    lbltitle1 = (UILabel*) [cell.contentView viewWithTag:102];
    lbldivider1 = (UILabel*) [cell.contentView viewWithTag:103];
    [txtcustomer setFrame:custFrame];
    [lbltitle1 setFrame:titleFrame];
    [lbldivider1 setFrame:dividerFrame];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_dataentryMode isEqualToString:@"L"]==NO)  //scenqmode.enabled = NO;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType =UITableViewCellAccessoryNone;
    return cell;
}

- (UITableViewCell*) getOrderNoCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellOrderInfo";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    int captionWidth, entryWidth, cellHeight;
    CGRect sonoFrame, enqModeFrame, title1Frame, title2Frame, divider1Frame, divider2Frame, divider3Frame;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    sonoFrame = CGRectMake(captionWidth+6, 0, entryWidth, cellHeight);
    enqModeFrame = CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth, cellHeight);
    title1Frame = CGRectMake(4, 0, captionWidth, cellHeight-1);
    divider1Frame = CGRectMake(captionWidth+4, 0, 1, cellHeight);
    divider2Frame = CGRectMake(captionWidth+6+entryWidth, 0, 1, cellHeight);
    title2Frame = CGRectMake(captionWidth+8+entryWidth, 0, captionWidth, cellHeight-1);
    divider3Frame = CGRectMake(2*captionWidth+8+entryWidth, 0, 1, cellHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Order No"];
        lblcaption2 = [[NSString alloc] initWithFormat:@"  %@",@"Enquiry"];
        txtsono = [[UITextField alloc] initWithFrame:sonoFrame];
        txtsono.text = @"";
        txtsono.enabled = NO;
        txtsono.placeholder = @"Order No (auto generated)";
        txtsono.font =reqfont;
        txtsono.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //txtsono.delegate = self;
        txtsono.tag = 101;
        [cell.contentView addSubview:txtsono];
        NSArray *itemArray = [NSArray arrayWithObjects: @"Fax", @"Ph.", @"Mail", @"Doc", nil];
        scenqmode = [[UISegmentedControl alloc] initWithItems:itemArray];
        [scenqmode setFrame:enqModeFrame];
        [scenqmode setSelectedSegmentIndex:0];
        scenqmode.tag = 102;
        [cell.contentView addSubview:scenqmode];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:title1Frame];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        lbltitle1.tag = 103;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:divider1Frame];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        lbldivider1.tag = 104;
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        lbldivider2 = [[UILabel alloc] initWithFrame:divider2Frame];
        [lbldivider2 setBackgroundColor:[UIColor grayColor]];
        lbldivider2.tag = 105;
        [cell.contentView addSubview:lbldivider2];
        //[lbldivider2 release];
        
        lbltitle2 = [[UILabel alloc] initWithFrame:title2Frame];
        lbltitle2.font = reqfont;
        lbltitle2.text = lblcaption2;
        [lbltitle2 setBackgroundColor:[UIColor whiteColor]];
        lbltitle2.tag = 106;
        [cell.contentView addSubview:lbltitle2];
        //[lbltitle2 release];
        
        lbldivider3 = [[UILabel alloc] initWithFrame:divider3Frame];
        [lbldivider3 setBackgroundColor:[UIColor grayColor]];
        lbldivider3.tag = 107;
        [cell.contentView addSubview:lbldivider3];
        //[lbldivider3 release];
    }
    txtsono = (UITextField*) [cell.contentView viewWithTag:101];
    scenqmode = (UISegmentedControl*) [cell.contentView viewWithTag:102];
    lbltitle1 = (UILabel*) [cell.contentView viewWithTag:103];
    lbldivider1 = (UILabel*) [cell.contentView viewWithTag:104];
    lbldivider2 = (UILabel*) [cell.contentView viewWithTag:105];
    lbltitle2 = (UILabel*) [cell.contentView viewWithTag:106];
    lbldivider3 = (UILabel*) [cell.contentView viewWithTag:107];
    [txtsono setFrame:sonoFrame];
    [scenqmode setFrame:enqModeFrame];
    [lbltitle1 setFrame:title1Frame];
    [lbldivider1 setFrame:divider1Frame];
    [lbldivider2 setFrame:divider2Frame];
    [lbltitle2 setFrame:title2Frame];
    [lbldivider3 setFrame:divider3Frame];
    if ([_dataentryMode isEqualToString:@"L"])  
        scenqmode.enabled = NO;
    else
        scenqmode.enabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *key;
    key =  @"   ";
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    return key;
}

- (void) updateTotalAmount
{
    NSString *tempqty, *temprate;
    double totalAmount = 0;
    if (detailData) 
    {
        for (NSDictionary *tmpDict in detailData) 
        {
            tempqty = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"QTY"]];
            temprate = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"RATE"]];
            totalAmount = totalAmount+[tempqty doubleValue]*[temprate doubleValue];
        }
    }
    if (txtTotalAmount)
        txtTotalAmount.text =[[[NSString alloc]initWithFormat:@" SO Total : %@   ",[frm stringFromNumber:[NSNumber numberWithDouble:totalAmount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
}

- (void) setItemValues:(NSDictionary*) p_itemInfo
{
    if (p_itemInfo) 
    {
        lblItemAddUpdate.text = [[NSString alloc] initWithFormat:@"%@ - %@", [p_itemInfo valueForKey:@"CD"], [p_itemInfo valueForKey:@"CN"]];
        NSString *l_uomlist = [[NSString alloc] initWithFormat:@"%@",[p_itemInfo valueForKey:@"UOMLIST"]];
        int l_noofUOMs = [[p_itemInfo valueForKey:@"NOOFUOMS"] intValue];
        lblUOMAddUpdate.text = [p_itemInfo valueForKey:@"UOM"];
        if (l_noofUOMs>1)
        {
            uomSearch *searchUOM = [[uomSearch alloc] initWithFrame:CGRectMake(20, 25.0, 240.0, 150.0) andUOMList:l_uomlist andCallbackMethod:_returnCallBack];
            //dAlert = [[UIAlertView alloc] initWithTitle:@"Pick a UOM" message:@"\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select UOM", nil];
            dAlert = [[UIAlertView alloc] initWithTitle:@"Pick a UOM" message:@"\n\n\n\n\n\n" delegate:self cancelButtonTitle:[p_itemInfo valueForKey:@"UOM"] otherButtonTitles:@"Select UOM", nil];
            dAlert.cancelButtonIndex = 0;
            dAlert.delegate = self;
            [dAlert addSubview:searchUOM];
            dAlert.tag = 101;
            [dAlert show];
            return;
        }
    }
}

- (IBAction) displayCalendar:(id) sender
{
    if ([_dataentryMode isEqualToString:@"L"]) return;
    UIButton *btnsender = (UIButton*) sender;
    if (btnsender.tag == 54) 
    {
        
        NSRange l_custcoderange = [txtcustomer.text rangeOfString:@" - "];
        NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"ITEMSELECT",@"message",[txtcustomer.text substringToIndex:l_custcoderange.location],@"custcode",  nil];
        _returnCallBack(callbackInfo);
        return;
    }
    
    if ([btnsender.titleLabel.text isEqualToString:@"SMSIGN"]) 
    {
        NSMutableDictionary *callbackInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"SMSIGNSELECT",@"message", nil];
        [callbackInfo setValue:smsignImage.image forKey:@"currimage"];
        _returnCallBack(callbackInfo);
        return;
    }
    
    if ([btnsender.titleLabel.text isEqualToString:@"CUSIGN"]) 
    {
        NSMutableDictionary *callbackInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"CUSIGNSELECT",@"message", nil];
        [callbackInfo setValue:givensignImage.image forKey:@"currimage"];
        _returnCallBack(callbackInfo);
        return;
    }
    
    
    dAlert = [[UIAlertView alloc] initWithTitle:@"Pick a date" message:@"\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select", nil];
    dAlert.cancelButtonIndex = 0;
    dAlert.delegate = self;
    dAlert.tag = btnsender.tag;

    dobPicker = [[UIDatePicker alloc] init];
    dobPicker.frame=CGRectMake(20, 25.0, 240.0, 150.0);
    dobPicker.datePickerMode = UIDatePickerModeDate;
    [dobPicker setDate:[NSDate date]];
    [dAlert addSubview:dobPicker];
    [dAlert show];
    //[dAlert release];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    shouldScroll = true;
    [self setContentOffset:scrollOffset animated:NO]; 
    if ([textField isEqual:txtcustrefno]) 
    {
        [txtcustrefno resignFirstResponder];
    }
    else if([textField isEqual:txtdeliveryat])
    {
        [txtdeliveryat resignFirstResponder];
        
    }
    else if ([textField isEqual:txtnotes])
    {
        [txtnotes resignFirstResponder];
    }
    else if ([textField isEqual:txtQty])
    {
        [txtRate becomeFirstResponder];
    }
    else if ([textField isEqual:txtRate])
    {
        [txtDetailNotes becomeFirstResponder];
    }
    else if ([textField isEqual:txtDetailNotes])
    {
        [txtDetailNotes resignFirstResponder];
    }
    
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    if (shouldScroll) 
    {
        scrollOffset = self.contentOffset;
        CGPoint scrollPoint;
        CGRect inputFieldBounds = [textField bounds];
        inputFieldBounds = [textField convertRect:inputFieldBounds toView:self];
        scrollPoint =  self.bounds.origin; 
        scrollPoint.x = 0;
        //NSLog(@"the self bounds origin is %f  %f", scrollPoint.x, scrollPoint.y);
        //NSLog(@"the input field bound %f  %f   %f   %f", inputFieldBounds.origin.x, inputFieldBounds.origin.y, inputFieldBounds.size.width, inputFieldBounds.size.height);
        if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        {
            if (inputFieldBounds.origin.y > 690) 
                scrollPoint.y = inputFieldBounds.origin.y - 690 + 44;
            else
                scrollPoint.y = 44;
        }
        else
        {
            if (inputFieldBounds.origin.y > 338) 
                scrollPoint.y = inputFieldBounds.origin.y - 338 + 44;
            else
                scrollPoint.y = 44;
        }
        [self setContentOffset:scrollPoint animated:NO];  
        shouldScroll = false;
    }
}

- (NSString*) setAfterSaveOptions:(NSDictionary*) p_saveResult
{
    //[self setViewListMode];
    //NSLog(@"the data entry mode is %@", _dataentryMode);
    if ([_dataentryMode isEqualToString:@"A"]) 
    {
        NSString *sono = [[NSString alloc] initWithFormat:@"%@ / %@",[p_saveResult valueForKey:@"SONO"],[p_saveResult valueForKey:@"SODATE"]];
        txtsono.text = sono;
        _soid = [p_saveResult valueForKey:@"SOID"];
        return @"New Sales Order Entry Added";
    }
    else
        return @"Sales Order Entry details updated";
    return nil;
}

- (void) setViewListMode
{
    _dataentryMode = @"L";
    txtsono.enabled = NO;
    txtcustrefno.enabled = NO;
    txtdeliveryat.enabled = NO;
    txtnotes.enabled = NO;
    scenqmode.enabled = NO;
    scimportance.enabled = NO;
    [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) setEditMode
{
    
    _dataentryMode = @"E";
    [self showSignChequeImages:nil];
    [entryTV reloadData];
    txtsono.enabled = NO;
    txtcustrefno.enabled = YES;
    txtdeliveryat.enabled =YES;
    txtnotes.enabled = YES;
    scenqmode.enabled = YES;
    scimportance.enabled = YES;
    [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    [entryTV selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:4] animated:NO scrollPosition:UITableViewScrollPositionBottom];
}

- (NSString*) getCurrentMode
{
    return _dataentryMode;
}

- (NSString*) getSOId
{
    return _soid;
}

- (void) setDataForDisplay:(NSDictionary*) p_dict
{
    [self setViewListMode];
    NSMutableArray *recdData = [[NSMutableArray alloc] initWithArray:[p_dict valueForKey:@"data"] copyItems:YES];
    [self displayDictValuesFor:[recdData objectAtIndex:0]];
    [detailData removeAllObjects];
    for (int l_counter=1; l_counter< [recdData count] ; l_counter++) 
        [detailData addObject:[recdData objectAtIndex:l_counter]];
    [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    [self updateTotalAmount];
    
}

- (void) displayDictValuesFor:(NSDictionary*) p_dict
{
    if ([_dataentryMode isEqualToString:@"L"] | [_dataentryMode isEqualToString:@"E"]) 
    {
        //NSLog(@"initial data received %@", _initialData);
        
        _soid = [[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"SOID"]];
        txtsono.text = [[NSString alloc] initWithFormat:@"%@ / %@",[p_dict valueForKey:@"SONO"],[p_dict valueForKey:@"SODATE"]];
        scenqmode.selectedSegmentIndex = [[[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"ENQMODE"]] intValue]; 
        txtcustomer.text = [[NSString alloc] initWithFormat:@"%@ - %@", [p_dict valueForKey:@"CUSTOMERCODE"], [p_dict valueForKey:@"CUSTOMERNAME"]];
        txtdivCode.text = [[NSString alloc] initWithFormat:@"%@ - %@", [p_dict valueForKey:@"DIVCODE"], [p_dict valueForKey:@"DIVDESC"]];
        txtPaymentTerm.text = [[NSString alloc] initWithFormat:@"%@ - %@", [p_dict valueForKey:@"PAYTERMCODE"], [p_dict valueForKey:@"PAYTERMNAME"]];

        if ([p_dict valueForKey:@"CUSTREFNO"]) 
            txtcustrefno.text = [[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"CUSTREFNO"]];
        else
            txtcustrefno.text = [[NSString alloc] initWithFormat:@"%@",@""];
        
        if ([p_dict valueForKey:@"CUSTREFDATE"]) 
            txtcustrefdate.text = [[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"CUSTREFDATE"]];
        else
            txtcustrefdate.text = [[NSString alloc] initWithFormat:@"%@",@""];
        
        if ([p_dict valueForKey:@"QUOTEDATE"]) 
            txtquotedate.text = [[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"QUOTEDATE"]];
        else
            txtquotedate.text = [[NSString alloc] initWithFormat:@"%@",@""];
        
        if ([p_dict valueForKey:@"DELIVERYDATE"]) 
            txtdeliverydate.text = [[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"DELIVERYDATE"]];
        else
            txtdeliverydate.text = [[NSString alloc] initWithFormat:@"%@",@""];
        
        if ([p_dict valueForKey:@"DELIVERYAT"]) 
            txtdeliveryat.text = [[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"DELIVERYAT"]];
        else
            txtdeliveryat.text = [[NSString alloc] initWithFormat:@"%@",@""];
        
        scimportance.selectedSegmentIndex = [[[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"IMPORTANCE"]] intValue]; 
        
        if ([p_dict valueForKey:@"MASTERNOTES"]) 
            txtnotes.text = [[NSString alloc] initWithFormat:@"%@",[p_dict valueForKey:@"MASTERNOTES"]];
        else
            txtnotes.text = [[NSString alloc] initWithFormat:@"%@",@""];
        
    }
}

- (void) setCustomerInformation :(NSDictionary*) p_custInfo
{
    if (p_custInfo) {
        if (txtcustomer) 
            txtcustomer.text = [[NSString alloc] initWithFormat:@"%@ - %@", [p_custInfo valueForKey:@"CD"], [p_custInfo valueForKey:@"CN"]];
        [self setPaytermValues:p_custInfo];
    }
}

- (void) setPaytermValues:(NSDictionary*) p_paytermInfo
{
    if (p_paytermInfo) {
        if (txtPaymentTerm) 
            txtPaymentTerm.text = [[NSString alloc] initWithFormat:@"%@ - %@", [p_paytermInfo valueForKey:@"PAYTERMCODE"], [p_paytermInfo valueForKey:@"PAYTERMNAME"]];
    }
}

- (void) setDivisionValues:(NSDictionary*) p_divInfo
{
    if (p_divInfo) {
        if (txtdivCode) 
            txtdivCode.text = [[NSString alloc] initWithFormat:@"%@ - %@", [p_divInfo valueForKey:@"DIVCODE"], [p_divInfo valueForKey:@"DIVDESC"]];
    }
    
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *btntitle = [alertView buttonTitleAtIndex:buttonIndex]; 
    int btnTagForAlert = dAlert.tag;
    if ([btntitle isEqualToString:@"Select"]) 
    {
        NSDate *date = [dobPicker date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:(NSString*) @"dd-MMM-yyyy"];
        if (btnTagForAlert==51) 
        {
            txtcustrefdate.text = [dateFormatter stringFromDate:date];
            return;
        }
        if (btnTagForAlert==52) 
        {
            txtquotedate.text = [dateFormatter stringFromDate:date];
            return;
        }
        if (btnTagForAlert==53) 
        {
            txtdeliverydate.text = [dateFormatter stringFromDate:date];
            return;
        }
        return;
    }
    
    if (btnTagForAlert==101) 
    {
        if (!([btntitle isEqualToString:@"Select UOM"])) 
            lblUOMAddUpdate.text = btntitle;
    }
    
    /*if (btnTagForAlert==201) 
    {
        //DURING ADD DETAIL CANCELLATION IS DONE
        if ([btntitle isEqualToString:@"YES"]) 
        {
            [detailData removeObjectAtIndex:[detailData count]-1];
            [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            [self updateTotalAmount];
        }
    }*/
    
    if (btnTagForAlert>=300) 
    {
        if ([btntitle isEqualToString:@"CANCEL"]) 
        {
            NSMutableDictionary *detDict = [[NSMutableDictionary alloc] initWithDictionary:[detailData objectAtIndex:btnTagForAlert-300] copyItems:YES];
            if ([[detDict valueForKey:@"datamode"] isEqualToString:@"A"])
            {
                [detailData removeObjectAtIndex:btnTagForAlert-300];
            }
            else
            {
                [detDict removeObjectForKey:@"datamode"];
                [detailData replaceObjectAtIndex:btnTagForAlert-300 withObject:detDict];
            }
            if ([_dataentryMode isEqualToString:@"A"]) 
            {
                NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"SOADD",@"message", nil];
                _returnCallBack(callbackInfo);
            }
            if ([_dataentryMode isEqualToString:@"E"]) 
            {
                NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"SOEDIT",@"message", nil];
                _returnCallBack(callbackInfo);
            }
        }
        if ([btntitle isEqualToString:@"DELETE"]) 
        {
            [detailData removeObjectAtIndex:btnTagForAlert-300];
        }
        [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        [self updateTotalAmount];
    }
    
}

- (void) setUOMSelected:(NSString*) p_uom
{
    //uomSelected = p_uom;
    lblUOMAddUpdate.text = p_uom; //[p_itemInfo valueForKey:@"UOM"];
}

- (IBAction) addDetailsButtonClicked:(id) sender
{
    NSRange l_custcoderange = [txtcustomer.text rangeOfString:@" - "];
    NSString *l_custcode = [txtcustomer.text substringToIndex:l_custcoderange.location];
    if ([l_custcode isEqualToString:@""]==NO) 
    {
        if ([self checkDetailModeForModification]) 
        {
            NSMutableDictionary *addItemInfo = [[NSMutableDictionary alloc] init];
            [addItemInfo setValue:@"A" forKey:@"datamode"];
            [detailData addObject:addItemInfo];
            [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            lblItemAddUpdate.text = @"";
            lblUOMAddUpdate.text = @"";
            txtQty.text = @"";
            txtRate.text = @"";
            txtDetailNotes.text = @"";
            NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"SODETAILCHANGE",@"message", nil];
            _returnCallBack(callbackInfo);
        }
        else
            [self showAlertMessage:@"Already it is in Add/Modify mode"];
            
    }
    else
        [self showAlertMessage:@"Please select a valid customer"];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}

- (NSDictionary*) validateData
{
    NSDictionary *returnDict;
    if ([txtcustomer.text isEqualToString:@""]) 
    {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Customer should be selected",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    if ([txtdivCode.text isEqualToString:@""]) {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Division should be selected",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    /*if ([txtSalesman.text isEqualToString:@""]) {
     returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Salesman should be selected",@"RESPONSEMESSAGE"  , nil];
     return returnDict;
     }*/
    /*if ([txtPaymentTerm.text isEqualToString:@""]) {
     returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Payment term should be selected",@"RESPONSEMESSAGE"  , nil];
     return returnDict;
     }*/
    
    if ([detailData count]==0) {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Item details are not available",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    if (!([self checkDetailModeForModification])) 
    {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Currently screen \nAdd/Update is on Progress",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
        
    }
    returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"RESPONSECODE",@"Successfully Validated",@"RESPONSEMESSAGE"  , nil];
    return returnDict;
}

- (NSString*) getXMLForPosting
{
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    NSMutableString *l_detailXML = [[NSMutableString alloc] init ];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *custValues = [txtcustomer.text componentsSeparatedByString:@" - "];
    NSArray *divValues = [txtdivCode.text componentsSeparatedByString:@" - "];
    NSArray *paytermValues = [txtPaymentTerm.text componentsSeparatedByString:@" - "];
    double totalAmount = 0;
    if (detailData) 
    {
        for (NSDictionary *tmpDict in detailData) 
        {
            NSString* tempqty = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"QTY"]];
            NSString* temprate = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"RATE"]];
            totalAmount = totalAmount+[tempqty doubleValue]*[temprate doubleValue];
        }
    }
    if ([_dataentryMode isEqualToString:@"A"]) 
        l_retXML = [NSString stringWithFormat:soMasterXML, @"0",@"0", [custValues objectAtIndex:0] , scenqmode.selectedSegmentIndex, scimportance.selectedSegmentIndex, txtcustrefno.text, txtcustrefdate.text, txtquotedate.text, txtdeliverydate.text, txtdeliveryat.text, txtnotes.text,[divValues objectAtIndex:0], [standardUserDefaults valueForKey:@"SALESMANCODE"],[paytermValues objectAtIndex:0] ,totalAmount];
    else
        l_retXML = [NSString stringWithFormat:soMasterXML, _soid,@"X", [custValues objectAtIndex:0] , scenqmode.selectedSegmentIndex, scimportance.selectedSegmentIndex, txtcustrefno.text, txtcustrefdate.text, txtquotedate.text, txtdeliverydate.text, txtdeliveryat.text, txtnotes.text,[divValues objectAtIndex:0], [standardUserDefaults valueForKey:@"SALESMANCODE"],[paytermValues objectAtIndex:0] ,totalAmount];
    
    for (NSDictionary *tmpDict in detailData) {
        l_detailXML = [NSString stringWithFormat:soDetailXML, [tmpDict valueForKey:@"SODETAILID"],@"0",[tmpDict valueForKey:@"ITEMCODE"], [tmpDict valueForKey:@"UOMCODE"], [tmpDict valueForKey:@"QTY"], [tmpDict valueForKey:@"RATE"],[tmpDict valueForKey:@"DETAILNOTES"]];
        l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_detailXML];
    }
    l_retXML = [NSString stringWithFormat:@"%@%@%@",@"<SODATA>",l_retXML, @"</SODATA>"];
    //NSLog(@"xml result %@", l_retXML);
    return l_retXML;
}

- (void) setSignature:(NSDictionary*) p_signdict forType:(NSString*) p_signType
{
    UIImage *img = (UIImage*) [p_signdict valueForKey:@"signimage"];
    if (img) 
    {
        if ([p_signType isEqualToString:@"SM"]) 
        {
            [smsignImage setImage:img];
            //[chequePhoto setImage:img];
            return;
        }
        
        if ([p_signType isEqualToString:@"CU"]) 
        {
            [givensignImage setImage:img];
            return;
        }
    }
}

- (NSString*) getImageStringFor:(NSString*) p_imgType
{
    NSData *dataObj;
    //UIImageWriteToSavedPhotosAlbum(smsignImage.image, nil, nil, nil);
    
    if ([p_imgType isEqualToString:@"SM"]) 
    {
        //UIImageWriteToSavedPhotosAlbum(smsignImage.image, nil, nil, nil);
        dataObj = UIImagePNGRepresentation(smsignImage.image);
    }
    
    if ([p_imgType isEqualToString:@"CU"]) 
    {
        //UIImageWriteToSavedPhotosAlbum(givensignImage.image, nil, nil, nil);
        dataObj = UIImagePNGRepresentation(givensignImage.image);
    }
    
    Base64 *bb = [[Base64 alloc] init];
    NSString * actualString= [bb encode:dataObj];
    return  actualString;
}

- (void) setImageFromServer:(NSString*) p_filename forType:(NSString*) p_signNature
{
    NSString *l_filename;
    METHODCALLBACK _imageProxyCallback = ^(NSDictionary* p_dictInfo)
    {
        [self imageProxyCallback:p_dictInfo];
    };
    if ([p_signNature isEqualToString:@"SM"]) 
        l_filename = [NSString stringWithFormat:@"%@%@.jpeg", @"sosman", p_filename];
    
    if ([p_signNature isEqualToString:@"CU"]) 
        l_filename = [NSString stringWithFormat:@"%@%@.jpeg", @"socust", p_filename];
    
    [[imageProxy alloc] initWithFileName:l_filename andReturnMethod:_imageProxyCallback];
}

- (void) imageProxyCallback:(NSDictionary*) p_dict
{
    NSData *img = (NSData*) [p_dict valueForKey:@"data"];
    NSString *l_filename = (NSString*) [p_dict valueForKey:@"filename"];
    if ([[l_filename substringToIndex:6] isEqualToString:@"sosman"]) 
    {
        smsignImage.image = [UIImage imageWithData:img];
        return;
    }
    
    if ([[l_filename substringToIndex:6] isEqualToString:@"socust"]) 
    {
        givensignImage.image = [UIImage imageWithData:img];
        return;
    }
}

- (void) showSignChequeImages : (id) sender
{
    _viewImages = YES;
    [entryTV reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
}

@end
