//
//  ALPlaceHolderTextView.m
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ALPlaceHolderTextView.h"

@implementation ALPlaceHolderTextView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    self.textView = [[UITextView alloc] initWithFrame:self.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    self.textView.textColor = DarkColor2;
    self.textView.font = DefaultFontOfSize(14);
    [self addSubview:self.textView];
    
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.textView.textContainerInset.top, self.width-16, 20)];
    self.placeHolderLabel.font = DefaultFontOfSize(14);
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    self.placeHolderLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:self.placeHolderLabel];
    
    self.textMaxLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-50, self.height-20, 50, 15)];
    self.textMaxLengthLabel.font = DefaultFontOfSize(12);
    self.textMaxLengthLabel.textColor = GrayColor2;
    self.textMaxLengthLabel.hidden = YES;
    self.textMaxLengthLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:self.textMaxLengthLabel];
    self.textLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-100, self.height-20, 50, 15)];
    self.textLengthLabel.font = DefaultFontOfSize(12);
    self.textLengthLabel.textAlignment = NSTextAlignmentRight;
    self.textLengthLabel.textColor = GrayColor2;
    self.textLengthLabel.hidden = YES;
    self.textLengthLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.textLengthLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)setMaxLength:(NSUInteger)maxLength{
    _maxLength = maxLength;
    
    if (maxLength > 0) {
        self.textMaxLengthLabel.text = [NSString stringWithFormat:@"/%ld",(long)maxLength];
        self.textLengthLabel.hidden = NO;
        self.textMaxLengthLabel.hidden = NO;
        self.textView.height = self.height-20;
        
    }else{
        self.textLengthLabel.hidden = YES;
        self.textMaxLengthLabel.hidden = YES;
        self.textView.height = self.height;
    }
}

- (BOOL)isOverLength{
    if (self.textView.text.length > self.maxLength) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setText:(NSString *)text{
    self.textView.text = text;
    [self textViewDidChange];
}

- (void)textViewDidChange{
    if (self.textView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
    self.textLengthLabel.text = [NSString stringWithFormat:@"%ld",(long)self.textView.text.length];
    if (self.textView.text.length > self.maxLength) {
        self.textLengthLabel.textColor = RedColor1;
    }else{
        self.textLengthLabel.textColor = GrayColor2;
    }
    
    if (self.block) {
        self.block(self.textView.text);
    }
}

@end
