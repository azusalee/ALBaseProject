//
//  LZHLunchAdvView.m
//  kuxing
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHLunchAdvView.h"
#import "UIImageView+WebCache.h"

@interface LZHLunchAdvView ()

@property (nonatomic, strong) UIImageView *advImageView;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) NSDictionary *advDict;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger leftTime;
@end

@implementation LZHLunchAdvView



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray* launchNib =  [[NSBundle mainBundle] loadNibNamed:@"LaunchView" owner:nil options:nil];
    UIView *launchView = [launchNib objectAtIndex:0];
    launchView.frame = self.bounds;
    [self addSubview:launchView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    self.advImageView = imageView;
    
    
    UIButton *tapButton = [[UIButton alloc] initWithFrame:self.bounds];
    [tapButton addTarget:self action:@selector(imageDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tapButton];
    
    
    self.dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-50, 25, 35, 20)];
    [self.dismissButton addTarget:self action:@selector(dismissDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.dismissButton.titleLabel.font = DefaultFontOfSize(12);
    self.dismissButton.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.dismissButton];
    
    [self getLunchAdv];
    
    [self startTimer];
    self.leftTime = 2;
    self.dismissButton.hidden = YES;
    
}

- (void)startTimer{
    [self.timer invalidate];
    self.leftTime = 5;
    [self.dismissButton setTitle:[NSString stringWithFormat:@"%ld",self.leftTime] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}

- (void)countDown{
    self.leftTime--;
    if (self.leftTime <= 0) {
        self.leftTime = 0;
        
        [self dismissDidTap:nil];
    }
    [self.dismissButton setTitle:[NSString stringWithFormat:@"%ld",self.leftTime] forState:UIControlStateNormal];
    
}

- (void)getLunchAdv{
//    [HTTPClientInstance postWithAction:ServiceActHome operation:ServiceHomeOpLunchAdv params:nil block:^(NSDictionary *responseObject, NSString *error, long long status, NSError *requestFailed) {
//        if (!requestFailed) {
//            if (status == kResponseCodeSuccess) {
//                NSDictionary *datas = [responseObject safeDictionaryForKey:kResponseData];
//                self.advDict = datas;
//                NSString *adv_pic = [datas safeStringForKey:@"adv_pic"];
//                [self.advImageView sd_setImageWithURL:[NSURL URLWithString:adv_pic] placeholderImage:nil];
//                self.dismissButton.hidden = NO;
//                [self startTimer];
//            }else{
//                //[self dismissDidTap:nil];
//            }
//        }else{
//            //[self dismissDidTap:nil];
//        }
//    }];
}


- (void)imageDidTap:(UIButton*)button{
    if (self.advDict) {
        //NSString *adv_url = [self.advDict safeStringForKey:@"adv_pic_url"];
        [self dismissDidTap:nil];
    }
}


- (void)dismissDidTap:(UIButton*)button{
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.275 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)show{
    [AppDelegateInstance.window addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
