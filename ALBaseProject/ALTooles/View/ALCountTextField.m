//
//  ALCountTextField.m
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ALCountTextField.h"

@interface ALCountTextField (){
    
}

@property (nonatomic,strong) UILabel *lengthLabel;

@end

@implementation ALCountTextField


-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    
    [self addTarget:self action:@selector(textFiledTextValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
}

- (void)setMaxLength:(NSUInteger)maxLength{
    _maxLength = maxLength;
    
    if (maxLength > 0) {
        if (!self.lengthLabel) {
            self.lengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, self.height)];
            self.lengthLabel.font = DefaultFontOfSize(14);
            self.lengthLabel.textColor = GrayColor2;
            self.lengthLabel.textAlignment = NSTextAlignmentRight;
            
        }
        self.lengthLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.text.length,(long)self.maxLength];
        self.rightView = self.lengthLabel;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        
    }else{
        self.rightView = nil;
        self.rightViewMode = UITextFieldViewModeNever;
    }
}

- (void)textFiledTextValueDidChange:(UITextField*)textField{
    if (self.maxLength > 0) {
        self.lengthLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)textField.text.length,(long)self.maxLength];
        if (textField.text.length > self.maxLength) {
            self.lengthLabel.textColor = RedColor1;
        }else{
            self.lengthLabel.textColor = GrayColor2;
        }
    }
}


- (void)setText:(NSString *)text{
    [super setText:text];
    if (self.maxLength > 0) {
        self.lengthLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.text.length,(long)self.maxLength];
        if (self.text.length > self.maxLength) {
            self.lengthLabel.textColor = RedColor1;
        }else{
            self.lengthLabel.textColor = GrayColor2;
        }
    }
    
}

@end
