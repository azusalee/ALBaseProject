//
//  ALCountTextField.h
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 带字数限制的textField
 */
@interface ALCountTextField : UITextField

@property (nonatomic, assign) NSUInteger maxLength;

@end
