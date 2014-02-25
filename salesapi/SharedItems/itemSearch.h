//
//  itemSearch.h
//  salesapi
//
//  Created by Imac on 5/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"


@interface itemSearch : baseSearchForm<UITableViewDelegate, UITableViewDataSource>
{
    int refreshTag;
    NSString *_custcode;
    //NSString *_notificationName;
    METHODCALLBACK _itemReturnMethod;
}
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andCustCode:(NSString*) p_custcode;
- (void) itemListDataGenerated:(NSDictionary *)generatedInfo;
@end


