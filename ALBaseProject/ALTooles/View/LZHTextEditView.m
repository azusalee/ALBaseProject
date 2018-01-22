//
//  LZHTextEditView.m
//  youmi
//
//  Created by Mac on 2017/11/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "LZHTextEditView.h"
@interface LZHTextEditView()<UITextViewDelegate>
{
    
}

@end;

@implementation LZHTextEditView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    UIButton *closeButton = [[UIButton alloc] initWithFrame:self.bounds];
    [closeButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-30, 220)];
    
    self.containerView.layer.cornerRadius = 8;
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.clipsToBounds = YES;
    self.containerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-50);
    
    [self addSubview:self.containerView];
    
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.containerView.width, 40)];
    self.titleLabel.font = DefaultFontOfSize(15);
    self.titleLabel.textColor = DarkColor1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.titleLabel];
    
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.containerView.width, 1)];
    sepView.backgroundColor = GrayColor1;
    [self.containerView addSubview:sepView];
    
    
    self.editTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 45, self.containerView.width-30, self.containerView.height-85)];
    self.editTextView.returnKeyType = UIReturnKeyDone;
    self.editTextView.delegate = self;
    
    [self.containerView addSubview:self.editTextView];
    
    
    sepView = [[UIView alloc] initWithFrame:CGRectMake(0, self.containerView.height-41, self.containerView.width, 1)];
    sepView.backgroundColor = GrayColor1;
    [self.containerView addSubview:sepView];
    
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.containerView.height-40, self.containerView.width, 40)];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:ThemeColor forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.confirmButton];
    
    
    
}

- (void)confirmButtonDidTap:(UIButton*)button{
    if (self.block) {
        self.block(self.editTextView.text);
    }
    [self removeFromSuperview];
}

- (void)show{
    [AppDelegateInstance.window addSubview:self];
    [self.editTextView becomeFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    
    return YES;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
