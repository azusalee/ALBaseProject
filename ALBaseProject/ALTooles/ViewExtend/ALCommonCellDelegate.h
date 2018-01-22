//
//  CommonCellDelegate.h
//  kuxing
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : long{
    CellActionTypeCommonAction1 = 9100,
    CellActionTypeCommonAction2 = 9101,
    CellActionTypeCommonAction3 = 9102,
    CellActionTypeCommonAction4 = 9103,
    CellActionTypeCommonAction5 = 9104,
    CellActionTypeCommonAction6 = 9105,
    CellActionTypeCommonWeb = 10000,
}CellActionType;

@protocol ALCommonCellDelegate <NSObject>

- (void)buttonDidTap:(id)view withType:(CellActionType)actionType andObject:(id)object;
@end

