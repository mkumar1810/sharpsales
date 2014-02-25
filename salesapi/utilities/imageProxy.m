//
//  imageProxy.m
//  salesapi
//
//  Created by Macintosh User on 28/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "imageProxy.h"

@implementation imageProxy

- (void) initWithFileName:(NSString*) p_fileName andReturnMethod:(METHODCALLBACK) p_returnMethod
{
    _fileName = p_fileName;
    _proxyReturnMethod = p_returnMethod;
    [self generateData];
}

- (void) generateData
{
    NSURL *url;
    NSMutableURLRequest *theRequest;
    NSURLConnection *theConnection;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyyhhmmss"];
    //NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/Images/%@?currtime=%@",MAIN_URL, WS_ENV, _fileName,[dateFormatter stringFromDate:[NSDate date]]]];
    //NSLog(@"the url is %@", url);
    theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection)
        webData = [[NSMutableData data] init];
    else 
        [self returnErrorMessage:@"Error in Connection"];
    //NSLog(@"theConnection is NULL");
}

- (void) returnErrorMessage:(NSString*) p_errmsg
{
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"RESPONSECODE", p_errmsg, @"RESPONSEMESSAGE", nil];
    NSMutableArray *retArray = [[NSMutableArray alloc] initWithObjects:retDict, nil];
    NSDictionary *retInfo = [NSDictionary dictionaryWithObjectsAndKeys:retArray,@"data", nil];
    _proxyReturnMethod(retInfo);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData *retdata = [webData copy];
    NSMutableDictionary *retInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:retdata,@"data", _fileName, @"filename", nil];
    _proxyReturnMethod(retInfo);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *errmsg = [error description];
    [self returnErrorMessage:errmsg];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}

@end
