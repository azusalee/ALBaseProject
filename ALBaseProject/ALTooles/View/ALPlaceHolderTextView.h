//
//  ALPlaceHolderTextView.h
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ALPlaceHolderTextViewDidChangeBlock)(NSString *changeValue);

/**
 带站位字符串的TextView
 */
@interface ALPlaceHolderTextView : UIView


@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeHolderLabel;


@property (nonatomic, strong) UILabel *textLengthLabel;
@property (nonatomic, strong) UILabel *textMaxLengthLabel;
/**
 最大可输入字符串长度，为0时隐藏
 */
@property (nonatomic, assign) NSUInteger maxLength;

@property (nonatomic, strong) ALPlaceHolderTextViewDidChangeBlock block;

- (void)setBlock:(ALPlaceHolderTextViewDidChangeBlock)block;


- (BOOL)isOverLength;
- (void)setText:(NSString*)text;

@end
