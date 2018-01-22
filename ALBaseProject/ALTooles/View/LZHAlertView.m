//
//  LZHAlertView.m
//  kuxing
//
//  Created by mac on 17/3/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHAlertView.h"
@interface LZHAlertView()
{
    
}


@property (nonatomic, strong) UIView *actionContainerView;

@property (nonatomic, strong) NSMutableArray *actionButtons;

@end


@implementation LZHAlertView


+ (instancetype)sharedLoginAlert
{
    static LZHAlertView *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [self createWithTitleArray:@[@"确定"]];
    });
    
    return _sharedInstance;
}

+ (instancetype)createWithTitleArray:(NSArray *)array{
    LZHAlertView *view = [[LZHAlertView alloc] initWithFrame:ScreenBounds];
    view->_actionTitleArray = array;
    [view setup];
    return view;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)setup{
    
    self.frame = ScreenBounds;
    self.backgroundColor = RGBA(0, 0, 0, 0.8);
    UIButton *maskButton = [[UIButton alloc] initWithFrame:ScreenBounds];
    [maskButton addTarget:self action:@selector(cancelDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskButton];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(25, 0, ScreenWidth-50, 250)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat actionHeight = 50;
    UIColor *actionTitleColor = DarkColor2;
    UIImage *selectBackImage = [ALFuncTooles createImageWithColor:RGBA(0, 0, 0, 0.1)];
    UIView *actionContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.containerView.height-50, self.containerView.width, actionHeight)];
    actionContainerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    actionContainerView.backgroundColor = [UIColor whiteColor];
    actionContainerView.clipsToBounds = YES;
    actionContainerView.layer.cornerRadius = 8;
    
    self.actionButtons = [[NSMutableArray alloc] init];
    if (self.actionTitleArray.count > 0) {
        CGFloat actionWidth = actionContainerView.width/self.actionTitleArray.count;
        for (int i = 0; i < self.actionTitleArray.count; ++i) {
            NSString *string = self.actionTitleArray[i];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(actionWidth*i, 0, actionWidth, actionHeight)];
            button.tag = 100+i;
            [button addTarget:self action:@selector(actionDidTap:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:string forState:UIControlStateNormal];
            [button setTitleColor:actionTitleColor forState:UIControlStateNormal];
            [button setBackgroundImage:selectBackImage forState:UIControlStateHighlighted];
            UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(actionWidth, 0, 1, actionHeight)];
            sepView.backgroundColor = GrayColor1;
            [button addSubview:sepView];
            [actionContainerView addSubview:button];
            [self.actionButtons addObject:button];
        }
    }
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actionContainerView.width, 1)];
    sepView.backgroundColor = GrayColor1;
    [actionContainerView addSubview:sepView];
    self.actionContainerView = actionContainerView;
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.containerView.width-30, self.containerView.height-actionHeight)];
    self.contentLabel.textColor = DarkColor2;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = DefaultFontOfSize(16);
    [self.containerView addSubview:self.contentLabel];
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:actionContainerView];
    self.containerView.center = CGPointMake(self.width/2, self.height/2);
}


- (void)show{
    [AppDelegateInstance.window addSubview:self];
    
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)actionDidTap:(UIButton*)button{
    NSInteger index = button.tag-100;
    if (self.block) {
        self.block(index, button.titleLabel.text);
    }
    
}

- (void)cancelDidTap:(UIButton*)button{
    if (self.block) {
        self.block(-1, button.titleLabel.text);
    }
}

- (NSArray *)getActionButtonArray{
    return [NSArray arrayWithArray:self.actionButtons];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
