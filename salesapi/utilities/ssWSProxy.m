//
//  ssWSProxy.m
//  salesapi
//
//  Created by Imac DOM on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ssWSProxy.h"

@implementation ssWSProxy
- (void) initWithReportType:(NSString*) reportType andInputParams:(NSDictionary*) prmDict andReturnMethod:(METHODCALLBACK) p_returnMethod
{
    /*self = [super init];
    if (self) {*/
        _reportType = [[NSString alloc] initWithFormat:@"%@", reportType];
        //_notificationName = [[NSString alloc] initWithFormat:@"%@", notificationName];
        _proxyReturnMethod = p_returnMethod;
        if (prmDict) 
            inputParms = [[NSDictionary alloc] initWithDictionary:prmDict];
        dictData = [[NSMutableArray alloc] init];
        [self generateData];
    /*}
    return self;    */
}

- (void) generateData
{
    NSString *soapMessage,*msgLength,*soapAction;
    NSURL *url;
    NSMutableURLRequest *theRequest;
    NSURLConnection *theConnection;
    

    if ([_reportType isEqualToString:@"CUSTOMERSLISTFORSM"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getCustomerListForSalesMan xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_searchtext>%@</p_searchtext>\n"
                       "<p_salesmancode>%@</p_salesmancode>\n"
                       "</getCustomerListForSalesMan>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_searchtext"],[inputParms valueForKey:@"p_salesmancode"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, CUSTOMERLISTFORSM_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getCustomerListForSalesMan"];
    }
    
    
    if ([_reportType isEqualToString:@"DATAFORSOID"]) {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getDataForSalesOrerId xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_soid>%@</p_soid>\n"
                       "</getDataForSalesOrerId>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_soid"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, DATAFORSO_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getDataForSalesOrerId"];
    }

    if ([_reportType isEqualToString:@"SOSUBMIT"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdSOWithSignature xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_sodata>%@</p_sodata>\n"
                       "<p_smsign>%@</p_smsign>\n"
                       "<p_custsign>%@</p_custsign>\n"
                       "</addUpdSOWithSignature>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[self htmlEntitycode:[inputParms valueForKey:@"p_sodata"]],[inputParms valueForKey:@"p_smsign"],[inputParms valueForKey:@"p_custsign"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, SOSUBMIT_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/addUpdSOWithSignature"];
        //NSLog(@"soapmessage %@ and url is %@ and soapaction is %@",soapMessage,url,soapAction);
    }

    /*if ([_reportType isEqualToString:@"SOSUBMIT"]) -- old call wihout signature
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdateSalesOrder xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_sodata>%@</p_sodata>\n"
                       "</addUpdateSalesOrder>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[self htmlEntitycode:[inputParms valueForKey:@"p_sodata"]]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, SOSUBMIT_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/addUpdateSalesOrder"];
        //NSLog(@"soapmessage %@ and url is %@ and soapaction is %@",soapMessage,url,soapAction);
    }*/
    
    if ([_reportType isEqualToString:@"PAYTERMLIST"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getPaymenttermNamesList xmlns=\"http://aahg.ws.org/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, PAYTERMLIST_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getPaymenttermNamesList"];
        
    }
    if ([_reportType isEqualToString:@"SALESMANLIST"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getSalesmanNamesList xmlns=\"http://aahg.ws.org/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, SALESMANLIST_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getSalesmanNamesList"];
        
    }
        
    if ([_reportType isEqualToString:@"DIVLIST"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getDivisionNamesList xmlns=\"http://aahg.ws.org/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, DIVLIST_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getDivisionNamesList"];
        
    }

    if ([_reportType isEqualToString:@"UOMLIST"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getUOMDescList xmlns=\"http://aahg.ws.org/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, UOMList_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getUOMDescList"];

    }
    
    if ([_reportType isEqualToString:@"SOITEMSLIST"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getItemNamesList xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_custcode>%@</p_custcode>\n"
                       "<p_searchtext>%@</p_searchtext>\n"
                       "</getItemNamesList>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_custcode"],[inputParms valueForKey:@"p_searchtext"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, ITEMLIST_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getItemNamesList"];
    }
    
    if ([_reportType isEqualToString:@"COLLECTIONVIEW"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getCollectionDetailsforID xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_collectionid>%@</p_collectionid>\n"
                       "</getCollectionDetailsforID>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_collectionid"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, COLLECTIONVIEW_URL]];
        //NSLog(@"collection view url is %@", url);
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getCollectionDetailsforID"];

    }

    if ([_reportType isEqualToString:@"COLNSUBMIT"])
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdColnWithSign xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_colndata>%@</p_colndata>\n"
                       "<p_smsign>%@</p_smsign>\n"
                       "<p_gbsign>%@</p_gbsign>\n"
                       "<p_chqphoto>%@</p_chqphoto>\n"
                       "</addUpdColnWithSign>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[self htmlEntitycode:[inputParms valueForKey:@"p_colndata"]],[inputParms valueForKey:@"p_smsign"], [inputParms valueForKey:@"p_gbsign"],[inputParms valueForKey:@"p_chqphoto"]];
         
         url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, COLLECTIONADDUPDATE_URL]];
         
         soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/addUpdColnWithSign"];
         //sNSLog(@"soapmessage %@ and url is %@ and soapaction is %@",soapMessage,url,soapAction);
     }

    /*if ([_reportType isEqualToString:@"COLNSUBMIT"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdateCollection xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_colndata>%@</p_colndata>\n"
                       "</addUpdateCollection>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[self htmlEntitycode:[inputParms valueForKey:@"p_colndata"]]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, COLLECTIONADDUPDATE_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/addUpdateCollection"];
        //sNSLog(@"soapmessage %@ and url is %@ and soapaction is %@",soapMessage,url,soapAction);
    }*/
    
    if ([_reportType isEqualToString:@"BANKLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getBankNamesList xmlns=\"http://aahg.ws.org/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, BANKLIST_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getBankNamesList"];
    }
    if ([_reportType isEqualToString:@"CUSTOMERSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getCustomerList xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_searchtext>%@</p_searchtext>\n"
                       "<p_noofrecs>%@</p_noofrecs>\n"
                       "<p_lastcode>%@</p_lastcode>\n"
                       "</getCustomerList>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_searchtext"],[inputParms valueForKey:@"p_noofrecs"],[inputParms valueForKey:@"p_lastcode"]];

        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, CUSTOMERLIST_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/getCustomerList"];
    }
    if ([_reportType isEqualToString:@"USERLOGIN"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "<userLogin xmlns=\"http://aahg.ws.org/\">\n"
                               "<p_eMail>%@</p_eMail>\n"
                               "<p_passWord>%@</p_passWord>\n"
                               "</userLogin>\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>", [inputParms valueForKey:@"p_eMail"],[inputParms valueForKey:@"p_passWord"]];     
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, LOGIN_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/userLogin"];
    }
    
    if ([_reportType isEqualToString:@"COLLECTIONSTODAYLIST"]==YES) 
     {
         soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                        "<soap:Body>\n"
                        "<collectionDetailsTodayWithOffset xmlns=\"http://aahg.ws.org/\">\n"
                        "<p_offsetday>%@</p_offsetday>\n"
                        "</collectionDetailsTodayWithOffset>\n"
                        "</soap:Body>\n"
                        "</soap:Envelope>", [inputParms valueForKey:@"p_offsetday"]];
         url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, COLLECTIONOFFSETDAYLIST_URL]];
         soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/collectionDetailsTodayWithOffset"];
     }
    
    if ([_reportType isEqualToString:@"SALESORDERLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<salesOrderListTodayWithOffset xmlns=\"http://aahg.ws.org/\">\n"
                       "<p_offsetday>%@</p_offsetday>\n"
                       "</salesOrderListTodayWithOffset>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>", [inputParms valueForKey:@"p_offsetday"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, SOOFFSETDAYLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://aahg.ws.org/salesOrderListTodayWithOffset"];
    }
    
    theRequest = [NSMutableURLRequest requestWithURL:url];
    msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    [self processAndReturnXMLMessage];
    //[connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *errmsg = [error description];
    [self returnErrorMessage:errmsg];
    //[self showAlertMessage:errmsg];
    //[connection release];
    //[webData release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict   
{
    [parseElement setString:elementName];
    if ([elementName isEqualToString:@"Table"]) {
        resultDataStruct = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([parseElement isEqualToString:@""]==NO) 
        [resultDataStruct setValue:string forKey:parseElement];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [parseElement setString:@""];
    if ([elementName isEqualToString:@"Table"]) 
    {
        if (resultDataStruct) {
            [dictData addObject:resultDataStruct];
            //[resultDataStruct release];
        }
    }
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
}

- (void) processAndReturnXMLMessage
{
    parseElement = [[NSMutableString alloc] initWithString:@""];	
	NSString *theXML = [self htmlEntityDecode:[[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding]];
    //NSLog(@"the data received %@",theXML);
    if (theXML) {
        if ([theXML isEqualToString:@""]==YES) 
        {
            [self returnErrorMessage:@"Web service failure"];
            //[self showAlertMessage:@"Web service failure"];
            //[webData release];
            return;
        }
    }
    else
    {
        [self returnErrorMessage:@"Web service failure"];
        //[self showAlertMessage:@"Web service failure"];
        //[webData release];
        return;
    }
    /*xmlParser = [[NSXMLParser alloc] initWithData:webData];*/
    @try 
    {
        xmlParser = [[NSXMLParser alloc] initWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding]];
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        [xmlParser parse];
        //[xmlParser release];
    }
    @catch (NSException *exception) {
        [self showAlertMessage:[exception description]];
        //[webData release];
        return;
    }
    
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:dictData forKey:@"data"];
    //NSLog(@"the report type %@ and inputs are %@", _reportType, inputParms);
    //[[NSNotificatxionCenter defaultCenter] postNotifxicationName:_notificationName object:self userInfo:returnInfo];
    _proxyReturnMethod(returnInfo);
    //[webData release];
}

-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return string;
}

-(NSString *)htmlEntitycode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return string;
}

@end
