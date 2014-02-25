//
//  salesOrderMain.h
//  salesapi
//
//  Created by Imac on 4/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "salesOrderListTV.h"
#import "salesOrderEntry.h"
#import "custSearch.h"
#import "divSelect.h"
#import "itemSearch.h"
#import "genPrintView.h"
#import "getSignature.h"

@interface salesOrderMain : UIViewController 
{
    custSearch *searchCust;
    divSelect *searchDiv;
    itemSearch *searchItem;
    salesOrderListTV *soList;
    salesOrderEntry *soEntry;
    METHODCALLBACK _callBackProcessor;
    getSignature *getSign;
    UIAlertView *dAlert;
    IBOutlet UIActivityIndicatorView *actView;
    IBOutlet UILabel *dispLabel;
    IBOutlet UINavigationBar *navBar;
    BOOL _addUpdateAllow;
    genPrintView *soPreview;
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) generateSalesOrderList;
- (void) handleCallBack:(NSDictionary*) p_dict;
- (void) setNavigationForMode:(NSString*) p_naviMode;
- (IBAction) ButtonPressed:(id)sender;
- (void) saveData;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) soEntryUpdated:(NSDictionary *) p_soUpdateResult;
- (void) printingScreenBack:(NSDictionary*) printInfo;
- (void) sendViewToPrint;
- (void) presentDataForSOId:(NSString*) p_soId;
- (void) soViewDataGenerated:(NSDictionary *)soInfo;

@end
