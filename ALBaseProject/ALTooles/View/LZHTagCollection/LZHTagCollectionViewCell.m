//
//  LZHTagCollectionViewCell.m
//  zingchat
//
//  Created by index on 16/4/12.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import "LZHTagCollectionViewCell.h"

@implementation TagItemObject


@end

@implementation LZHTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //    UIView *selectedBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    //    UIView *seletedBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    seletedBackGround.backgroundColor = RGBA(0, 0, 0, 0.1);
    //    [selectedBack addSubview:seletedBackGround];
    //    self.selectedBackgroundView = selectedBack;
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.selectedBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.selectedBackgroundImageView.hidden = YES;
    
    [self.contentView addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.selectedBackgroundImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, TagDeleteButtonWidth, 20)];
    [self.deleteButton setImage:[UIImage imageNamed:@"scouting_delete_icon"] forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    
}

- (void)deleteButtonDidTap:(UIButton*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lZHTagCollectionViewCell:deleteWithObject:)]) {
        [self.delegate lZHTagCollectionViewCell:self deleteWithObject:self.tagItem];
    }
}

@end
