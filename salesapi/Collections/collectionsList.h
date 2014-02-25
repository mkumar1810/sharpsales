//
//  collectionsList.h
//  salesapi
//
//  Created by Raja T S Sekhar on 4/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "colnDataEntry.h"

@interface collectionsList : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    colnDataEntry *cde;
    int _offsetday;
    IBOutlet UILabel *lblCollectionTitle;
    METHODCALLBACK _cdeReturnMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) setTitleForDisplay;
- (void) colnCoreDataGenerated:(NSDictionary *)generatedInfo;
- (void) collectionEntryAdded:(NSDictionary *)colnInfo;

@end
