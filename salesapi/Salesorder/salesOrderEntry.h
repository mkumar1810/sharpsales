//
//  salesOrderEntry.h
//  salesapi
//
//  Created by Macintosh User on 29/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"
#import "uomSearch.h"
#import "Base64.h"
#import "imageProxy.h"

@interface salesOrderEntry : UIScrollView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    UIInterfaceOrientation _intOrientation;
    NSString *_dataentryMode;
    METHODCALLBACK _returnCallBack;
    UITableView *entryTV;
    CGPoint scrollOffset;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    NSString *_soid;
    NSDictionary *_displayDict;
    UITextField *txtsono, *txtcustomer, *txtcustrefno, *txtcustrefdate, *txtquotedate, *txtdeliverydate, *txtdeliveryat, *txtnotes, *txtPaymentTerm, *txtdivCode,*txtTotalAmount, *txtQty, *txtRate,*txtDetailNotes;;
    UISegmentedControl *scenqmode, *scimportance;
    UILabel *lblItemAddUpdate, *lblUOMAddUpdate;
    NSMutableArray *detailData;
    NSNumberFormatter *frm;
    UIImageView *smsignImage, *givensignImage, *chequePhoto;
    BOOL _viewImages;
}

- (id)initWithOrientation:(UIInterfaceOrientation) p_intOrientation andCallBack:(METHODCALLBACK) p_callback andBackGround:(UIColor*) p_color;
- (void) generateTableView;
- (CGRect) getFrameForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) setForOrientation:(UIInterfaceOrientation)p_forOrientation;
- (IBAction) displayCalendar:(id) sender;
- (NSDictionary*) validateData;
- (NSString*) getXMLForPosting;
- (NSString*) setAfterSaveOptions:(NSDictionary*) p_saveResult;
- (void) setViewListMode;
- (NSString*) getSOId;
- (void) setDataForDisplay:(NSDictionary*) p_dict;
- (void) setEditMode;
- (NSString*) getCurrentMode;
- (void) displayDictValuesFor:(NSDictionary*) p_dict;
- (void) updateTotalAmount;
- (void) setCustomerInformation :(NSDictionary*) p_custInfo;
- (void) setPaytermValues:(NSDictionary*) p_paytermInfo;
- (void) setDivisionValues:(NSDictionary*) p_divInfo;
- (void) setItemValues:(NSDictionary*) p_itemInfo;
- (void) setUOMSelected:(NSString*) p_uom;

- (IBAction) addDetailsButtonClicked:(id) sender;
- (IBAction) addUpdConfButtonClicked:(id)sender;
- (IBAction) addUpdCancButtonClicked:(id)sender;
- (IBAction) deleteDetailsButtonClicked:(id)sender;
- (IBAction) editDetailsButtonClicked:(id)sender;
- (void) showAlertMessage:(NSString *) p_dispMessage;
- (NSString*) validateDataForDetailUpdate;
- (BOOL) checkDetailModeForModification;
- (NSDictionary*) validateData;
- (NSString*) getXMLForPosting;


- (UITableViewCell*) getMasterViewCellForSection:(int) p_sectionno andRow:(int) p_rowno;
- (UITableViewCell*) getMasterViewCellForSection2:(int) p_sectionno andRow:(int) p_rowno;
- (UITableViewCell*) getDetailViewCellForSection:(int) p_sectionno andRow:(int) p_rowno;
- (UITableViewCell*) getTotAmountViewCellForSection:(int) p_sectionno andRow:(int) p_rowno;
- (UITableViewCell*) getOrderNoCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getCustomerCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getPayTermCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getDivisionSalesCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getCustRefCell:(UITableView*) p_tv;
- (UITableViewCell*) getDlvryImportanceFor:(UITableView*) p_tv;
- (UITableViewCell*) getNotesCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getQuoteDtDlvryDtFor:(UITableView*) p_tv;
- (UITableViewCell*) getDetaillViewHeaderFor:(UITableView*) p_tv;
- (UITableViewCell*) getCellToAddUpdDetail:(UITableView*) p_tv forMode:(NSString*) p_mode ofItem:(int) p_editRowNo;
- (UITableViewCell*) getSMSignatureCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getGivenSignatureCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getImagesEnableButtonCell:(UITableView*) p_tv;

- (void) showSignChequeImages : (id) sender;
- (void) setSignature:(NSDictionary*) p_signdict forType:(NSString*) p_signType;
- (NSString*) getImageStringFor:(NSString*) p_imgType;
- (void) setImageFromServer:(NSString*) p_filename forType:(NSString*) p_signNature;
- (void) imageProxyCallback:(NSDictionary*) p_dict;

@end
