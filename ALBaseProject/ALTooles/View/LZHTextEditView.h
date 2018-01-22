//
//  LZHTextEditView.h
//  youmi
//
//  Created by Mac on 2017/11/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LZHTextEditViewBlock)(NSString *content);


/**
 弹窗textView
 */
@interface LZHTextEditView : UIView


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextView *editTextView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) LZHTextEditViewBlock block;


- (void)setBlock:(LZHTextEditViewBlock)block;
- (void)show;

@end
