//
//  defaults.h
//  dssapi
//
//  Created by Raja T S Sekhar on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WS_ENV @"AAHGWS"
#define MAIN_URL @"http://194.170.6.30/"
//#define MAIN_URL @"http://192.168.1.8/"
#define NO_OF_DAYS_FOR_LINECHART 120
#define M_PI        3.14159265358979323846264338327950288   /* pi */
#define M_PI_BY_2      1.57079632679489661923132169163975144   /* pi/2 */
#define M_PI_BY_4      0.785398163397448309615660845819875721  /* pi/4 */
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0
#define soMasterXML @"<MASTERDATA><SOID>%@</SOID><SONO>%@</SONO><CUSTCODE>%@</CUSTCODE><ENQMODE>%d</ENQMODE><IMPORTANCE>%d</IMPORTANCE><CUSTREFNO>%@</CUSTREFNO><CUSTREFDATE>%@</CUSTREFDATE><QUOTEDATE>%@</QUOTEDATE><DELYDATE>%@</DELYDATE><DELYAT>%@</DELYAT><NOTES>%@</NOTES><DIVCODE>%@</DIVCODE><SMCODE>%@</SMCODE><PAYTERMCODE>%@</PAYTERMCODE><TOTALAMOUNT>%f</TOTALAMOUNT></MASTERDATA>"
#define soDetailXML @"<DETAILDATA><SODETAILID>%@</SODETAILID><SOID>%@</SOID><ITEMCODE>%@</ITEMCODE><UOMCODE>%@</UOMCODE><QTY>%@</QTY><RATE>%@</RATE><NOTES>%@</NOTES></DETAILDATA>"
#define colnDataXML @"<COLLECTION><COLNID>%@</COLNID><CUSTCODE>%@</CUSTCODE><AMOUNT>%@</AMOUNT><PAYMODE>%d</PAYMODE><CHEQUENO>%@</CHEQUENO><CHEQUEDATE>%@</CHEQUEDATE><BANKCODE>%@</BANKCODE><INVOICENO>%@</INVOICENO><REMARKS>%@</REMARKS><USERCODE>%@</USERCODE><GIVENBY>%@</GIVENBY><CONTACTNO>%@</CONTACTNO></COLLECTION>"
#define kTextFieldHeight		30.0

// Toolbar height when printing is supported
#define kToolbarHeight          48
#define LOGIN_URL @"/collectionEntry.asmx?op=userLogin"
#define ITEMLIST_URL @"/collectionEntry.asmx?op=getItemNamesList"
#define BANKLIST_URL @"/collectionEntry.asmx?op=getBankNamesList"
#define CUSTOMERLIST_URL @"/collectionEntry.asmx?op=getCustomerList"
#define CUSTOMERLISTFORSM_URL @"/collectionEntry.asmx?op=getCustomerListForSalesMan"
#define UOMList_URL @"/collectionEntry.asmx?op=getUOMDescList"
#define DIVLIST_URL @"/collectionEntry.asmx?op=getDivisionNamesList"
#define PAYTERMLIST_URL @"/collectionEntry.asmx?op=getPaymenttermNamesList"
#define SALESMANLIST_URL @"/collectionEntry.asmx?op=getSalesmanNamesList"
#define DATAFORSO_URL @"/salesorder.asmx?op=getDataForSalesOrerId"
#define SOSUBMIT_URL @"/salesorder.asmx?op=addUpdSOWithSignature"
//#define SOSUBMIT_URL @"/salesorder.asmx?op=addUpdateSalesOrder"
#define SOOFFSETDAYLIST_URL @"/salesorder.asmx?op=salesOrderListTodayWithOffset"
#define COLLECTIONOFFSETDAYLIST_URL @"/collectionEntry.asmx?op=collectionDetailsTodayWithOffset"
//#define COLLECTIONADDUPDATE_URL @"/collectionEntry.asmx?op=addUpdateCollection"
#define COLLECTIONADDUPDATE_URL @"/collectionentry.asmx?op=addUpdColnWithSign"
#define COLLECTIONVIEW_URL @"/collectionEntry.asmx?op=getCollectionDetailsforID"
#define GETIMAGESTRING_URL @"/salesorder.asmx?op=getImageString"

typedef void (^METHODCALLBACK) (NSDictionary*);

@interface defaults : NSObject {
    
}

@end
