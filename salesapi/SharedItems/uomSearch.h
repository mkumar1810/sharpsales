//
//  uomSearch.h
//  salesapi
//
//  Created by Imac on 5/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"

@interface uomSearch : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString *_uomlist;
    NSArray *_dataforDisplay;
    METHODCALLBACK _callbackMethod;
}

- (id)initWithFrame:(CGRect)frame andUOMList:(NSString*) p_uomlist andCallbackMethod:(METHODCALLBACK) p_callback;
- (void) generateData;

@end
