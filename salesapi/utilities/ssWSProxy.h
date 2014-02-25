//
//  ssWSProxy.h
//  salesapi
//
//  Created by Imac DOM on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defaults.h"

@interface ssWSProxy : NSObject <NSXMLParserDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSString *_reportType;
	NSMutableData *webData;
    NSXMLParser *xmlParser; 
	NSMutableString *parseElement,*value;
    NSMutableString *respcode, *respmessage;
    NSMutableDictionary *resultDataStruct;
    NSMutableArray *dictData;
    //NSString *_notificationName;
    NSDictionary *inputParms;
    METHODCALLBACK _proxyReturnMethod;
}

- (void) initWithReportType:(NSString*) reportType andInputParams:(NSDictionary*) prmDict andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) generateData;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) processAndReturnXMLMessage;
-(NSString *)htmlEntityDecode:(NSString *)string;
-(NSString *)htmlEntitycode:(NSString *)string;
- (void) returnErrorMessage:(NSString*) p_errmsg;

@end
