//
//  salesOrderDataObjects.h
//  salesapi
//
//  Created by Imac on 5/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defaults.h"

@interface salesOrderDataObjects : NSObject <UIAlertViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITableView *entryTV;
    UITextField *txtsono, *txtcustomer, *txtcustrefno, *txtcustrefdate, *txtquotedate, *txtdeliverydate, *txtdeliveryat, *txtnotes, /**txtSalesman,*/ *txtPaymentTerm, *txtdivCode,*txtTotalAmount;
    NSString *sono, *custval, *custcode, *custrefno, *custrefdate, *quotedate, *deliverydate, *deliveryat, *notes, *soid, *smCode, /**smValue,*/ *payCode, *payVal, *divCode, *divVal;
    NSMutableArray *detailData;
    int enqmode, importance;
    double totalAmount;
    CGPoint scrollOffset;
    CGRect initialFrame;
    UIScrollView *_parentScroll;
    UISegmentedControl *scenqmode, *scimportance;
    UIInterfaceOrientation intOrientation;
    NSDictionary *_initialData;
    NSString *_dispMode;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    int btnTagForCalender, recToDelete;
    NSNumberFormatter *frm;
    METHODCALLBACK _newDetailReturn, _divSelMethod, _smSelMethod, _detailEditStartMethod, _custSelMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode andnewDetailReturn:(METHODCALLBACK) p_newDetailReturn andDivSelectMethod:(METHODCALLBACK) p_divSelMethod andSalesManSelMethod:(METHODCALLBACK) p_salesManSelectMethod andDetailEditMethod:(METHODCALLBACK) p_detailEditStartmethod andCustSelMethod:(METHODCALLBACK) p_custSelmethod;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) generateTableView;
- (void) storeDispValues;
- (void) displayDictDataForMode:(NSString*) p_dispmode;
- (void) setCustomerValues:(NSDictionary*) custInfo;
- (void) setDivisionValues:(NSDictionary*) divInfo;
//- (void) setSalesmanValues:(NSDictionary*) salesmanInfo;
- (void) setPaytermValues:(NSDictionary*) paytermInfo;
- (void) setSONo:(NSString*) newSONo;
- (void) setEditMode;
- (void) changeModetoView;
- (IBAction) displayCalendar:(id) sender;
//- (IBAction) selectDivSalesman:(id) sender;
- (NSDictionary*) getEnteredDetails;
- (NSDictionary*) validateData;
- (UITableViewCell*) getMasterViewCellForSection:(int) p_sectionno andRow:(int) p_rowno;
- (UITableViewCell*) getMasterViewCellForSection2:(int) p_sectionno andRow:(int) p_rowno;
- (UITableViewCell*) getDetailViewCellForSection:(int) p_sectionno andRow:(int) p_rowno;
- (UITableViewCell*) getTotAmountViewCellForSection:(int) p_sectionno andRow:(int) p_rowno;
- (IBAction) addDetailsButtonClicked:(id) sender;
- (IBAction) editDetailsButtonClicked:(id) sender;
- (IBAction) deleteDetailsButtonClicked:(id) sender;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) addNewlyAddedDetail:(NSDictionary*) p_newDetail;
- (void) updateModifiedDetail:(NSDictionary*) p_updateDetail inSlNo:(int) p_slNo;
- (NSString*) getXMLForPosting;
- (void) updateTotalAmount;
- (UITableViewCell*) getOrderNoCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getCustomerCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getPayTermCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getDivisionSalesCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getCustRefCell:(UITableView*) p_tv;
- (UITableViewCell*) getDlvryImportanceFor:(UITableView*) p_tv;
- (UITableViewCell*) getNotesCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getQuoteDtDlvryDtFor:(UITableView*) p_tv;
- (UITableViewCell*) getDetaillViewHeaderFor:(UITableView*) p_tv;

@end
