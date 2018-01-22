//
//  WaterFlowCollectionViewLayout.h
//  kuxing
//
//  Created by mac on 17/5/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFlowCollectionViewLayout;
@protocol WaterFlowCollectionViewLayoutDelegate <NSObject>

- (CGFloat)flowLayout:(WaterFlowCollectionViewLayout *)flowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFlowCollectionViewLayout : UICollectionViewLayout


/** 列间距 */
@property(nonatomic,assign)CGFloat columnMargin;
/** 行间距 */
@property(nonatomic,assign)CGFloat rowMargin;
/** 列数 */
@property(nonatomic,assign)int columnsCount;
/** 外边距 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, weak) id<WaterFlowCollectionViewLayoutDelegate> delegate;

@end
