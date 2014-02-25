//
//  salesorderList.h
//  salesapi
//
//  Created by Imac on 4/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "salesOrderDataEntry.h"

@interface salesOrderList : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    salesOrderDataEntry *sode;
    int _offsetday;
    IBOutlet UILabel *lblSalesOrderTitle;
    METHODCALLBACK _soModifyComplete;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) setTitleForDisplay;
- (void) salesOrderCoreDataGenerated:(NSDictionary *)generatedInfo;
- (void) salesOrderEntryAddedModified:(NSDictionary *)salesorderInfo;
@end
