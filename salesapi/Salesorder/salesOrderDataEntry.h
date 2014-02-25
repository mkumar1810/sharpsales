//
//  salesOrderDataEntry.h
//  salesapi
//
//  Created by Imac on 5/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "salesOrderDataObjects.h"
#import "custSearch.h"
#import "salesOrderDetailDataEntry.h"
#import "divSelect.h"
#import "salesmanSelect.h"
#import "paymenttermSelect.h"
#import "genPrintView.h"

@interface salesOrderDataEntry : UIView 
{
    UIInterfaceOrientation intOrientation;
    salesOrderDataObjects *soObject;
    NSString *_dataentryMode;
    IBOutlet UIScrollView *_scrollview;
    IBOutlet UIView *_holderView;
    CGRect initialFrame;
    IBOutlet UINavigationItem *forTitle;
    IBOutlet UIBarButtonItem *rhsbutton;
    custSearch *searchCust;
    divSelect *searchDiv;
    salesmanSelect *searchSalesman;
    paymenttermSelect *searchPayterm;
    salesOrderDetailDataEntry *soDetEntry;
    genPrintView *soPreview;
    IBOutlet UINavigationBar *navBar;
    NSString *_soid;
    METHODCALLBACK _soObjectsReturn, _divSelectMethod, _smSelMethod,_custSelMethod, _updateReturnMethod, _soModifyCompleteMethod, _soDetailItemEditMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andSOModifiedMethod:(METHODCALLBACK) p_soModifyReturn;
- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe;
- (void) setEntrymode:(NSString*) p_entrymode andEntryId:(NSString*) p_entryid;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (IBAction) goBack:(id) sender;
- (IBAction) saveData:(id) sender;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) addPrintButton;
- (IBAction) sendViewToPrint:(id) sender;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) SOViewDataGenerated : (NSDictionary*) soViewDataInfo;
- (void) salesOrderSubmitted : (NSDictionary*) soSubmitInfo;
- (void) addNewDetailItemtoSO : (NSDictionary*) newItemInfo;
- (void) searchCustomerReturn:(NSDictionary *)custInfo;
- (void) showCustomerSelect:(NSDictionary *)custInfo;
- (void) showDivSelect:(NSDictionary *)divInfo;
- (void) searchDivReturn:(NSDictionary *)divInfo;
//- (void) showSalesmanSelect:(NSDictionary *)salesmanInfo;
//- (void) searchSalesmanReturn:(NSDictionary *)salesmanInfo;
- (void) soDetailRecordUpdated : (NSDictionary*) updatedDetailInfo;
- (void) editDetailItemofSO : (NSDictionary*) editItemInfo;
- (void) printingScreenBack:(NSDictionary*) printInfo;

@end
