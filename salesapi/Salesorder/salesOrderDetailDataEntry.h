//
//  salesOrderDetailDataEntry.h
//  salesapi
//
//  Created by Imac on 5/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "salesOrderDetailObjects.h"
#import "itemSearch.h"
#import "uomSearch.h"

@interface salesOrderDetailDataEntry : UIView {
    UIInterfaceOrientation intOrientation;
    salesOrderDetailObjects *soDetObj;
    NSString *_dataentryMode;
    IBOutlet UIScrollView *_scrollview;
    IBOutlet UIView *_holderView;
    CGRect initialFrame;
    IBOutlet UINavigationItem *forTitle;
    IBOutlet UIBarButtonItem *rhsbutton;
    itemSearch *searchItem;
    uomSearch *searchUOM;
    IBOutlet UINavigationBar *navBar;
    NSString *_detailid;
    NSString *_custcode;
    NSDictionary *savedData;
    NSString *_dataentryid;
    METHODCALLBACK _returnMethod, _itemReturnMethod, _uomReturnMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andCustomerCode:(NSString*) p_custcode andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe;
- (void) setEntrymode:(NSString*) p_entrymode andEntryId:(NSString*) p_entryid;
- (void) setEntrymode:(NSString*) p_entrymode andEntryId:(NSString*) p_entryid withDictData:(NSDictionary*) p_editDict;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (IBAction) goBack:(id) sender;
- (IBAction) saveData:(id) sender;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) showUOMSelect:(NSDictionary *)uomInfo;
- (void) selectUOMFromLOV:(NSDictionary*) uomInfo;
- (void) showItemSelect:(NSDictionary *)custInfo;
- (void) searchItemReturn:(NSDictionary *)itemInfo;
@end
