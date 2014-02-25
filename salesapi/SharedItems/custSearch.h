//
//  custSearch.h
//  salesapi
//
//  Created by Raja T S Sekhar on 4/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface custSearch :  baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_salesmancode, *_webdataName, *_cacheName /*,*_gobacknotifyName*/ ;
    METHODCALLBACK _returnMethod;
}
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod forSalesMan:(NSString*) p_salesmancode;
- (void) customerListDataGenerated:(NSDictionary *)generatedInfo;

@end
