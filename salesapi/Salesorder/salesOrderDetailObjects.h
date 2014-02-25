//
//  salesOrderDetailObjects.h
//  salesapi
//
//  Created by Imac on 5/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defaults.h"

@interface salesOrderDetailObjects :NSObject <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIAlertViewDelegate>
{
    UITableView *entryTV;
    UITextField  *txtItemCode, *txtItemName,*txtUOM, *txtQty, *txtRate, *txtNotes;
    NSString *itemName, *itemCode, *uomVal, *uomCode, *qty, *rate,*notes,*_uomdesc,*_uomlist,*_detailEntryId;
    CGPoint scrollOffset;
    CGRect initialFrame;
    UIScrollView *_parentScroll;
    UIInterfaceOrientation intOrientation;
    NSDictionary *_initialData;
    NSString *_dispMode;
    int _noofUOMs, _editItemSeqNo;
    METHODCALLBACK _itemReturnMethod, _uomReturnMethod;
}
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode andItemMethod:(METHODCALLBACK) p_ItemMethod andUOMMethod:(METHODCALLBACK) p_uomMethod;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) generateTableView;
- (void) storeDispValues;
- (void) displayDictDataForMode:(NSString*) p_dispmode;
- (void) setItemValues:(NSDictionary*) itemInfo;
- (void) setEditMode;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) setUOMValues:(NSDictionary*) uomInfo;
- (NSDictionary*) getEnteredDetails;
- (NSDictionary*) validateData;
- (BOOL) isNumericValue:(NSString*) p_passedval;
@end
