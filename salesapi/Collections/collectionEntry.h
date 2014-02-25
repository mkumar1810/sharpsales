//
//  collectionEntry.h
//  salesapi
//
//  Created by Macintosh User on 23/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"
#import "Base64.h"
#import "imageProxy.h"

@interface collectionEntry : UIScrollView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    UIInterfaceOrientation _intOrientation;
    NSString *_dataentryMode;
    METHODCALLBACK _returnCallBack;
    UITableView *entryTV;
    UITextField *txtCust, *txtAmount, *txtChequeNo, *txtBankName, *txtRemarks, *txtInvoiceNo, *txtReceiptNo, *txtChequedate, *txtgivenby, *txtcontactno;
    UISegmentedControl *scPaymentMode;
    CGPoint scrollOffset;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    NSString *_collectionId;
    NSDictionary *_displayDict;
    UIImageView *smsignImage, *givensignImage, *chequePhoto;
    BOOL _viewImages;
    //METHODCALLBACK _imageProxyCallback;
}


- (id)initWithOrientation:(UIInterfaceOrientation) p_intOrientation andCallBack:(METHODCALLBACK) p_callback andBackGround:(UIColor*) p_color;
- (void) generateTableView;
- (CGRect) getFrameForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) setForOrientation:(UIInterfaceOrientation)p_forOrientation;
- (UITableViewCell*) getReceiptDataCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getCustomerCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getPayModeCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getAmountCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getChequeDataCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getBankInfoCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getInvoiceInfoCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getGivenContactInfoCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getNotesCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getSMSignatureCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getGivenSignatureCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getChequeCaptureCellFor:(UITableView*) p_tv;
- (UITableViewCell*) getImagesEnableButtonCell:(UITableView*) p_tv;


- (void) setCustomerInformation :(NSDictionary*) p_custInfo;
- (IBAction) payModeSelected:(id)sender;
- (IBAction) displayCalendar:(id) sender;
- (void) setBankValues:(NSDictionary*) p_bankInfo;
- (NSDictionary*) validateData;
- (NSString*) getXMLForPosting;
- (NSString*) setAfterSaveOptions:(NSDictionary*) p_saveResult;
- (void) setViewListMode;
- (NSString*) getCollectionId;
- (void) setDataForDisplay:(NSDictionary*) p_dict;
- (void) setEditMode;
- (NSString*) getCurrentMode;
- (void) displayDictValues;
- (void) setSignature:(NSDictionary*) p_signdict forType:(NSString*) p_signType;
- (NSString*) getImageStringFor:(NSString*) p_imgType;
- (void) setImageFromServer:(NSString*) p_filename forType:(NSString*) p_signNature;
- (void) imageProxyCallback:(NSDictionary*) p_dict;
- (void) setChequeImage:(UIImage*) p_chequeImage; 

@end
