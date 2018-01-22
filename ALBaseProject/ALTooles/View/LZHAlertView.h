//
//  LZHAlertView.h
//  kuxing
//
//  Created by mac on 17/3/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LZHAlertViewBlock)(NSInteger index, NSString *title);//-1为取消

/**
 自定义弹窗提示
 */
@interface LZHAlertView : UIView

/**
 单例
 */
+ (instancetype)sharedLoginAlert;

/**
 非单例
 */
+ (instancetype)createWithTitleArray:(NSArray*)array;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, readonly) NSArray<NSString*> *actionTitleArray;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) LZHAlertViewBlock block;


- (void)setBlock:(LZHAlertViewBlock)block;
- (void)show;
- (void)hide;

- (NSArray*)getActionButtonArray;

@end
