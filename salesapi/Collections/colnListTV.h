//
//  colnListTV.h
//  salesapi
//
//  Created by Macintosh User on 23/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ssWSProxy.h"

@interface colnListTV : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataForDisplay;
    UIInterfaceOrientation _intOrientation;
    METHODCALLBACK _returnCallBack;
    int _currOffset;
}

- (id)initWithOrientation:(UIInterfaceOrientation) p_intOrientation andCallBack:(METHODCALLBACK) p_callback;
- (void) populateForOffsetDays;
- (void) populateForOffsetDays:(int) p_shift;
- (void) colnCoreDataGenerated:(NSDictionary *)generatedInfo;
- (void) setForOrientation:(UIInterfaceOrientation)p_forOrientation;
- (CGRect) getFrameForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (NSString*) getTitleForDisplay;
@end
