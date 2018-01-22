//
//  LZHTagCollectionViewCell.h
//  zingchat
//
//  Created by index on 16/4/12.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TagDeleteButtonWidth 20.0f
@class LZHTagCollectionViewCell;

@interface TagItemObject : NSObject

@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) id tagObject;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, assign) long long type;

@end

@protocol LZHTagCollectionViewCellDelegate <NSObject>

- (void)lZHTagCollectionViewCell:(LZHTagCollectionViewCell*)cell deleteWithObject:(TagItemObject*)itemObject;

@end

@interface LZHTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) TagItemObject *tagItem;
@property (nonatomic, strong) UIImageView *selectedBackgroundImageView;
@property (nonatomic, assign) BOOL isSetLayout;


@property (nonatomic, weak) id<LZHTagCollectionViewCellDelegate> delegate;


@end
