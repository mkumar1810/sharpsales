//
//  collectionEntry.m
//  salesapi
//
//  Created by Macintosh User on 23/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "collectionEntry.h"

@implementation collectionEntry
static bool shouldScroll = true;

- (id)initWithOrientation:(UIInterfaceOrientation) p_intOrientation andCallBack:(METHODCALLBACK) p_callback andBackGround:(UIColor*) p_color
{
    self = [super initWithFrame:CGRectMake(0, 44, 1024, 1004)];
    if (self) 
    {
        [self setBackgroundColor:p_color];
        _dataentryMode = @"A";
        _collectionId = @"0";
        _intOrientation = p_intOrientation;
        _returnCallBack = p_callback;
        _viewImages = NO;
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
            noofRows = 2;
            break;
        case 1:
            noofRows = 1;
            break;
        case 2:
            noofRows = 3;
            break;
        case 3:
            noofRows = 3;
            break;
        case 4:
            if (_viewImages) 
                noofRows = 3;
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
    l_retval = 50.0f;
    if (indexPath.section==3) 
    {
        if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        {
            switch (indexPath.row) {
                case 0:
                    l_retval = 90.0f;
                    break;
                case 1:
                    l_retval = 50.0f;
                    break;
                case 2:
                    l_retval = 90.0f;
                    break;
                default:
                    break;
            }
        }
    }
    if (indexPath.section==4) 
    {
        if (_viewImages) 
        {
            l_retval = 90.0f;
            switch (indexPath.row) 
            {
                case 2:
                    l_retval = 240.0f;
                    break;
                default:
                    break;
            }
        }
    }
    return  l_retval;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataentryMode isEqualToString:@"L"]==NO) 
    {
        if (indexPath.section==0) 
            if (indexPath.row==1)
            { 
                NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"CUSTOMERSELECT",@"message", nil];
                _returnCallBack(callbackInfo);
            }
        
        if (indexPath.section==2) 
            if (indexPath.row==2) 
                if ([scPaymentMode selectedSegmentIndex]!=0) 
                {
                    NSDictionary *callbackInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"BANKSELECT",@"message", nil];
                    _returnCallBack(callbackInfo);
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
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return [self getReceiptDataCellFor:tableView];
                    break;
                case 1:
                    return [self getCustomerCellFor:tableView];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            return [self getPayModeCellFor:tableView];
            break;
        case 2:
        {
            switch (indexPath.row) 
            {
                case 0:
                    return [self getAmountCellFor:tableView];
                    break;
                case 1:
                    return [self getChequeDataCellFor:tableView];
                    break;
                case 2:
                    return [self getBankInfoCellFor:tableView];
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                    return [self getInvoiceInfoCellFor:tableView];
                    break;
                case 1:
                    return [self getGivenContactInfoCellFor:tableView];
                    break;
                case 2:
                    return [self getNotesCellFor:tableView];
                    break;
                default:
                    break;
            }
        }
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
                    case 2:
                        return [self getChequeCaptureCellFor:tableView];
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

- (UITableViewCell*) getChequeCaptureCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellChequePhoto";
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
    
    labelHeight = 240;
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
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Cheque"];
        chequePhoto = [[UIImageView alloc] initWithFrame:reqFrame];
        chequePhoto.tag = 101;
        [cell.contentView addSubview:chequePhoto];
        if ([txtReceiptNo.text isEqualToString:@""]==NO) 
        {
            //NSURL *urlPath;
            NSArray *receiptno = [txtReceiptNo.text componentsSeparatedByString:@" / "];
            [self setImageFromServer:[receiptno objectAtIndex:0] forType:@"CHQ"];
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
        btncalender.titleLabel.text=@"CHEQUE";
        btncalender.tag = 104;
        [btncalender setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalender addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btncalender];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    chequePhoto = (UIImageView*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    lbltitle = (UILabel*) [cell.contentView viewWithTag:103];
    btncalender = (UIButton*) [cell.contentView viewWithTag:104];
    [chequePhoto setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    [lbltitle setFrame:titleFrame];
    [btncalender setFrame:btnFrame];
    if ([_dataentryMode isEqualToString:@"L"])  
        btncalender.enabled = NO;
    else
        btncalender.enabled = YES;
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
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Given By Sign"];
        givensignImage = [[UIImageView alloc] initWithFrame:reqFrame];
        givensignImage.tag = 101;
        [cell.contentView addSubview:givensignImage];
        if ([txtReceiptNo.text isEqualToString:@""]==NO) 
        {
            //NSURL *urlPath;
            NSArray *receiptno = [txtReceiptNo.text componentsSeparatedByString:@" / "];
            [self setImageFromServer:[receiptno objectAtIndex:0] forType:@"GB"];
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
        btncalender.titleLabel.text=@"GBSIGN";
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
        if ([txtReceiptNo.text isEqualToString:@""]==NO) 
        {
            //NSURL *urlPath;
            NSArray *receiptno = [txtReceiptNo.text componentsSeparatedByString:@" / "];
            [self setImageFromServer:[receiptno objectAtIndex:0] forType:@"SM"];
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

- (UITableViewCell*) getNotesCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellNotes";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame,titleFrame;
    
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        labelHeight = 90;
    reqFrame = CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    titleFrame = CGRectMake(4, 1, labelWidth, labelHeight-2);
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];                    
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Notes"];
        txtRemarks = [[UITextField alloc] initWithFrame:reqFrame]; 
        txtRemarks.text = @"";
        txtRemarks.font =reqfont;
        txtRemarks.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtRemarks.delegate = self;
        txtRemarks.tag = 101;
        [cell.contentView addSubview:txtRemarks];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtRemarks = (UITextField*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    lbltitle = (UILabel*) [cell.contentView viewWithTag:103];
    [txtRemarks setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    [lbltitle setFrame:titleFrame];
    if ([_dataentryMode isEqualToString:@"L"])  txtRemarks.enabled = NO;
    return cell;
}

- (UITableViewCell*) getGivenContactInfoCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellGivenByContact";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider, *lblContact;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect givenByFrame, dividerFrame, contactLblFrame, contactNoFrame;
    
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    givenByFrame = CGRectMake(labelWidth+8, 0, chequeDataWidth, labelHeight);
    contactLblFrame = CGRectMake(labelWidth+8+chequeDataWidth, 0, 100, labelHeight-2);
    contactNoFrame = CGRectMake(labelWidth+8+chequeDataWidth+100, 0, chequeDataWidth-20, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Given By"];
        txtgivenby = [[UITextField alloc] initWithFrame:givenByFrame]; 
        txtgivenby.text = @"";
        txtgivenby.font =reqfont;
        txtgivenby.delegate = self;
        txtgivenby.tag = 101;
        txtgivenby.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtgivenby];
        lblContact = [[UILabel alloc] initWithFrame:contactLblFrame];
        lblContact.text = @"Contact#";
        lblContact.font = reqfont;
        lblContact.textAlignment = UITextAlignmentLeft;
        [lblContact setBackgroundColor:[UIColor whiteColor]];
        lblContact.tag = 102;
        [cell.contentView addSubview:lblContact];
        txtcontactno = [[UITextField alloc] initWithFrame:contactNoFrame];
        txtcontactno.text = @"";
        txtcontactno.font =reqfont;
        txtcontactno.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtcontactno.delegate = self;
        txtcontactno.tag = 103;
        [txtcontactno setKeyboardType:UIKeyboardTypePhonePad];
        [cell.contentView addSubview:txtcontactno];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, 175, labelHeight-2)];
        lbltitle.font = [UIFont systemFontOfSize:18.0f];
        lbltitle.text = lblcaption;
        [lbltitle setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle];
        //[lbltitle release];
        if (dividerNeeded==YES) 
        {
            lbldivider = [[UILabel alloc] initWithFrame:dividerFrame];
            [lbldivider setBackgroundColor:[UIColor grayColor]];
            lbldivider.tag = 104;
            [cell.contentView addSubview:lbldivider];
            //[lbldivider release];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtgivenby = (UITextField*) [cell.contentView viewWithTag:101];
    lblContact = (UILabel*) [cell.contentView viewWithTag:102];
    txtcontactno = (UITextField*) [cell.contentView viewWithTag:103];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:104];
    [txtgivenby setFrame:givenByFrame];
    [lblContact setFrame:contactLblFrame];
    [txtcontactno setFrame:contactNoFrame];
    [lbldivider setFrame:dividerFrame];
    if ([_dataentryMode isEqualToString:@"L"])  txtgivenby.enabled = NO;
    if ([_dataentryMode isEqualToString:@"L"])  txtcontactno.enabled = NO;
    return cell;
}

- (UITableViewCell*) getInvoiceInfoCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellInvoiceInfo";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame, titleFrame;
    
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        labelHeight = 90;
    reqFrame = CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    titleFrame = CGRectMake(4, 1, labelWidth, labelHeight-2);
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Invoice Nos"];
        txtInvoiceNo = [[UITextField alloc] initWithFrame:reqFrame]; 
        txtInvoiceNo.text = @"";
        txtInvoiceNo.font =reqfont;
        txtInvoiceNo.delegate = self;
        txtInvoiceNo.tag = 101;
        txtInvoiceNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [txtInvoiceNo setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:txtInvoiceNo];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtInvoiceNo = (UITextField*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    lbltitle = (UILabel*) [cell.contentView viewWithTag:103];
    [txtInvoiceNo setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    [lbltitle setFrame:titleFrame];
    if ([_dataentryMode isEqualToString:@"L"])  txtInvoiceNo.enabled = NO;
    return cell;
}

- (UITableViewCell*) getBankInfoCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellBankInfo";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame;
    
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    reqFrame = CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Bank Name"];
        txtBankName = [[UITextField alloc] initWithFrame:reqFrame]; 
        txtBankName.text = @"";
        txtBankName.enabled = NO;
        txtBankName.font =reqfont;
        txtBankName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtBankName.placeholder = @"(Select Bank....)";
        txtBankName.tag = 101;
        [cell.contentView addSubview:txtBankName];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, 175, labelHeight-2)];
        lbltitle.font = reqfont;
        lbltitle.text = lblcaption;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtBankName = (UITextField*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    [txtBankName setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    if ([_dataentryMode isEqualToString:@"L"]) 
        cell.accessoryType = UITableViewCellAccessoryNone;
    else
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell*) getChequeDataCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellChequeData";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider, *lblchequedate;
    UIButton *btncalender;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect chqNoFrame, chqDtFrame, dividerFrame, btnFrame, chqDtLblFrame;
    
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    chqNoFrame = CGRectMake(labelWidth+8, 0, chequeDataWidth, labelHeight);
    chqDtLblFrame = CGRectMake(labelWidth+8+chequeDataWidth, 0, 100, labelHeight-2);
    chqDtFrame = CGRectMake(labelWidth+8+chequeDataWidth+100, 0, chequeDataWidth-50, labelHeight);
    btnFrame = CGRectMake(labelWidth+8+2*chequeDataWidth, 0, 30, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Cheque No"];
        txtChequeNo = [[UITextField alloc] initWithFrame:chqNoFrame];
        txtChequeNo.text = @"";
        txtChequeNo.font =reqfont;
        txtChequeNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [txtChequeNo setKeyboardType:UIKeyboardTypeNumberPad];
        txtChequeNo.delegate = self;
        txtChequeNo.tag = 101;
        [cell.contentView addSubview:txtChequeNo];
        lblchequedate = [[UILabel alloc] initWithFrame:chqDtLblFrame];
        lblchequedate.text = @"Dated";
        lblchequedate.font = reqfont;
        lblchequedate.textAlignment = UITextAlignmentLeft;
        [lblchequedate setBackgroundColor:[UIColor whiteColor]];
        lblchequedate.tag = 102;
        [cell.contentView addSubview:lblchequedate];
        txtChequedate = [[UITextField alloc] initWithFrame:chqDtFrame];
        txtChequedate.text = @"";
        txtChequedate.font =reqfont;
        txtChequedate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtChequedate.delegate = self;
        txtChequedate.enabled = NO;
        txtChequedate.tag= 103;
        [cell.contentView addSubview:txtChequedate];
        btncalender = [[UIButton alloc] initWithFrame:btnFrame];
        btncalender.titleLabel.text=@"CHQDT";
        btncalender.tag = 104;
        [btncalender setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalender addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btncalender];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, 175, labelHeight-2)];
        lbltitle.font = reqfont;
        lbltitle.text = lblcaption;
        [lbltitle setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle];
        //[lbltitle release];
        if (dividerNeeded==YES) 
        {
            lbldivider = [[UILabel alloc] initWithFrame:dividerFrame];
            [lbldivider setBackgroundColor:[UIColor grayColor]];
            lbldivider.tag = 105;
            [cell.contentView addSubview:lbldivider];
            //[lbldivider release];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtChequeNo = (UITextField*) [cell.contentView viewWithTag:101];
    lblchequedate = (UILabel*) [cell.contentView viewWithTag:102];
    txtChequedate = (UITextField*) [cell.contentView viewWithTag:103];
    btncalender = (UIButton*) [cell.contentView viewWithTag:104];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:105];
    [txtChequeNo setFrame:chqNoFrame];
    [lblchequedate setFrame:chqDtLblFrame];
    [txtChequedate setFrame:chqDtFrame];
    [btncalender setFrame:btnFrame];
    [lbldivider setFrame:dividerFrame];
    
    if ([_dataentryMode isEqualToString:@"L"])  
        txtChequeNo.enabled = NO;
    else
    {
        if ([scPaymentMode selectedSegmentIndex]==0) 
            txtChequeNo.enabled = NO;
        else
            txtChequeNo.enabled = YES;
    }
    if ([_dataentryMode isEqualToString:@"L"])  
        btncalender.enabled = NO;
    else
        btncalender.enabled = YES;
    return cell;
}

- (UITableViewCell*) getAmountCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellAmount";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame;
    
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    reqFrame = CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Amount"];
        txtAmount = [[UITextField alloc] initWithFrame:reqFrame]; 
        txtAmount.text = @"";
        txtAmount.font =reqfont;
        txtAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtAmount.delegate = self;
        txtAmount.tag = 101;
        [txtAmount setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:txtAmount];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, 175, labelHeight-2)];
        lbltitle.font = [UIFont systemFontOfSize:18.0f];
        lbltitle.text = lblcaption;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtAmount = (UITextField*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    [txtAmount setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    if ([_dataentryMode isEqualToString:@"L"])  txtAmount.enabled = NO;
    return cell;
    
}

- (UITableViewCell*) getPayModeCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellPayMode";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame;
    
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 705;
        chequeDataWidth = 323;
    }
    reqFrame = CGRectMake(labelWidth+6, 0, dataEntryWidth-5, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Payment Mode"];
        NSArray *itemArray = [NSArray arrayWithObjects: @"Cash", @"Cheque", @"PDC", nil];
        scPaymentMode = [[UISegmentedControl alloc] initWithItems:itemArray];
        [scPaymentMode setFrame:reqFrame];
        scPaymentMode.segmentedControlStyle = UISegmentedControlStylePlain;
        scPaymentMode.tag =101;
        scPaymentMode.selectedSegmentIndex = 0;
        [scPaymentMode addTarget:self action:@selector(payModeSelected:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:scPaymentMode];
        dividerNeeded=NO;
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, 175, labelHeight-2)];
        lbltitle.font = reqfont;
        lbltitle.text = lblcaption;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    scPaymentMode = (UISegmentedControl*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    [scPaymentMode setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    if ([_dataentryMode isEqualToString:@"L"])  
        scPaymentMode.enabled = NO;
    else
        scPaymentMode.enabled = YES;
    return cell;
}

- (UITableViewCell*) getCustomerCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellCustomerData";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame, titleFrame;
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    reqFrame = CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    titleFrame = CGRectMake(4, 1, labelWidth, labelHeight-2);
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Customer"];
        txtCust = [[UITextField alloc] initWithFrame:reqFrame]; 
        txtCust.text = @"";
        txtCust.enabled = NO;
        txtCust.delegate = self;
        txtCust.placeholder = @"(Select Customer....)";
        txtCust.font =reqfont;
        txtCust.tag = 101;
        txtCust.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtCust];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtCust = (UITextField*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    lbltitle = (UILabel*) [cell.contentView viewWithTag:103];
    [txtCust setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    [lbltitle setFrame:titleFrame];
    if ([_dataentryMode isEqualToString:@"L"]) 
        cell.accessoryType = UITableViewCellAccessoryNone;
    else
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell*) getReceiptDataCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellReceiptData";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    CGRect reqFrame, dividerFrame, titleFrame;
    if (UIInterfaceOrientationIsLandscape(_intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    titleFrame = CGRectMake(4, 1, labelWidth, labelHeight-2);
    reqFrame = CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight);
    dividerFrame = CGRectMake(labelWidth+4, 0, 2, labelHeight);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Receipt No"];
        txtReceiptNo = [[UITextField alloc] initWithFrame:reqFrame]; 
        txtReceiptNo.text = @"";
        txtReceiptNo.placeholder = @"(Auto Generated)";
        txtReceiptNo.enabled = NO;
        txtReceiptNo.font =reqfont;
        txtReceiptNo.delegate = self;
        txtReceiptNo.tag = 101;
        txtReceiptNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtReceiptNo];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    txtReceiptNo = (UITextField*) [cell.contentView viewWithTag:101];
    lbldivider = (UILabel*) [cell.contentView viewWithTag:102];
    lbltitle = (UILabel*) [cell.contentView viewWithTag:103];
    [txtReceiptNo setFrame:reqFrame];
    [lbldivider setFrame:dividerFrame];
    [lbltitle setFrame:titleFrame];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    shouldScroll = true;
    [self setContentOffset:scrollOffset animated:NO]; 
    if ([textField isEqual:txtReceiptNo]) 
        [txtCust becomeFirstResponder];
    else if([textField isEqual:txtCust])
        [txtAmount becomeFirstResponder];
    else if ([textField isEqual:txtAmount])
		[txtChequeNo becomeFirstResponder];
    else if ([textField isEqual:txtChequeNo])
		[txtChequeNo resignFirstResponder];
    else if([textField isEqual:txtInvoiceNo])
        [txtgivenby becomeFirstResponder];
    else if([textField isEqual:txtgivenby])
        [txtcontactno becomeFirstResponder];
    else if([textField isEqual:txtcontactno])
        [txtRemarks becomeFirstResponder];
    else if([textField isEqual:txtRemarks])
        [textField resignFirstResponder];
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (shouldScroll) 
    {
        scrollOffset = self.contentOffset;
        CGPoint scrollPoint;
        CGRect inputFieldBounds = [textField bounds];
        inputFieldBounds = [textField convertRect:inputFieldBounds toView:self];
        scrollPoint =  self.bounds.origin; 
        scrollPoint.x = 0;
        if (UIInterfaceOrientationIsPortrait(_intOrientation)) 
        {
            if ([textField isEqual:txtInvoiceNo]) 
                scrollPoint.y = 80;
            else if ([textField isEqual:txtgivenby])
                scrollPoint.y = 170;
            else if ([textField isEqual:txtcontactno])
                scrollPoint.y = 170;
            else if ([textField isEqual:txtRemarks])
                scrollPoint.y = 220;
            else
                scrollPoint.y=0;
        }
        else
        {
            if ([textField isEqual:txtChequeNo]) 
                scrollPoint.y = 80;
            else if ([textField isEqual:txtInvoiceNo]) 
                scrollPoint.y = 180;
            else if ([textField isEqual:txtgivenby])
                scrollPoint.y = 230;
            else if ([textField isEqual:txtcontactno])
                scrollPoint.y = 230;
            else if ([textField isEqual:txtRemarks])
                scrollPoint.y = 280;
            else
                scrollPoint.y=0;
            
        }
        [self setContentOffset:scrollPoint animated:NO];  
        shouldScroll = false;
    }
}

- (void) showSignChequeImages : (id) sender
{
    _viewImages = YES;
    [entryTV reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) setCustomerInformation :(NSDictionary*) p_custInfo
{
    if (p_custInfo) 
    {
        if (txtCust) 
            txtCust.text = [[NSString alloc] initWithFormat:@"%@ - %@", [p_custInfo valueForKey:@"CD"], [p_custInfo valueForKey:@"CN"]];
    }
}

- (IBAction) payModeSelected:(id)sender
{
    int selPayMode = [scPaymentMode selectedSegmentIndex];
    if (selPayMode==0) 
    {
        txtChequeNo.text = [[NSString alloc] initWithFormat:@"%@",@""];
        txtChequedate.text = [[NSString alloc] initWithFormat:@"%@",@""];
        txtBankName.text = [[NSString alloc] initWithFormat:@"%@",@""];
        txtChequeNo.enabled = NO;
    }
    else
    {
        txtChequeNo.enabled = YES;
    }
}

- (IBAction) displayCalendar:(id) sender
{
    UIButton *btnsender = (UIButton*) sender;
    if ([_dataentryMode isEqualToString:@"L"]) return;
    
    if ([btnsender.titleLabel.text isEqualToString:@"CHQDT"]) 
    {
        if ([scPaymentMode selectedSegmentIndex] == 0 ) return;
        dobPicker = [[UIDatePicker alloc] init];
        dobPicker.frame=CGRectMake(20, 25.0, 240.0, 150.0);
        dobPicker.datePickerMode = UIDatePickerModeDate;
        
        [dobPicker setDate:[NSDate date]];
        dAlert = [[UIAlertView alloc] initWithTitle:@"Pick a date" message:@"\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select", nil];
        dAlert.cancelButtonIndex = 0;
        dAlert.delegate = self;
        dAlert.tag = 0;
        [dAlert addSubview:dobPicker];
        [dAlert show];
    }
    
    if ([btnsender.titleLabel.text isEqualToString:@"SMSIGN"]) 
    {
        NSMutableDictionary *callbackInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"SMSIGNSELECT",@"message", nil];
        [callbackInfo setValue:smsignImage.image forKey:@"currimage"];
        _returnCallBack(callbackInfo);
        return;
    }
    
    if ([btnsender.titleLabel.text isEqualToString:@"GBSIGN"]) 
    {
        NSMutableDictionary *callbackInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"GBSIGNSELECT",@"message", nil];
        [callbackInfo setValue:givensignImage.image forKey:@"currimage"];
        _returnCallBack(callbackInfo);
        return;
    }

    if ([btnsender.titleLabel.text isEqualToString:@"CHEQUE"]) 
    {
        NSMutableDictionary *callbackInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"CHEQUESELECT",@"message", nil];
        _returnCallBack(callbackInfo);
        return;
    }
    
}

- (void) setChequeImage:(UIImage*) p_chequeImage
{
    if (p_chequeImage) 
    {
        /*UIGraphicsBeginImageContext(chequePhoto.frame.size);
        
        // Tell the old image to draw in this new context, with the desired
        // new size
        [p_chequeImage drawInRect:CGRectMake(0,0,chequePhoto.frame.size.width,chequePhoto.frame.size.height)];
        
        // Get the new image from the context
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // End the context
        UIGraphicsEndImageContext();
        
        // Return the new image.
        chequePhoto.image = newImage;*/
        chequePhoto.image = p_chequeImage;
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    if (alertView.tag ==1) 
    {
        //CGRect alertFrame = alertView.frame;
        /*alertView.frame = CGRectMake(CGRectGetMinX(alertView.frame) - (370 - CGRectGetWidth(alertView.frame))/2 , 
                                     alertView.frame.origin.y, 
                                     370, 
                                     signcapture.view.frame.size.height + 120);        
        for( UIView *view in alertView.subviews)
        {
            if([[view class] isSubclassOfClass:[UIButton class]])
            {
                UIButton *l_btn = (UIButton*) view;
                if ([l_btn.titleLabel.text isEqualToString:@"Cancel"]) 
                    view.frame = CGRectMake   (signcapture.view.frame.origin.x +2,
                                               signcapture.view.frame.origin.y + signcapture.view.frame.size.height + 10,
                                               (signcapture.view.frame.size.width-4)/2,
                                               view.frame.size.height);
                else
                    view.frame = CGRectMake   (signcapture.view.frame.size.width+signcapture.view.frame.origin.x-(signcapture.view.frame.size.width-4)/2,
                                               signcapture.view.frame.origin.y + signcapture.view.frame.size.height + 10,
                                               (signcapture.view.frame.size.width-4)/2,
                                               view.frame.size.height);
                    
            }
        }      */
        //[alertView setFrame:CGRectMake(alertFrame.origin.x - 50 , alertFrame.origin.y, 340.0, 160.0)];
        //alertView.frame = CGRectMake(5.f, 1.f, 100.f, 200.f);
    }
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
        
        if ([p_signType isEqualToString:@"GB"]) 
        {
            [givensignImage setImage:img];
            return;
        }
        
        if ([p_signType isEqualToString:@"CHQ"]) 
        {
            [chequePhoto setImage:img];
            return;
        }
    }
}

- (void) setBankValues:(NSDictionary*) p_bankInfo
{
    if (p_bankInfo) 
    {
        if (txtBankName) 
            txtBankName.text = [[NSString alloc] initWithFormat:@"%@ - %@",[p_bankInfo valueForKey:@"BANKCODE"], [p_bankInfo valueForKey:@"BANKNAME"]];
    }
}

- (NSDictionary*) validateData
{
    NSDictionary *returnDict;
    if ([txtCust.text isEqualToString:@""]) 
    {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Please Select a valid customer",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    if ([txtAmount.text isEqualToString:@""]) 
    {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Enter a valid amount",@"RESPONSEMESSAGE"  , nil];
        return returnDict;
    }
    if ([scPaymentMode selectedSegmentIndex]!=0) 
    {
        if ([txtChequeNo.text isEqualToString:@""]) 
        {
            returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"enter a valid cheque no",@"RESPONSEMESSAGE"  , nil];
            return returnDict;
        }
        if ([txtChequedate.text isEqualToString:@""]) 
        {
            returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Select a valid cheque date",@"RESPONSEMESSAGE"  , nil];
            return returnDict;
        }
        if ([txtBankName.text isEqualToString:@""]) 
        {
            returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"RESPONSECODE",@"Select a valid bank name",@"RESPONSEMESSAGE"  , nil];
            return returnDict;
        }
    }
    
    returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"RESPONSECODE",@"Successfully Validated",@"RESPONSEMESSAGE"  , nil];
    return returnDict;
}

- (NSString*) getXMLForPosting
{
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];
    NSString *l_bankcode, *l_custcode;
    NSRange l_custcoderange = [txtCust.text rangeOfString:@" - "];
    l_custcode = [txtCust.text substringToIndex:l_custcoderange.location];
    if ([scPaymentMode selectedSegmentIndex]!=0) 
    {
        NSRange l_bankcoderange = [txtBankName.text rangeOfString:@" - "];
        l_bankcode = [txtBankName.text substringToIndex:l_bankcoderange.location];
    }
    else
        l_bankcode = @"";
    
    if ([_dataentryMode isEqualToString:@"A"])
        l_retXML = [NSString stringWithFormat:colnDataXML, @"0",l_custcode, txtAmount.text, [scPaymentMode selectedSegmentIndex] , txtChequeNo.text, txtChequedate.text, l_bankcode, txtInvoiceNo.text, txtRemarks.text,[standardUserDefaults valueForKey:@"loggeduser"] , txtgivenby.text, txtcontactno.text];
    else
        l_retXML = [NSString stringWithFormat:colnDataXML, _collectionId,l_custcode, txtAmount.text, [scPaymentMode selectedSegmentIndex] , txtChequeNo.text, txtChequedate.text, l_bankcode, txtInvoiceNo.text, txtRemarks.text,[standardUserDefaults valueForKey:@"loggeduser"] , txtgivenby.text, txtcontactno.text];
    l_retXML = [NSString stringWithFormat:@"%@%@%@",@"<COLNDATA>",l_retXML, @"</COLNDATA>"];
    return l_retXML;
}

- (NSString*) setAfterSaveOptions:(NSDictionary*) p_saveResult
{
    //[self setViewListMode];
    //NSLog(@"the data entry mode is %@", _dataentryMode);
    if ([_dataentryMode isEqualToString:@"A"]) 
    {
        NSString *recptno = [[NSString alloc] initWithFormat:@"%@ / %@",[p_saveResult valueForKey:@"RECEIPTNO"],[p_saveResult valueForKey:@"RECEIPTDATE"]];
        txtReceiptNo.text = recptno;
        _collectionId = [p_saveResult valueForKey:@"COLLECTIONID"];
        return @"New Collection Entry Added";
    }
    else
        return @"Collection Entry details updated";
    return nil;
}

- (void) setViewListMode
{
    _dataentryMode = @"L";
    txtReceiptNo.enabled = NO;
    scPaymentMode.enabled = NO;
    txtAmount.enabled = NO;
    txtChequeNo.enabled = NO;
    txtInvoiceNo.enabled = NO;
    txtgivenby.enabled = NO;
    txtcontactno.enabled = NO;
    txtRemarks.enabled = NO;
}

- (void) setEditMode
{
    _dataentryMode = @"E";
    [self showSignChequeImages:nil];
    [entryTV reloadData];
    txtReceiptNo.enabled = YES;
    scPaymentMode.enabled =YES;
    txtAmount.enabled = YES;
    if (scPaymentMode.selectedSegmentIndex !=0) 
        txtChequeNo.enabled = YES;
    else
        txtInvoiceNo.enabled = NO;
    txtgivenby.enabled = YES;
    txtcontactno.enabled = YES;
    txtRemarks.enabled = YES;
    [entryTV selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:4] animated:NO scrollPosition:UITableViewScrollPositionBottom];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) 
    {
        NSDate *date = [dobPicker date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:(NSString*) @"dd-MMM-yyyy"];
        txtChequedate.text = [dateFormatter stringFromDate:date];
    }
}

- (NSString*) getCurrentMode
{
    return _dataentryMode;
}

- (NSString*) getCollectionId
{
    return _collectionId;
}

- (void) setDataForDisplay:(NSDictionary*) p_dict
{
    [self setViewListMode];
    _displayDict = [NSDictionary dictionaryWithDictionary:p_dict];
    [self displayDictValues];
}

- (void) displayDictValues
{
    //NSURL *urlPath;
    _collectionId = [_displayDict valueForKey:@"COLLECTIONID"];
    NSString *recptno = [[NSString alloc] initWithFormat:@"%@ / %@",[_displayDict valueForKey:@"RECEIPTNO"],[_displayDict valueForKey:@"RECEIPTDATE"]];
    txtReceiptNo.text = recptno;
    txtCust.text = [[NSString alloc] initWithFormat:@"%@ - %@", [_displayDict valueForKey:@"CUSTOMERCODE"], [_displayDict valueForKey:@"CUSTOMERNAME"]];
    scPaymentMode.selectedSegmentIndex = [[_displayDict valueForKey:@"MODEOFPAYMENT"] intValue];
    txtAmount.text = [_displayDict valueForKey:@"AMOUNT"];
    if (scPaymentMode.selectedSegmentIndex != 0) 
    {
        txtChequeNo.text = [_displayDict valueForKey:@"CHEQUENO"];
        txtChequedate.text = [_displayDict valueForKey:@"CHEQUEDATE"];
        txtBankName.text = [[NSString alloc] initWithFormat:@"%@ - %@",[_displayDict valueForKey:@"BANKCODE"], [_displayDict valueForKey:@"BANKNAME"]];
    }
    else
    {
        txtChequeNo.text = @"";
        txtChequedate.text = @"";
        txtBankName.text = @"";
    }
    if ([_displayDict valueForKey:@"INVOICENO"]) 
        txtInvoiceNo.text = [_displayDict valueForKey:@"INVOICENO"];
    else
        txtInvoiceNo.text = @"";
    if ([_displayDict valueForKey:@"GIVENBY"]) 
        txtgivenby.text = [_displayDict valueForKey:@"GIVENBY"];
    else
        txtgivenby.text = @"";
    if ([_displayDict valueForKey:@"CONTACTNO"]) 
        txtcontactno.text = [_displayDict valueForKey:@"CONTACTNO"];
    else
        txtcontactno.text = @"";
    if ([_displayDict valueForKey:@"REMARKS"]) 
        txtRemarks.text = [_displayDict valueForKey:@"REMARKS"];
    else
        txtRemarks.text = @"";
    
    //urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/Images/csgn%@.jpeg",MAIN_URL, WS_ENV, [_displayDict valueForKey:@"RECEIPTNO"]]];
    //NSLog(@"url path is %@", urlPath);
    if (_viewImages) 
    {
        NSArray *receiptno = [txtReceiptNo.text componentsSeparatedByString:@" / "];
        [self setImageFromServer:[receiptno objectAtIndex:0] forType:@"SM"];
        [self setImageFromServer:[receiptno objectAtIndex:0] forType:@"GB"];
        [self setImageFromServer:[receiptno objectAtIndex:0] forType:@"CHQ"];
    }
    //signImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPath]];
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
    
    if ([p_imgType isEqualToString:@"GB"]) 
    {
        //UIImageWriteToSavedPhotosAlbum(givensignImage.image, nil, nil, nil);
        dataObj = UIImagePNGRepresentation(givensignImage.image);
    }
    
    if ([p_imgType isEqualToString:@"CHQ"]) 
    {
        //UIImageWriteToSavedPhotosAlbum(chequePhoto.image, nil, nil, nil);
        dataObj = UIImagePNGRepresentation(chequePhoto.image);
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
        l_filename = [NSString stringWithFormat:@"%@%@.jpeg", @"csmsgn", p_filename];
    /*else
        return;*/
    
    if ([p_signNature isEqualToString:@"GB"]) 
        l_filename = [NSString stringWithFormat:@"%@%@.jpeg", @"cgbsgn", p_filename];
    
    if ([p_signNature isEqualToString:@"CHQ"]) 
        l_filename = [NSString stringWithFormat:@"%@%@.jpeg", @"cchq", p_filename];

    [[imageProxy alloc] initWithFileName:l_filename andReturnMethod:_imageProxyCallback];
}

- (void) imageProxyCallback:(NSDictionary*) p_dict
{
    NSData *img = (NSData*) [p_dict valueForKey:@"data"];
    //NSString *imgStr = (NSString*) [p_dict valueForKey:@"data"];
    NSString *l_filename = (NSString*) [p_dict valueForKey:@"filename"];
    //NSLog(@"the image string is %@", imgStr);
    //Base64 *bb = [[Base64 alloc] init];
    if ([[l_filename substringToIndex:6] isEqualToString:@"csmsgn"]) 
    {
        
        //NSData *actData = [bb decode:imgStr];
        smsignImage.image = [UIImage imageWithData:img];
        //smsignImage.image = [UIImage imageWithData:actData];
        return;
    }

    if ([[l_filename substringToIndex:6] isEqualToString:@"cgbsgn"]) 
    {
        givensignImage.image = [UIImage imageWithData:img];
        return;
    }
    
    if ([[l_filename substringToIndex:4] isEqualToString:@"cchq"]) 
    {
        chequePhoto.image = [UIImage imageWithData:img];
        return;
    }
    
}

@end
