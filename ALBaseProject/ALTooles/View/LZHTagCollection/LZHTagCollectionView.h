//
//  LZHTagCollectionView.h
//  zingchat
//
//  Created by index on 16/4/12.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZHTagCollectionViewCell.h"
@class LZHTagCollectionView;

@interface TagLayout : NSObject

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectTextColor;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *selectBackgroundColor;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat insideSpace;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) BOOL canDelete;
@property (nonatomic, assign) CGFloat minItemWidth; //default 0,
@property (nonatomic, assign) CGFloat corenerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) BOOL isRandomBigFont;
@property (nonatomic, assign) NSInteger maxStringLength;
@property (nonatomic, assign) BOOL isCenterLayout;
@property (nonatomic, assign) BOOL isSort;

@end


@protocol LZHTagCollectionViewDelegate <NSObject>

- (void)lZHTagCollectionView:(LZHTagCollectionView*)view didSelectWithObject:(TagItemObject*)object;
- (void)lZHTagCollectionView:(LZHTagCollectionView*)view didDelectWithObject:(TagItemObject*)object;

@end

@interface LZHTagCollectionView : UIView

@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, weak) id<LZHTagCollectionViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andTagLayout:(TagLayout*)tagLayout;

- (void)addTagArray:(NSArray<TagItemObject*>*)array;
- (void)setTagArray:(NSArray<TagItemObject*>*)array;

@end
