//
//  collectionMainHome.h
//  dssapi
//
//  Created by Raja T S Sekhar on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colnListTV.h"
#import "collectionEntry.h"
#import "custSearch.h"
#import "bankSearch.h"
#import "genPrintView.h"
#import "getSignature.h"

@interface collectionMainHome : UIViewController <UIAlertViewDelegate,UINavigationControllerDelegate,  UIImagePickerControllerDelegate>
{
    colnListTV *colnList;
    collectionEntry *colnEntry;
    custSearch *searchCust;
    bankSearch *searchBank;
    METHODCALLBACK _callBackProcessor;
    genPrintView *colnpv;
    getSignature *getSign;
    UIAlertView *dAlert;
    IBOutlet UIActivityIndicatorView *actView;
    IBOutlet UILabel *dispLabel;
    IBOutlet UINavigationBar *navBar;
    BOOL _addUpdateAllow;
    UIImagePickerController *imgPicker;
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) generateCollectionsList;
- (void) handleCallBack:(NSDictionary*) p_dict;
- (void) setNavigationForMode:(NSString*) p_naviMode;
- (IBAction)ButtonPressed:(id)sender;
- (void) saveData;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) collectionEntryUpdated:(NSDictionary *) p_colnUpdateResult;
- (void) printingScreenBack:(NSDictionary*) printInfo;
- (void) sendViewToPrint;
- (void) presentDataForColnId:(NSString*) p_collectionId;
- (void) colnViewDataGenerated:(NSDictionary *)colnInfo;

@end
