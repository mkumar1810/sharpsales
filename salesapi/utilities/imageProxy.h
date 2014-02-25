//
//  imageProxy.h
//  salesapi
//
//  Created by Macintosh User on 28/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defaults.h"

@interface imageProxy : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSString *_fileName;
	NSMutableData *webData;
    NSXMLParser *xmlParser; 
    METHODCALLBACK _proxyReturnMethod;
}

- (void) initWithFileName:(NSString*) p_fileName andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) generateData;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) returnErrorMessage:(NSString*) p_errmsg;

@end
