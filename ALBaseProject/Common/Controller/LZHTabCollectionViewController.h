//
//  LZHTabCollectionViewController.h
//  MyFrameTest
//
//  Created by Mac on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZHTabCollectionViewController : UIViewController

@property (nonatomic, strong) UICollectionView *tabCollectionView;
@property (nonatomic, strong) UICollectionView *vcCollectionView;

@property (nonatomic, strong) UIView *indicatorView;


@property (nonatomic, assign) CGFloat tabItemWidth;
@property (nonatomic, assign) CGFloat tabItemHeight;

@property (nonatomic, strong) NSArray *tabArray;//
@property (nonatomic, strong) NSArray *vcArray;//与tabArray的个数必须相同

@property (nonatomic, assign) NSInteger curSelectIndex;

@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *normalColor;


@end
