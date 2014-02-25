//
//  genPrintView.h
//  salesapi
//
//  Created by Imac on 5/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"
#import "genPrintRenderer.h"


@interface genPrintView : UIView <UIWebViewDelegate>
{
    IBOutlet UIWebView *wv;
    IBOutlet UIActivityIndicatorView *actIndicator;
    UIInterfaceOrientation intOrientation;
    CGRect initialFrame;
    NSString *_colnId,*_reportType, *_idFldName/*,*_notificationName*/;
    IBOutlet UIBarButtonItem *printButton;
    IBOutlet UINavigationItem *navTitle;
    NSMutableData *webData;
    NSDictionary *inputParms;
    METHODCALLBACK _returnMethod;
}

- (id) initWithCollectionId:(NSString*) p_colnid andOrientation:(UIInterfaceOrientation) p_intOrientation andFrame:(CGRect) dispFrame andReporttype:(NSString*) p_reporttype andIdFldName:(NSString*) p_idfldname andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (id) initWithDictionary:(NSDictionary*) p_inputParams andOrientation:(UIInterfaceOrientation) p_intOrientation andFrame:(CGRect) dispFrame andReporttype:(NSString*) p_reporttype  andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) generatePrintView;
- (IBAction) goBack:(id) sender;
- (IBAction) printContents:(id) sender;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe;

@end
