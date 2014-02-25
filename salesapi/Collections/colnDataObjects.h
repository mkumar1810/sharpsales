//
//  colnDataObjects.h
//  salesapi
//
//  Created by Raja T S Sekhar on 4/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defaults.h"

@interface colnDataObjects : NSObject <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIAlertViewDelegate>
{
    UITableView *entryTV;
    UITextField *txtCust, *txtAmount, *txtChequeNo, *txtBankName, *txtRemarks, *txtInvoiceNo, *txtReceiptNo, *txtChequedate, *txtgivenby, *txtcontactno;
    NSString *receiptno, *custval, *amount, *chequeno, *bankname, *remarks, *invno,*selcustCode, *collectionid, *chequeDate, *selBankCode, *bankval, *givenby, *contactno;
    int paymodeselected;
    CGPoint scrollOffset;
    CGRect initialFrame;
    UIScrollView *_parentScroll;
    UISegmentedControl *scPaymentMode;
    UIInterfaceOrientation intOrientation;
    NSDictionary *_initialData;
    NSString *_dispMode;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    METHODCALLBACK _custSelmethod, _bankSelMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode andCustSelectMethod:(METHODCALLBACK) p_custSelMethod andBankSelMethod:(METHODCALLBACK) p_bankSelMethod;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) generateTableView;
- (void) storeDispValues;
- (void) changeModetoView;
- (void) displayDictDataForMode:(NSString*) p_dispmode;
- (void) setCustomerValues:(NSDictionary*) custInfo;
- (void) setReceiptNo:(NSString*) newReceiptNo;
- (void) setEditMode;
- (NSString*) getXMLForPosting;
- (void) setBankValues:(NSDictionary*) bankInfo;
- (IBAction) displayCalendar:(id) sender;
- (NSDictionary*) getEnteredDetails;
- (NSDictionary*) validateData;
- (IBAction) payModeSelected:(id)sender;
- (UITableViewCell*) getReceiptDataCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getCustomerCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getPayModeCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getAmountCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getChequeDataCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getBankInfoCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getInvoiceInfoCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getGivenContactInfoCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getNotesCellFor:(UITableView*) p_tv;

@end
