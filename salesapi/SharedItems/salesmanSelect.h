//
//  salesmanSelect.h
//  salesapi
//
//  Created by Imac on 5/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"


@interface salesmanSelect : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    //NSString *_notificationName;
    METHODCALLBACK _returnMethod;
}
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) salesmanListDataGenerated:(NSDictionary *)generatedInfo;

@end
