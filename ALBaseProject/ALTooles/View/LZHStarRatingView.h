//
//  LZHStarRatingView.h
//  kuxing
//
//  Created by mac on 17/3/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


#define LZHStarNormalName @"ratingNormalStar"
#define LZHStarHighLightName @"ratingHighlightStar"

typedef void (^LZHStarRatingViewDidChangeBlock)(double changeValue);

@interface LZHStarRatingView : UIView


+ (instancetype)createViewStarCount:(NSUInteger)count starWidth:(CGFloat)starWidth itemSpace:(CGFloat)itemSpace;


@property (nonatomic, assign) CGFloat itemSpace;
@property (nonatomic, assign) CGFloat starWidth;
@property (nonatomic, assign) double currentValue; //0-1
@property (nonatomic, assign) BOOL isShowValue;

@property (nonatomic, strong) LZHStarRatingViewDidChangeBlock block;

- (void)setBlock:(LZHStarRatingViewDidChangeBlock)block;

- (void)setSelImage:(UIImage*)image;
- (void)setNorImage:(UIImage*)image;

@end
