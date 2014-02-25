//
//  colnDataEntry.h
//  salesapi
//
//  Created by Raja T S Sekhar on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colnDataObjects.h"
#import "custSearch.h"
#import "bankSearch.h"
#import "genPrintView.h"

@interface colnDataEntry : UIView 
{
    UIInterfaceOrientation intOrientation;
    colnDataObjects *colnObject;
    NSString *_dataentryMode;
    IBOutlet UIScrollView *_scrollview;
    IBOutlet UIView *_holderView;
    CGRect initialFrame;
    IBOutlet UINavigationItem *forTitle;
    IBOutlet UIBarButtonItem *rhsbutton;
    custSearch *searchCust;
    bankSearch *searchBank;
    genPrintView *colnpv;
    IBOutlet UINavigationBar *navBar;
    NSString *_collectionid;
    METHODCALLBACK _custSelect, _bankSelect, _returnMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andModifiedReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe;
- (void) setEntrymode:(NSString*) p_entrymode andEntryId:(NSString*) p_entryid;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (IBAction) goBack:(id) sender;
- (IBAction) saveData:(id) sender;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) addPrintButton;
- (IBAction) sendViewToPrint:(id) sender;
- (void) colnViewDataGenerated:(NSDictionary *)colnInfo;
- (void) collectionEntryUpdated:(NSDictionary *)colnAddResult;
- (void) showCustomerSelect:(NSDictionary *)custInfo;
- (void) showBankSelect:(NSDictionary *)bankInfo;
- (void) searchCustomerReturn:(NSDictionary *)custInfo;
- (void) selectBankFromLOV:(NSDictionary*) bankInfo;
- (void) printingScreenBack:(NSDictionary*) printInfo;

@end
