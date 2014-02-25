//
//  colnDataObjects.m
//  salesapi
//
//  Created by Raja T S Sekhar on 4/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "colnDataObjects.h"


@implementation colnDataObjects
static bool shouldScroll = true;

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode andCustSelectMethod:(METHODCALLBACK) p_custSelMethod andBankSelMethod:(METHODCALLBACK) p_bankSelMethod
{
    self = [super init];
    if (self) {
        initialFrame = frame;
        _custSelmethod = p_custSelMethod;
        _bankSelMethod = p_bankSelMethod;
        _parentScroll = p_scrollview;
        intOrientation = p_intOrientation;
        _dispMode = [[NSString alloc] initWithFormat:@"%@", p_dispmode];
        _initialData = [[NSDictionary alloc] initWithDictionary:p_dictData];
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
    [entryTV setBackgroundView:[[UIView alloc] init]];
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
    return 4;
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
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        {
            switch (indexPath.row) {
                case 0:
                    l_retval = 90.0f;
                    break;
                case 1:
                    l_retval = 50.0f;
                    break;
                /*case 2:
                    l_retval = 50.0f;
                    break;*/
                case 2:
                    l_retval = 90.0f;
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
    if ([_dispMode isEqualToString:@"L"]==NO) 
    {
        if (indexPath.section==0) 
            if (indexPath.row==1) 
                //[[NSNotificxationCenter defaultCenter] postNotifixcationName:@"selectCustomerForColn" object:self];
                _custSelmethod(nil);

        if (indexPath.section==2) 
            if (indexPath.row==2) 
                if (paymodeselected!=0) 
                    //[[NSNotificxationCenter defaultCenter] postNotixficationName:@"selectBankForColn" object:self];
                    _bankSelMethod(nil);
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
        default:
            break;
    }
    return nil;
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
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];                    
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Notes"];
        txtRemarks = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
        txtRemarks.text = @"";
        if (remarks) 
            txtRemarks.text = remarks;
        txtRemarks.font =reqfont;
        txtRemarks.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtRemarks.delegate = self;
        txtRemarks.tag = 112;
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
            labelHeight = 90;
        [cell.contentView addSubview:txtRemarks];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
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
    }
    txtRemarks = (UITextField*) [cell.contentView viewWithTag:112];
    if ([_dispMode isEqualToString:@"L"])  txtRemarks.enabled = NO;
    return cell;
}

- (UITableViewCell*) getGivenContactInfoCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellGivenByContact";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Given By"];
        txtgivenby = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, chequeDataWidth, labelHeight)]; 
        txtgivenby.text = @"";
        if (givenby) 
            txtgivenby.text = givenby;
        txtgivenby.font =reqfont;
        txtgivenby.delegate = self;
        txtgivenby.tag = 110;
        txtgivenby.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtgivenby];
        UILabel *lblchequedate = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth+8+chequeDataWidth, 0, 100, labelHeight-2)];
        lblchequedate.text = @"Contact#";
        lblchequedate.font = reqfont;
        lblchequedate.textAlignment = UITextAlignmentLeft;
        [lblchequedate setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblchequedate];
        txtcontactno = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8+chequeDataWidth+100, 0, chequeDataWidth-20, labelHeight)];
        txtcontactno.text = @"";
        if (contactno) 
            txtcontactno.text = contactno;
        txtcontactno.font =reqfont;
        txtcontactno.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtcontactno.delegate = self;
        txtcontactno.tag = 111;
        [txtcontactno setKeyboardType:UIKeyboardTypePhonePad];
        [cell.contentView addSubview:txtcontactno];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
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
    }
    txtgivenby = (UITextField*) [cell.contentView viewWithTag:110];
    txtcontactno = (UITextField*) [cell.contentView viewWithTag:111];
    if ([_dispMode isEqualToString:@"L"])  txtgivenby.enabled = NO;
    if ([_dispMode isEqualToString:@"L"])  txtcontactno.enabled = NO;
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
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Invoice Nos"];
        txtInvoiceNo = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, 90)]; 
        txtInvoiceNo.text = @"";
        if (invno) 
            txtInvoiceNo.text = invno;
        txtInvoiceNo.font =reqfont;
        txtInvoiceNo.delegate = self;
        txtInvoiceNo.tag = 109;
        txtInvoiceNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [txtInvoiceNo setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:txtInvoiceNo];
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
            labelHeight = 90;
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
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
    }
    txtInvoiceNo = (UITextField*) [cell.contentView viewWithTag:109];
    if ([_dispMode isEqualToString:@"L"])  txtInvoiceNo.enabled = NO;
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
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Bank Name"];
        txtBankName = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
        txtBankName.text = @"";
        if (bankname) 
            txtBankName.text = paymodeselected!=0? bankname: @""; 
        txtBankName.enabled = NO;
        txtBankName.font =reqfont;
        txtBankName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtBankName.placeholder = @"(Select Bank....)";
        txtBankName.tag = 108;
        [cell.contentView addSubview:txtBankName];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
        lbltitle.font = reqfont;
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
    }
    if ([_dispMode isEqualToString:@"L"]) 
        cell.accessoryType = UITableViewCellAccessoryNone;
    else
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell*) getChequeDataCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellChequeData";
    UITableViewCell  *cell = [p_tv dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle, *lbldivider;
    UIButton *btncalender;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption ;
    BOOL dividerNeeded=YES;
    int labelHeight = 50;
    int labelWidth = 175;
    int dataEntryWidth = 500;
    int chequeDataWidth = 225;
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Cheque No"];
        txtChequeNo = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, chequeDataWidth, labelHeight)];
        txtChequeNo.text = @"";
        if (chequeno) 
            txtChequeNo.text = paymodeselected!=0? chequeno: @"";
        txtChequeNo.font =reqfont;
        txtChequeNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [txtChequeNo setKeyboardType:UIKeyboardTypeNumberPad];
        txtChequeNo.delegate = self;
        txtChequeNo.tag = 105;
        [cell.contentView addSubview:txtChequeNo];
        UILabel *lblchequedate = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth+8+chequeDataWidth, 0, 100, labelHeight-2)];
        lblchequedate.text = @"Dated";
        lblchequedate.font = reqfont;
        lblchequedate.textAlignment = UITextAlignmentLeft;
        [lblchequedate setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblchequedate];
        txtChequedate = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8+chequeDataWidth+100, 0, chequeDataWidth-50, labelHeight)];
        txtChequedate.text = @"";
        if (chequeDate) 
            txtChequedate.text = paymodeselected!=0? chequeDate: @""; 
        txtChequedate.font =reqfont;
        txtChequedate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtChequedate.delegate = self;
        txtChequedate.enabled = NO;
        txtChequedate.tag= 106;
        [cell.contentView addSubview:txtChequedate];
        btncalender = [[UIButton alloc] initWithFrame:CGRectMake(labelWidth+8+2*chequeDataWidth, 0, 30, labelHeight)];
        btncalender.titleLabel.text=@"";
        btncalender.tag = 107;
        [btncalender setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalender addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btncalender];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
        lbltitle.font = reqfont;
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
    }
    txtChequeNo = (UITextField*) [cell.contentView viewWithTag:105];
    txtChequedate = (UITextField*) [cell.contentView viewWithTag:106];
    btncalender = (UIButton*) [cell.contentView viewWithTag:107];
    if ([_dispMode isEqualToString:@"L"])  txtChequeNo.enabled = NO;
    if (paymodeselected==0) txtChequeNo.enabled = NO;
    if ([_dispMode isEqualToString:@"L"])  btncalender.enabled = NO;
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
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    /*if (indexPath.section==3) 
     if (UIInterfaceOrientationIsPortrait(intOrientation)) 
     labelHeight = 90;*/
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption =[[NSString alloc] initWithFormat:@"    %@",@"Amount"];
        txtAmount = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
        txtAmount.text = @"";
        if (amount) 
            txtAmount.text = amount;
        txtAmount.font =reqfont;
        txtAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtAmount.delegate = self;
        txtAmount.tag = 104;
        [txtAmount setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:txtAmount];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
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
    }
    txtAmount = (UITextField*) [cell.contentView viewWithTag:104];
    if ([_dispMode isEqualToString:@"L"])  txtAmount.enabled = NO;
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
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
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
        [scPaymentMode setFrame:CGRectMake(labelWidth+6, 0, dataEntryWidth-5, labelHeight)];
        scPaymentMode.segmentedControlStyle = UISegmentedControlStylePlain;
        scPaymentMode.selectedSegmentIndex = paymodeselected;
        scPaymentMode.tag =103;
        [scPaymentMode addTarget:self action:@selector(payModeSelected:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:scPaymentMode];
        dividerNeeded=NO;
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
        lbltitle.font = reqfont;
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
    }
    scPaymentMode = (UISegmentedControl*) [cell.contentView viewWithTag:103];
    if ([_dispMode isEqualToString:@"L"])  scPaymentMode.enabled = NO;
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
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Customer"];
        txtCust = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
        txtCust.text = @"";
        if (custval) 
            txtCust.text = custval;
        txtCust.enabled = NO;
        txtCust.delegate = self;
        txtCust.placeholder = @"(Select Customer....)";
        txtCust.font =reqfont;
        txtCust.tag = 102;
        txtCust.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtCust];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
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
    }
    txtCust = (UITextField*) [cell.contentView viewWithTag:102];
    if ([_dispMode isEqualToString:@"L"]) 
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
    
    if (UIInterfaceOrientationIsLandscape(intOrientation)) 
    {
        labelWidth = 225;
        dataEntryWidth = 686;
        chequeDataWidth = 323;
    }
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption = [[NSString alloc] initWithFormat:@"    %@",@"Receipt No"];
        txtReceiptNo = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)]; 
        //[txtReceiptNo setFrame:CGRectMake(labelWidth+8, 0, dataEntryWidth, labelHeight)];
        txtReceiptNo.text = @"";
        if (receiptno) 
            txtReceiptNo.text = receiptno;
        txtReceiptNo.placeholder = @"(Auto Generated)";
        txtReceiptNo.enabled = NO;
        txtReceiptNo.font =reqfont;
        txtReceiptNo.delegate = self;
        txtReceiptNo.tag = 101;
        txtReceiptNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtReceiptNo];
        lblcaption = [lblcaption stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(4, 1, labelWidth, labelHeight-2)];
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
    }
    txtReceiptNo = (UITextField*) [cell.contentView viewWithTag:101];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *key;
    key =  [[NSString alloc] initWithString:@"   "];
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    return key;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    shouldScroll = true;
    [_parentScroll setContentOffset:scrollOffset animated:NO]; 
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
    if (shouldScroll) {
        scrollOffset = _parentScroll.contentOffset;
        CGPoint scrollPoint;
        CGRect inputFieldBounds = [textField bounds];
        inputFieldBounds = [textField convertRect:inputFieldBounds toView:_parentScroll];
        scrollPoint =  _parentScroll.bounds.origin; 
        scrollPoint.x = 0;
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
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
        [_parentScroll setContentOffset:scrollPoint animated:NO];  
        shouldScroll = false;
    }
}

- (void) storeDispValues
{
    if (txtReceiptNo) 
        receiptno = [[NSString alloc] initWithFormat:@"%@", txtReceiptNo.text];
    
    if (txtCust) 
        custval = [[NSString alloc] initWithFormat:@"%@", txtCust.text];
    
    if (txtAmount) 
        amount = [[NSString alloc] initWithFormat:@"%@", txtAmount.text];
    
    if (txtChequeNo) 
        chequeno = [[NSString alloc] initWithFormat:@"%@", txtChequeNo.text];
    
    if (txtChequedate) 
        chequeDate = [[NSString alloc] initWithFormat:@"%@", txtChequedate.text];
    
    if (txtBankName) 
        bankname = [[NSString alloc] initWithFormat:@"%@", txtBankName.text];
    
    if (txtInvoiceNo) 
        invno = [[NSString alloc] initWithFormat:@"%@", txtInvoiceNo.text];

    if (txtgivenby) 
        givenby = [[NSString alloc] initWithFormat:@"%@",txtgivenby.text];
    
    if (txtcontactno) 
        contactno = [[NSString alloc] initWithFormat:@"%@",txtcontactno.text];

    if (txtRemarks) 
        remarks = [[NSString alloc] initWithFormat:@"%@", txtRemarks.text];
    
    
    if (scPaymentMode) 
        paymodeselected = scPaymentMode.selectedSegmentIndex  ;
    /*else
        paymodeselected = 0;*/
    
}

- (void) setCustomerValues:(NSDictionary*) custInfo
{
    if (custInfo) {
        if (txtCust) 
        {
            selcustCode = [[NSString alloc] initWithFormat:@"%@", [custInfo valueForKey:@"CD"]];
            txtCust.text = [[NSString alloc] initWithFormat:@"%@ - %@", [custInfo valueForKey:@"CD"], [custInfo valueForKey:@"CN"]];
        }
        else
            selcustCode = [[NSString alloc] initWithFormat:@"%@",""];
    }
}

- (void) setBankValues:(NSDictionary*) bankInfo
{
    if (bankInfo) {
        if (txtBankName) 
        {
            selBankCode = [[NSString alloc] initWithFormat:@"%@", [bankInfo valueForKey:@"BANKCODE"]];
            txtBankName.text = [[NSString alloc] initWithFormat:@"%@", [bankInfo valueForKey:@"BANKNAME"]];
        }
        else
            selBankCode = [[NSString alloc] initWithFormat:@"%@",""];
    }
}


- (void) setReceiptNo:(NSString*) newReceiptNo
{
    if (newReceiptNo) {
        txtReceiptNo.text = newReceiptNo;
        receiptno = newReceiptNo;
    }
}

- (NSDictionary*) getEnteredDetails
{
    ;
    [self storeDispValues];
    if ([_dispMode isEqualToString:@"A"])
    {
        NSDictionary *entDetails = [[NSDictionary alloc] initWithObjectsAndKeys:selcustCode,@"p_custcode",amount,@"p_amount",[NSString stringWithFormat:@"%d",paymodeselected],@"p_paymode",chequeno,@"p_chequeno",selBankCode, @"p_bankcode", invno, @"p_invoiceno", remarks,@"p_remarks" , chequeDate, @"p_chequedate",givenby,@"p_givenby",contactno,@"p_contactno", nil];
        return entDetails;
    }
    else
    {
        NSDictionary *entDetails = [[NSDictionary alloc] initWithObjectsAndKeys:selcustCode,@"p_custcode",amount,@"p_amount",[NSString stringWithFormat:@"%d",paymodeselected],@"p_paymode",chequeno,@"p_chequeno",selBankCode, @"p_bankcode", invno, @"p_invoiceno", remarks,@"p_remarks",collectionid, @"p_collectionid" ,chequeDate, @"p_chequedate",givenby,@"p_givenby",contactno,@"p_contactno", nil];
        return entDetails;
    }
    return nil;
}

- (void) displayDictDataForMode:(NSString*) p_dispmode
{
    _dispMode = [[NSString alloc] initWithFormat:@"%@", p_dispmode];
    if ([p_dispmode isEqualToString:@"L"] | [p_dispmode isEqualToString:@"E"]) 
    {
        //NSLog(@"received data dict %@",_initialData);
        collectionid = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"COLLECTIONID"]];
        receiptno = [[NSString alloc] initWithFormat:@"%@ / %@",[_initialData valueForKey:@"RECEIPTNO"],[_initialData valueForKey:@"RECEIPTDATE"]];
        custval = [[NSString alloc] initWithFormat:@"%@ - %@", [_initialData valueForKey:@"CUSTOMERCODE"], [_initialData valueForKey:@"CUSTOMERNAME"]];
        selcustCode = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"CUSTOMERCODE"]];
        amount = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"AMOUNT"]];
        chequeno = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"CHEQUENO"]];
        chequeDate = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"CHEQUEDATE"]];
        bankname = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"BANKNAME"]];
        selBankCode = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"BANKCODE"]]; 
        invno = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"INVOICENO"]];
        givenby = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"GIVENBY"]];
        contactno = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"CONTACTNO"]];
        remarks = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"REMARKS"]];
        paymodeselected = [[[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"MODEOFPAYMENT"]] integerValue];
        
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
    if (paymodeselected>0) 
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if ([textField isEqual:txtChequeNo]) 
        return (newLength > 20) ? NO : YES;
    return (newLength > 255) ? NO : YES;
}

- (void) setEditMode
{
    _dispMode = @"E";
    [self generateTableView];
}

- (IBAction) displayCalendar:(id) sender
{
    if (paymodeselected==0) return;
    dobPicker = [[UIDatePicker alloc] init];
    dobPicker.frame=CGRectMake(20, 25.0, 240.0, 150.0);
    dobPicker.datePickerMode = UIDatePickerModeDate;
    
    [dobPicker setDate:[NSDate date]];
    
    dAlert = [[UIAlertView alloc] initWithTitle:@"Pick a date" message:@"\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select", nil];
    dAlert.cancelButtonIndex = 0;
    dAlert.delegate = self;
    [dAlert addSubview:dobPicker];
    [dAlert show];
    //[dAlert release];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) 
    {
        NSDate *date = [dobPicker date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:(NSString*) @"dd-MMM-yyyy"];
        txtChequedate.text = [dateFormatter stringFromDate:date];
        chequeDate = [[NSString alloc] initWithFormat:@"%@", txtChequedate.text];
    }
}

- (void) changeModetoView
{
    _dispMode= [[NSString alloc] initWithFormat:@"%@",@"L"];
    [self generateTableView];
}

- (NSString*) getXMLForPosting
{
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];
    [self storeDispValues];
    if ([_dispMode isEqualToString:@"A"]) 
        l_retXML = [NSString stringWithFormat:colnDataXML, @"0",selcustCode, amount, paymodeselected, chequeno, chequeDate, selBankCode, invno, remarks,[standardUserDefaults valueForKey:@"loggeduser"] , givenby, contactno];
    else
        l_retXML = [NSString stringWithFormat:colnDataXML, collectionid,selcustCode, amount, paymodeselected, chequeno, chequeDate, selBankCode, invno, remarks,[standardUserDefaults valueForKey:@"loggeduser"] , givenby, contactno];
    l_retXML = [NSString stringWithFormat:@"%@%@%@",@"<COLNDATA>",l_retXML, @"</COLNDATA>"];
    //sNSLog(@"xml result %@", l_retXML);
    return l_retXML;
}

- (IBAction) payModeSelected:(id)sender
{
    UISegmentedControl *tmpscntrl = (UISegmentedControl*) sender;
    int selPayMode = [tmpscntrl selectedSegmentIndex];
    paymodeselected = selPayMode;
    if (selPayMode==0) 
    {
        selBankCode = [[NSString alloc] initWithFormat:@"%@",@""];
        chequeno = [[NSString alloc] initWithFormat:@"%@",@""];
        chequeDate = [[NSString alloc] initWithFormat:@"%@",@""];
        txtChequeNo.text = [[NSString alloc] initWithFormat:@"%@",@""];
        txtChequedate.text = [[NSString alloc] initWithFormat:@"%@",@""];
        txtBankName.text = [[NSString alloc] initWithFormat:@"%@",@""];
        txtChequeNo.enabled = NO;
    }
    else
        txtChequeNo.enabled = YES;
}

@end
