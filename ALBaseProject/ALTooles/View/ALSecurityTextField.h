//
//  ALSecurityTextField.h
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^ALSecurityTextFieldDidFinsihBlock)(NSString *codeString);

/**
 用于输入6位数字密码的textField
 */
@interface ALSecurityTextField : UIView

@property (nonatomic, strong) UITextField *textField;


/**
 是否明文显示密码
 */
@property (nonatomic, assign) BOOL isShowPass;

/**
 输入6位密码后调用
 */
@property (nonatomic, strong) ALSecurityTextFieldDidFinsihBlock block;


- (void)setBlock:(ALSecurityTextFieldDidFinsihBlock)block;

- (void)updateCode;

@end
