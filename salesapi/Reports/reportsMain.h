//
//  reportsMain.h
//  salesapi
//
//  Created by Imac DOM on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "custSearch.h"
#import "genPrintView.h"


@interface reportsMain : UIViewController
{
    custSearch *smCustSearch;
    UIInterfaceOrientation currOrientation;
    genPrintView *stmtPreview;
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) generateAccountStatement;
- (void) initialize;
- (void) searchCustomerReturn:(NSDictionary *)custInfo;
- (void) printingScreenBack:(NSDictionary*) printInfo;
@end
