//
//  bankSearch.h
//  salesapi
//
//  Created by Imac on 4/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface bankSearch :  baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    METHODCALLBACK _returnMethod;
}
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) bankListDataGenerated:(NSDictionary *)generatedInfo;

@end
