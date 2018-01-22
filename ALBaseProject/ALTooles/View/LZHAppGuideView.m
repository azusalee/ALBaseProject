//
//  LZHAppGuideView.m
//  kuxing
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHAppGuideView.h"
#import "SDCycleScrollView.h"

@interface LZHAppGuideView ()<SDCycleScrollViewDelegate>
{
    
}

@property (nonatomic, strong) SDCycleScrollView *bannerView;



@end

@implementation LZHAppGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupBanner];
    }
    return self;
}


- (void)setupBanner{
    if (!self.bannerView) {
        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) delegate:self placeholderImage:nil];
        self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        self.bannerView.autoScroll = NO;
        self.bannerView.showPageControl = NO;
        self.bannerView.infiniteLoop = NO;
        [self addSubview:self.bannerView];
    }
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"appGuide%d",i+1]];
        [imageArray addObject:image];
    }
    
    [self.bannerView setLocalizationImageNamesGroup:imageArray];
    
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (index == 4) {
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
