//
//  salesOrderDataObjects.m
//  salesapi
//
//  Created by Imac on 5/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "salesOrderDataObjects.h"


@implementation salesOrderDataObjects

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode andnewDetailReturn:(METHODCALLBACK) p_newDetailReturn andDivSelectMethod:(METHODCALLBACK) p_divSelMethod andSalesManSelMethod:(METHODCALLBACK) p_salesManSelectMethod andDetailEditMethod:(METHODCALLBACK) p_detailEditStartmethod andCustSelMethod:(METHODCALLBACK) p_custSelmethod
{
    self = [super init];
    if (self) {
        initialFrame = frame;
        _parentScroll = p_scrollview;
        intOrientation = p_intOrientation;
        _dispMode = [[NSString alloc] initWithFormat:@"%@", p_dispmode];
        _newDetailReturn = p_newDetailReturn;
        _divSelMethod = p_divSelMethod;
        _smSelMethod = p_salesManSelectMethod;
        _detailEditStartMethod = p_detailEditStartmethod;
        _custSelMethod = p_custSelmethod;
        frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];
        if (p_dictData) 
        {
            detailData = [[NSMutableArray alloc] initWithArray:[p_dictData valueForKey:@"data"] copyItems:YES];
            _initialData = [[NSDictionary alloc] initWithDictionary:[detailData objectAtIndex:0]];
            [detailData removeObjectAtIndex:0];
        }
        else
        {
            _initialData = [[NSDictionary alloc] initWithDictionary:p_dictData];
            detailData = [[NSMutableArray alloc] init];
        }
        [self updateTotalAmount];
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

- (void)dealloc
{
    //[super dealloc];
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

- (void) storeDispValues
{
    if (txtsono) 
        sono = [[NSString alloc] initWithFormat:@"%@", txtsono.text];
    
    if (scenqmode) 
        enqmode = scenqmode.selectedSegmentIndex  ;
    
    if (txtdivCode) 
        divVal = [[NSString alloc] initWithFormat:@"%@", txtdivCode.text];

    /*if (txtSalesman) 
        smValue = [[NSString alloc] initWithFormat:@"%@", txtSalesman.text];*/
    
    if (txtPaymentTerm) 
        payVal = [[NSString alloc] initWithFormat:@"%@", txtPaymentTerm.text];

    if (txtcustomer) 
        custval = [[NSString alloc] initWithFormat:@"%@", txtcustomer.text];
    
    if (txtcustrefno) 
        custrefno = [[NSString alloc] initWithFormat:@"%@", txtcustrefno.text];

    if (txtcustrefdate) 
        custrefdate = [[NSString alloc] initWithFormat:@"%@", txtcustrefdate.text];
    
    if (txtquotedate) 
        quotedate = [[NSString alloc] initWithFormat:@"%@", txtquotedate.text];

    if (txtdeliverydate) 
        deliverydate = [[NSString alloc] initWithFormat:@"%@", txtdeliverydate.text];

    if (txtdeliveryat) 
        deliveryat = [[NSString alloc] initWithFormat:@"%@", txtdeliveryat.text];
    
    if (scimportance) 
        importance = scimportance.selectedSegmentIndex  ;
    
    if (txtnotes) 
        notes = [[NSString alloc] initWithFormat:@"%@", txtnotes.text];
}

- (void) displayDictDataForMode:(NSString*) p_dispmode
{
    _dispMode = [[NSString alloc] initWithFormat:@"%@", p_dispmode];
    if ([p_dispmode isEqualToString:@"L"] | [p_dispmode isEqualToString:@"E"]) 
    {
        //NSLog(@"initial data received %@", _initialData);
        
        soid = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"SOID"]];
        sono = [[NSString alloc] initWithFormat:@"%@ / %@",[_initialData valueForKey:@"SONO"],[_initialData valueForKey:@"SODATE"]];
        smCode =    [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"SMCODE"]];
        enqmode = [[[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"ENQMODE"]] intValue]; 
        custcode =  [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"CUSTOMERCODE"]];
        custval = [[NSString alloc] initWithFormat:@"%@ - %@", [_initialData valueForKey:@"CUSTOMERCODE"], [_initialData valueForKey:@"CUSTOMERNAME"]];
        divCode =   [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"DIVCODE"]];
        divVal = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"DIVDESC"]];
        smCode =    [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"SMCODE"]];
        /*smValue = [[NSString alloc] initWithFormat:@"%@", [_initialData valueForKey:@"SALESMANNAME"]];*/
        payCode =   [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"PAYTERMCODE"]];
        payVal = [[NSString alloc] initWithFormat:@"%@ - %@", [_initialData valueForKey:@"PAYTERMCODE"], [_initialData valueForKey:@"PAYTERMNAME"]];

        if ([_initialData valueForKey:@"CUSTREFNO"]) 
            custrefno = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"CUSTREFNO"]];
        else
            custrefno = [[NSString alloc] initWithFormat:@"%@",@""];
            
        if ([_initialData valueForKey:@"CUSTREFDATE"]) 
            custrefdate = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"CUSTREFDATE"]];
        else
            custrefdate = [[NSString alloc] initWithFormat:@"%@",@""];

        if ([_initialData valueForKey:@"QUOTEDATE"]) 
            quotedate = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"QUOTEDATE"]];
        else
            quotedate = [[NSString alloc] initWithFormat:@"%@",@""];

        if ([_initialData valueForKey:@"DELIVERYDATE"]) 
            deliverydate = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"DELIVERYDATE"]];
        else
            deliverydate = [[NSString alloc] initWithFormat:@"%@",@""];

        if ([_initialData valueForKey:@"DELIVERYAT"]) 
            deliveryat = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"DELIVERYAT"]];
        else
            deliveryat = [[NSString alloc] initWithFormat:@"%@",@""];

        importance = [[[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"IMPORTANCE"]] intValue]; 

        if ([_initialData valueForKey:@"MASTERNOTES"]) 
            notes = [[NSString alloc] initWithFormat:@"%@",[_initialData valueForKey:@"MASTERNOTES"]];
        else
            notes = [[NSString alloc] initWithFormat:@"%@",@""];
       // NSLog(@"received div val %@",divVal);

    }
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
            noofRows = 4;
            break;
        case 1:
            noofRows = 4;
            break;
        case 2:
            noofRows = 1 + [detailData count];
            break;
        case 3:
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
    if (indexPath.section==2) 
    {
        //if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        {
            switch (indexPath.row) {
                case 0:
                    l_retval = 50.0f;
                    break;
                default:
                    l_retval = 90.0f;
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
            switch (indexPath.row){
                case 1:
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"selectCustomerForSO" object:self];
                    _custSelMethod(nil);
                    break;
                case 2:
                    _divSelMethod(nil);
                    break;
                /*case 2:
                    [[NSNotifixcationCenter defaultCenter] postNotifixcationName:@"selectDivForSO" object:self];
                    break;
                case 3:
                    [[NSNotixficationCenter defaultCenter] postNotixficationName:@"selectSalesmanForSO" object:self];
                    break;*/
                case 3:
                    /*[[NSNotificxationCenter defaultCenter] postNotixficationName:@"selectPaytermForSO" object:self];*/
                    break;
                default:
                    break;
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
        l_retval = 30;
    else
        l_retval = 15;
    return l_retval;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self getMasterViewCellForSection:indexPath.section andRow:indexPath.row];
            break;
        case 1:
            return [self getMasterViewCellForSection2:indexPath.section andRow:indexPath.row];
            break;
        case 2:
            return [self getDetailViewCellForSection:indexPath.section andRow:indexPath.row];
            break;
        case 3:
            return [self getTotAmountViewCellForSection:indexPath.section andRow:indexPath.row];
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell*) getTotAmountViewCellForSection:(int) p_sectionno andRow:(int) p_rowno
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    int itemWidth;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
        itemWidth = 668;
    else
        itemWidth = 910;
    UIFont *reqfont = [UIFont boldSystemFontOfSize:20.0f];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (p_rowno) 
    {
        case 0:
            txtTotalAmount = [[UITextField alloc] initWithFrame:CGRectMake(2, 0, itemWidth, 50)];
            txtTotalAmount.text = @"";
            txtTotalAmount.enabled = NO;
            txtTotalAmount.font =reqfont;
            txtTotalAmount.textAlignment = UITextAlignmentRight;
            txtTotalAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [cell.contentView addSubview:txtTotalAmount];
            [self updateTotalAmount];
            break;
        default:
            break;
    }
    return cell;
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
    UILabel *lblSlno, *lblItem, *lblUOM, *lblQty, *lblRate, *lblDivider,*lblNotes;
    int itemWidth, otherDetailWidth, startposition, otherDetailHeight, btnaddXPos;
    startposition = 0;
    otherDetailHeight = 44;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
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
    NSDictionary *tmpDetData = [[NSDictionary alloc] initWithDictionary:[detailData objectAtIndex:p_rowno-1] copyItems:YES];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
             initWithStyle:UITableViewCellStyleSubtitle
             reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        lblSlno = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, slNowidth, dataHeight-1)];
        lblSlno.font = reqfont;
        lblSlno.textAlignment = UITextAlignmentCenter;
        lblSlno.tag = 101;
        [lblSlno setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblSlno];
        //[lblSlno release];

        startposition = startposition + 40;
        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, 1, dataHeight)];
        [lblDivider setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblDivider];
        //[lblDivider release];

        startposition = startposition + 1;
        lblItem = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, itemWidth, dataHeight-1)];
        lblItem.font = reqfont;
        lblItem.textAlignment = UITextAlignmentLeft;
        lblItem.numberOfLines = 3;
        [lblItem setBackgroundColor:[UIColor whiteColor]];
        lblItem.tag = 102;
        [cell.contentView addSubview:lblItem];
        //[lblItem release];

        startposition = startposition + itemWidth;
        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, 1, dataHeight)];
        [lblDivider setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblDivider];
        //[lblDivider release];

        startposition = startposition + 1;
        lblUOM = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight)];
        lblUOM.font = reqfont;
        lblUOM.textAlignment = UITextAlignmentLeft;
        [lblUOM setBackgroundColor:[UIColor whiteColor]];
        lblUOM.tag = 103;
        [cell.contentView addSubview:lblUOM];
        //[lblUOM release];

        startposition = startposition + otherDetailWidth;
        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, 1, otherDetailHeight+1)];
        [lblDivider setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblDivider];
        //[lblDivider release];

        startposition = startposition + 1;
        lblQty = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight)];
        lblQty.font = reqfont;
        lblQty.textAlignment = UITextAlignmentLeft;
        [lblQty setBackgroundColor:[UIColor whiteColor]];
        lblQty.textAlignment=UITextAlignmentRight;
        lblQty.tag = 104;
        [cell.contentView addSubview:lblQty];
        //[lblQty release];

        [frm setMaximumFractionDigits:2];
        startposition = startposition + otherDetailWidth;
        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, 1, otherDetailHeight+1)];
        [lblDivider setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblDivider];
        //[lblDivider release];

        startposition = startposition + 1;
        lblRate = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, otherDetailWidth, otherDetailHeight)];
        lblRate.font = reqfont;
        lblRate.textAlignment=UITextAlignmentRight;
        lblRate.tag = 105;
        [lblRate setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblRate];
        //[lblRate release];

        startposition = startposition + otherDetailWidth;
        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(startposition, 0, 1, dataHeight)];
        [lblDivider setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblDivider];
        //[lblDivider release];

        lblNotes = [[UILabel alloc] initWithFrame:CGRectMake(slNowidth+2+itemWidth,otherDetailHeight+1, otherDetailWidth*3+101, otherDetailHeight)];
        lblNotes.font = reqfont;
        lblNotes.textAlignment = UITextAlignmentLeft;
        lblNotes.tag = 106;
        [lblNotes setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblNotes];
        //[lblNotes release];

        btnedit = [[UIButton alloc] initWithFrame:CGRectMake(startposition+1, 0, 49, 49)];
        btnedit.titleLabel.text= [NSString stringWithFormat:@"%d", p_rowno];
        [btnedit setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnedit addTarget:self action:@selector(editDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        //btnedit = p_rowno;
        btnedit.tag = 107;
        
        [cell.contentView addSubview:btnedit];
        //[btnedit release];

        btndelete = [[UIButton alloc] initWithFrame:CGRectMake(startposition+50, 0, 49, 49)];
        btndelete.titleLabel.text=[NSString stringWithFormat:@"%d", p_rowno];
        [btndelete setImage:[UIImage imageNamed:@"deleteicon.JPG"] forState:UIControlStateNormal];
        [btndelete addTarget:self action:@selector(deleteDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        //btndelete.tag = p_rowno;
        btndelete.tag = 108;
        [cell.contentView addSubview:btndelete];
    }
    lblSlno = (UILabel*) [cell.contentView viewWithTag:101];
    lblItem = (UILabel*) [cell.contentView viewWithTag:102];
    lblUOM = (UILabel*) [cell.contentView viewWithTag:103];
    lblQty = (UILabel*) [cell.contentView viewWithTag:104];
    lblRate = (UILabel*) [cell.contentView viewWithTag:105];
    lblNotes = (UILabel*) [cell.contentView viewWithTag:106];
    btnedit = (UIButton*) [cell.contentView viewWithTag:107];
    btndelete = (UIButton*) [cell.contentView viewWithTag:108];
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
    if ([_dispMode isEqualToString:@"L"])  btnedit.enabled = NO;
    if ([_dispMode isEqualToString:@"L"])  btndelete.enabled = NO;
    //[btndelete release];
    return cell;
}

- (UITableViewCell*) getDetaillViewHeaderFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellDetailHeader";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UIButton *btnadd;
    int itemWidth, otherDetailWidth, startposition, otherDetailHeight, btnaddXPos;
    startposition = 0;
    otherDetailHeight = 44;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
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
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"Sl#                        Item                              UOM         Qty           Rate"];
        else
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"Sl#                                   Item                                                UOM               Qty                  Rate"];
        btnadd = [[UIButton alloc] initWithFrame:CGRectMake(btnaddXPos, 0, 50, 50)];
        btnadd.titleLabel.text=@"";
        btnadd.tag = 101;
        [btnadd setImage:[UIImage imageNamed:@"addiconnew1.PNG"] forState:UIControlStateNormal];
        [btnadd addTarget:self action:@selector(addDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnadd];
    }
    btnadd =(UIButton*) [cell.contentView viewWithTag:101];
    if ([_dispMode isEqualToString:@"L"])  btnadd.enabled = NO;
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
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    
    dividerNeeded = YES;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        cellHeight=50;
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Notes"];
        lblcaption2 = [[NSString alloc] initWithString:@""];
        txtnotes = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, 2*entryWidth+captionWidth, cellHeight)];
        //NSLog(@"received master notes %@",notes);
        txtnotes.text = @"";
        if (notes) 
            txtnotes.text = notes;
        txtnotes.placeholder = @"Enter any notes or remarks";
        txtnotes.font =reqfont;
        txtnotes.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtnotes.delegate = self;
        txtnotes.tag = 101;
        [cell.contentView addSubview:txtnotes];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, captionWidth, cellHeight-1)];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+4, 0, 1, cellHeight)];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        if ([lblcaption2 isEqualToString:@""]==NO) {
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
        }
    }
    txtnotes = (UITextField*) [cell.contentView viewWithTag:101];
    if ([_dispMode isEqualToString:@"L"])  txtnotes.enabled = NO;
    return cell;
}

- (UITableViewCell*) getDlvryImportanceFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellDlvryImport";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    
    dividerNeeded = YES;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Dlvry. At"];
        lblcaption2 = [[NSString alloc] initWithFormat:@"  %@",@"Importance"];
        txtdeliveryat = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, entryWidth, cellHeight)];
        txtdeliveryat.text = @"";
        if (deliveryat) 
            txtdeliveryat.text = deliveryat;
        txtdeliveryat.placeholder = @"Delivery Location";
        txtdeliveryat.font =reqfont;
        txtdeliveryat.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtdeliveryat.delegate = self;
        txtdeliveryat.tag = 101;
        [cell.contentView addSubview:txtdeliveryat];
        NSArray *item2Array = [NSArray arrayWithObjects: @"Normal", @"High", nil];
        scimportance = [[UISegmentedControl alloc] initWithItems:item2Array];
        [scimportance setFrame:CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth, cellHeight)];
        [scimportance setSelectedSegmentIndex:importance];
        scimportance.tag = 102;
        [cell.contentView addSubview:scimportance];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, captionWidth, cellHeight-1)];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+4, 0, 1, cellHeight)];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        if ([lblcaption2 isEqualToString:@""]==NO) {
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
        }
    }
    txtdeliveryat = (UITextField*) [cell.contentView viewWithTag:101];
    scimportance = (UISegmentedControl*) [cell.contentView viewWithTag:102];
    if ([_dispMode isEqualToString:@"L"])  scimportance.enabled = NO;
    if ([_dispMode isEqualToString:@"L"])  txtdeliveryat.enabled = NO;
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
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    
    dividerNeeded = YES;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Quote Dt"];
        lblcaption2 = [[NSString alloc] initWithFormat:@"  %@",@"Dlvry. Dt"];
        txtquotedate = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, entryWidth-30, cellHeight)];
        txtquotedate.text = @"";
        if (quotedate) 
            txtquotedate.text = quotedate;
        txtquotedate.enabled=NO;
        txtquotedate.placeholder = @"Pick Quote Date";
        txtquotedate.font =reqfont;
        txtquotedate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtquotedate.delegate = self;
        [cell.contentView addSubview:txtquotedate];
        btncalenderQuote = [[UIButton alloc] initWithFrame:CGRectMake(captionWidth+6+entryWidth-30, 0, 30, cellHeight)];
        btncalenderQuote.titleLabel.text=@"";
        [btncalenderQuote setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalenderQuote addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        btncalenderQuote.tag = 52;
        [cell.contentView addSubview:btncalenderQuote];
        //[btncalender release];
        
        txtdeliverydate = [[UITextField alloc] initWithFrame:CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth-30, cellHeight)];
        txtdeliverydate.text = @"";
        if (deliverydate) 
            txtdeliverydate.text = deliverydate;
        txtdeliverydate.enabled = NO;
        txtdeliverydate.placeholder = @"Pick dely. Dt";
        txtdeliverydate.delegate = self;
        txtdeliverydate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtdeliverydate];
        btnCalenderDlvry = [[UIButton alloc] initWithFrame:CGRectMake(2*captionWidth-22+2*entryWidth, 0, 30, cellHeight)];
        btnCalenderDlvry.titleLabel.text=@"";
        [btnCalenderDlvry setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnCalenderDlvry addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnCalenderDlvry];
        btnCalenderDlvry.tag = 53;
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, captionWidth, cellHeight-1)];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+4, 0, 1, cellHeight)];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        if ([lblcaption2 isEqualToString:@""]==NO) {
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
        }
    }
    btncalenderQuote = (UIButton*) [cell.contentView viewWithTag:52];
    btnCalenderDlvry = (UIButton*) [cell.contentView viewWithTag:53];
    if ([_dispMode isEqualToString:@"L"])  btnCalenderDlvry.enabled = NO;
    if ([_dispMode isEqualToString:@"L"])  btncalenderQuote.enabled = NO;
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
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    
    dividerNeeded = YES;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Ref no"];
        lblcaption2 = [[NSString alloc] initWithFormat:@"  %@",@"Ref Date"];
        txtcustrefno = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, entryWidth, cellHeight)];
        txtcustrefno.text = @"";
        if (custrefno) 
            txtcustrefno.text = custrefno;
        txtcustrefno.placeholder = @"Enter Ref No";
        txtcustrefno.font =reqfont;
        txtcustrefno.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtcustrefno.delegate = self;
        txtcustrefno.tag = 101;
        [txtcustrefno setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:txtcustrefno];
        
        txtcustrefdate = [[UITextField alloc] initWithFrame:CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth-30, cellHeight)];
        txtcustrefdate.text = @"";
        if (custrefdate) 
            txtcustrefdate.text = custrefdate;
        txtcustrefdate.enabled = NO;
        txtcustrefdate.placeholder = @"Pick Ref date";
        txtcustrefdate.delegate = self;
        txtcustrefdate.tag = 102;
        txtcustrefdate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txtcustrefdate];
        btncalender = [[UIButton alloc] initWithFrame:CGRectMake(2*captionWidth-22+2*entryWidth, 0, 30, cellHeight)];
        btncalender.titleLabel.text=@"";
        [btncalender setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalender addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btncalender];
        btncalender.tag = 51;

        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, captionWidth, cellHeight-1)];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];

        lbldivider1 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+4, 0, 1, cellHeight)];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider1];
        
        
        if ([lblcaption2 isEqualToString:@""]==NO) {
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
        }
    }
    txtcustrefno = (UITextField*) [cell.contentView viewWithTag:101];
    txtcustrefdate = (UITextField*) [cell.contentView viewWithTag:102];
    btncalender = (UIButton*) [cell.contentView viewWithTag:51];
    if ([_dispMode isEqualToString:@"L"])  txtcustrefno.enabled = NO;
    if ([_dispMode isEqualToString:@"L"])  btncalender.enabled = NO;
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
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    dividerNeeded = YES;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Pay Term"];
        lblcaption2 = [[NSString alloc] initWithString:@""];
        txtPaymentTerm = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, 2*entryWidth+captionWidth+4, cellHeight)];
        txtPaymentTerm.text = @"";
        if (payVal) 
            txtPaymentTerm.text = payVal;
        txtPaymentTerm.enabled = NO;
        txtPaymentTerm.placeholder = @"Select a Pay term";
        txtPaymentTerm.font =reqfont;
        txtPaymentTerm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtPaymentTerm.delegate = self;
        txtPaymentTerm.tag = 101;
        [cell.contentView addSubview:txtPaymentTerm];
        cell.accessoryType =UITableViewCellAccessoryNone;
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, captionWidth, cellHeight-1)];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+4, 0, 1, cellHeight)];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        if ([lblcaption2 isEqualToString:@""]==NO) {
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
        }
    }
    txtPaymentTerm = (UITextField*) [cell.contentView viewWithTag:101];
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
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    //UIButton *btnSelectDiv, *btnSelectSM;
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    dividerNeeded = YES;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Division"];
        lblcaption2 = @"";
        txtdivCode = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, 2*entryWidth+captionWidth+4, cellHeight)];
        /*txtdivCode = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, entryWidth-30, cellHeight)];*/
        txtdivCode.text = @"";
        if (divVal) 
            txtdivCode.text = divVal;
        txtdivCode.enabled=NO;
        txtdivCode.placeholder = @"Select Division";
        txtdivCode.font =reqfont;
        txtdivCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtdivCode.delegate = self;
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
        cell.accessoryType =UITableViewCellAccessoryNone;
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        //lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, captionWidth, cellHeight-1)];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+4, 0, 1, cellHeight)];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        if ([lblcaption2 isEqualToString:@""]==NO) {
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
        }
    }
    txtdivCode = (UITextField*) [cell.contentView viewWithTag:101];
    /*txtSalesman = (UITextField*) [cell.contentView viewWithTag:102];
    btnSelectDiv = (UIButton*) [cell.contentView viewWithTag:55];
    btnSelectSM = (UIButton*) [cell.contentView viewWithTag:56];
    if ([_dispMode isEqualToString:@"L"])  btnSelectDiv.enabled = NO;
    if ([_dispMode isEqualToString:@"L"])  btnSelectSM.enabled = NO;*/
    if ([_dispMode isEqualToString:@"L"]==NO)  //scenqmode.enabled = NO;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType =UITableViewCellAccessoryNone;
    
    return cell;
}

- (UITableViewCell*) getCustomerCellFor:(UITableView*) p_tv
{
    static NSString *cellid=@"CellCustomer";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbltitle1, *lbldivider1, *lbltitle2, *lbldivider2, *lbldivider3;
    UIFont *reqfont = [UIFont systemFontOfSize:18.0f];
    NSString *lblcaption1, *lblcaption2 ;
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    dividerNeeded = YES;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Customer"];
        lblcaption2 = [[NSString alloc] initWithString:@""];
        txtcustomer = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, 2*entryWidth+captionWidth+4, cellHeight)];
        txtcustomer.text = @"";
        if (custval) 
            txtcustomer.text = custval;
        txtcustomer.enabled = NO;
        txtcustomer.placeholder = @"Select a Customer";
        txtcustomer.font =reqfont;
        txtcustomer.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtcustomer.delegate = self;
        txtcustomer.tag = 101;
        [cell.contentView addSubview:txtcustomer];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, captionWidth, cellHeight-1)];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+4, 0, 1, cellHeight)];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        if ([lblcaption2 isEqualToString:@""]==NO) {
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
        }
    }
    txtcustomer = (UITextField*) [cell.contentView viewWithTag:101];
    if ([_dispMode isEqualToString:@"L"]==NO)  //scenqmode.enabled = NO;
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
    BOOL dividerNeeded;
    int captionWidth, entryWidth, cellHeight;
    cellHeight = 50;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        captionWidth = 102;
        entryWidth = 232;
    }
    else
    {
        captionWidth = 139;
        entryWidth = 316;
    }
    dividerNeeded = YES;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        lblcaption1 =[[NSString alloc] initWithFormat:@"  %@",@"Order No"];
        lblcaption2 = [[NSString alloc] initWithFormat:@"  %@",@"Enquiry"];
        txtsono = [[UITextField alloc] initWithFrame:CGRectMake(captionWidth+6, 0, entryWidth, cellHeight)];
        txtsono.text = @"";
        if (sono) 
            txtsono.text = sono;
        txtsono.enabled = NO;
        txtsono.placeholder = @"Order No (auto generated)";
        txtsono.font =reqfont;
        txtsono.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtsono.delegate = self;
        txtsono.tag = 101;
        [cell.contentView addSubview:txtsono];
        NSArray *itemArray = [NSArray arrayWithObjects: @"Fax", @"Ph.", @"Mail", @"Doc", nil];
        scenqmode = [[UISegmentedControl alloc] initWithItems:itemArray];
        [scenqmode setFrame:CGRectMake(2*captionWidth+8+entryWidth, 0, entryWidth, cellHeight)];
        [scenqmode setSelectedSegmentIndex:enqmode];
        scenqmode.tag = 102;
        [cell.contentView addSubview:scenqmode];
        lblcaption1 = [lblcaption1 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lblcaption2 = [lblcaption2 stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbltitle1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, captionWidth, cellHeight-1)];
        lbltitle1.font = reqfont;
        lbltitle1.text = lblcaption1;
        [lbltitle1 setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lbltitle1];
        //[lbltitle1 release];
        lbldivider1 = [[UILabel alloc] initWithFrame:CGRectMake(captionWidth+4, 0, 1, cellHeight)];
        [lbldivider1 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lbldivider1];
        //[lbldivider1 release];
        
        
        if ([lblcaption2 isEqualToString:@""]==NO) {
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
        }
    }
    txtsono = (UITextField*) [cell.contentView viewWithTag:101];
    scenqmode = (UISegmentedControl*) [cell.contentView viewWithTag:102];
    if ([_dispMode isEqualToString:@"L"])  scenqmode.enabled = NO;
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
    key =  [[NSString alloc] initWithString:@"   "];
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    return key;
}

- (void) setDivisionValues:(NSDictionary*) divInfo
{
    if (divInfo) {
        if (txtdivCode) 
        {
            //NSLog(@"customner info %@", custInfo);
            divCode= [[NSString alloc] initWithFormat:@"%@", [divInfo valueForKey:@"DIVCODE"]];
            txtdivCode.text = [[NSString alloc] initWithFormat:@"%@", [divInfo valueForKey:@"DIVDESC"]];
        }
        else
            divCode = [[NSString alloc] initWithFormat:@"%@",""];
    }
    
}

- (void) setPaytermValues:(NSDictionary*) paytermInfo
{
    if (paytermInfo) {
        if (txtPaymentTerm) 
        {
            NSLog(@"payterm info %@", paytermInfo);
            payCode= [[NSString alloc] initWithFormat:@"%@", [paytermInfo valueForKey:@"PAYTERMCODE"]];
            txtPaymentTerm.text = [[NSString alloc] initWithFormat:@"%@ - %@", [paytermInfo valueForKey:@"PAYTERMCODE"], [paytermInfo valueForKey:@"PAYTERMNAME"]];
        }
        else
            payCode = [[NSString alloc] initWithFormat:@"%@",""];
    }
}


- (void) setCustomerValues:(NSDictionary*) custInfo
{
    if (custInfo) {
        if (txtcustomer) 
        {
            NSLog(@"customner info %@", custInfo);
            custcode= [[NSString alloc] initWithFormat:@"%@", [custInfo valueForKey:@"CD"]];
            txtcustomer.text = [[NSString alloc] initWithFormat:@"%@ - %@", [custInfo valueForKey:@"CD"], [custInfo valueForKey:@"CN"]];
        }
        else
            custcode = [[NSString alloc] initWithFormat:@"%@",""];
        [self setPaytermValues:custInfo];
    }
}

/*- (void) setSalesmanValues:(NSDictionary*) salesmanInfo
{
    if (salesmanInfo) {
        if (txtSalesman) 
        {
            //NSLog(@"customner info %@", custInfo);
            smCode= [[NSString alloc] initWithFormat:@"%@", [salesmanInfo valueForKey:@"SMCODE"]];
            txtSalesman.text = [[NSString alloc] initWithFormat:@"%@", [salesmanInfo valueForKey:@"SMNAME"]];
        }
        else
            smCode = [[NSString alloc] initWithFormat:@"%@",""];
    }
    
}*/

/*- (IBAction) selectDivSalesman:(id)sender
{
    UIButton *btnClicked = (UIButton*) sender;
    if ([_dispMode isEqualToString:@"L"]==NO) 
    {
        switch (btnClicked.tag){
            case 55:
                 //[[NSNotificaxtionCenter defaultCenter] postNotifixcationName:@"selectDivForSO" object:self];
                _divSelMethod(nil);
                 break;
            case 56:
                 //[[NSNotificaxtionCenter defaultCenter] postNotixficationName:@"selectSalesmanForSO" object:self];
                _smSelMethod(nil);
                 break;
            default:
                break;
        }
    }
}*/

- (IBAction) displayCalendar:(id) sender
{
    UIButton *btnsender = (UIButton*) sender;
    btnTagForCalender = btnsender.tag;
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
    NSString *btntitle = [alertView buttonTitleAtIndex:buttonIndex]; 
    if ([btntitle isEqualToString:@"Select"]) 
    {
        NSDate *date = [dobPicker date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:(NSString*) @"dd-MMM-yyyy"];
        if (btnTagForCalender==51) 
        {
            txtcustrefdate.text = [dateFormatter stringFromDate:date];
            custrefdate = [[NSString alloc] initWithFormat:@"%@", txtcustrefdate.text];
            return;
        }
        if (btnTagForCalender==52) 
        {
            txtquotedate.text = [dateFormatter stringFromDate:date];
            quotedate = [[NSString alloc] initWithFormat:@"%@", txtquotedate.text];
            return;
        }
        if (btnTagForCalender==53) 
        {
            txtdeliverydate.text = [dateFormatter stringFromDate:date];
            deliverydate = [[NSString alloc] initWithFormat:@"%@", txtdeliverydate.text];
            return;
        }
        return;
    }
    if ([btntitle isEqualToString:@"OK"]) 
    {
        [self storeDispValues];
        [detailData removeObjectAtIndex:recToDelete];
        [self updateTotalAmount];
        [self setForOrientation:intOrientation];
    }
}

- (IBAction) addDetailsButtonClicked:(id) sender
{
    if (custcode) {
        if ([custcode isEqualToString:@""]==NO) {
            NSMutableDictionary *addItemInfo = [[NSMutableDictionary alloc] init];
            [addItemInfo setValue:custcode forKey:@"custcode"];
            //[[NSNotixficationCenter defaultCenter] postNotixficationName:@"addNewDetailItemtoSO" object:self userInfo:addItemInfo];
            _newDetailReturn(addItemInfo);
        }
        else
            [self showAlertMessage:@"Please select a valid customer"];
    }
    else
        [self showAlertMessage:@"Please select a valid customer"];
}

- (IBAction) editDetailsButtonClicked:(id) sender
{
    UIButton *selButton = (UIButton*) sender;
    int slno = [selButton.titleLabel.text intValue] - 1;         //selButton.tag-1;
    if (custcode) {
        if ([custcode isEqualToString:@""]==NO) {
            NSMutableDictionary *editItemInfo = [[NSMutableDictionary alloc] init];
            [editItemInfo setValue:custcode forKey:@"custcode"];
            [editItemInfo setValue:[detailData objectAtIndex:slno] forKey:@"EDITDATA"];
            [editItemInfo setValue:[NSString stringWithFormat:@"%d", slno] forKey:@"EDITITEM"];
            //[[NSNotificxationCenter defaultCenter] postNotifxicationName:@"soDetailEditStart" object:self userInfo:editItemInfo];
            _detailEditStartMethod(editItemInfo);
        }
        else
            [self showAlertMessage:@"Please select a valid customer"];
    }
    else
        [self showAlertMessage:@"Please select a valid customer"];
}

- (IBAction) deleteDetailsButtonClicked:(id) sender
{
    UIButton *selButton = (UIButton*) sender;
    recToDelete = [selButton.titleLabel.text intValue] - 1;         //selButton.tag-1;
    dAlert = [[UIAlertView alloc] initWithTitle:@"Delete Record" message:@"Are you sure\nto Delete this Record" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    dAlert.cancelButtonIndex = 0;
    dAlert.delegate = self;
    [dAlert show];
    //[dAlert release];
}

- (void) setSONo:(NSString*) newSONo
{
    if (newSONo) {
        txtsono.text = newSONo;
        sono = newSONo;
    }
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}

- (void) addNewlyAddedDetail:(NSDictionary*) p_newDetail
{
    [self storeDispValues];
    [detailData addObject:p_newDetail];
    [self updateTotalAmount];
    [self setForOrientation:intOrientation];
}

- (void) updateModifiedDetail:(NSDictionary*) p_updateDetail inSlNo:(int) p_slNo
{
    [self storeDispValues];
    [detailData replaceObjectAtIndex:p_slNo withObject:p_updateDetail];
    [self updateTotalAmount];
    [self setForOrientation:intOrientation];
}

- (NSDictionary*) getEnteredDetails
{
    return nil;
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
    returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"RESPONSECODE",@"Successfully Validated",@"RESPONSEMESSAGE"  , nil];
    return returnDict;
}

- (void) setEditMode
{
    _dispMode= [[NSString alloc] initWithFormat:@"%@",@"E"];
    [self generateTableView];
}

- (NSString*) getXMLForPosting
{
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    NSMutableString *l_detailXML = [[NSMutableString alloc] init ];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [self storeDispValues];
    if ([_dispMode isEqualToString:@"A"]) 
        l_retXML = [NSString stringWithFormat:soMasterXML, @"0",@"0", custcode, enqmode, importance, custrefno, custrefdate, quotedate, deliverydate, deliveryat, notes,divCode, [standardUserDefaults valueForKey:@"SALESMANCODE"], payCode,totalAmount];
    else
        l_retXML = [NSString stringWithFormat:soMasterXML, soid,sono, custcode, enqmode, importance, custrefno, custrefdate, quotedate, deliverydate, deliveryat, notes,divCode, smCode, payCode,totalAmount];
        
    for (NSDictionary *tmpDict in detailData) {
        l_detailXML = [NSString stringWithFormat:soDetailXML, [tmpDict valueForKey:@"SODETAILID"],@"0",[tmpDict valueForKey:@"ITEMCODE"], [tmpDict valueForKey:@"UOMCODE"], [tmpDict valueForKey:@"QTY"], [tmpDict valueForKey:@"RATE"],[tmpDict valueForKey:@"DETAILNOTES"]];
        l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_detailXML];
    }
    l_retXML = [NSString stringWithFormat:@"%@%@%@",@"<SODATA>",l_retXML, @"</SODATA>"];
    //NSLog(@"xml result %@", l_retXML);
    return l_retXML;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_parentScroll setContentOffset:scrollOffset animated:NO]; 
    if ([textField isEqual:txtcustrefno]) 
        [txtcustrefno resignFirstResponder];
    else if([textField isEqual:txtdeliveryat])
        [txtnotes becomeFirstResponder];
    else if ([textField isEqual:txtnotes])
        [txtnotes resignFirstResponder];
    
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}


- (void) changeModetoView
{
    _dispMode= [[NSString alloc] initWithFormat:@"%@",@"L"];
    [self generateTableView];
}

- (void) updateTotalAmount
{
    NSString *tempqty, *temprate;
    totalAmount = 0;
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

@end
