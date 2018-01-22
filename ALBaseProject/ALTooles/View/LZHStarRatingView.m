//
//  LZHStarRatingView.m
//  kuxing
//
//  Created by mac on 17/3/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHStarRatingView.h"


@interface LZHStarRatingView (){
    
}

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *normalView;
@property (nonatomic, strong) NSArray *selectStarArray;
@property (nonatomic, strong) NSArray *normalStarArray;
@property (nonatomic, assign) NSUInteger maxStarCount;
@property (nonatomic, strong) UILabel *currentValueLabel;

@end

@implementation LZHStarRatingView


- (void)awakeFromNib{
    [super awakeFromNib];
    _itemSpace = 4;
    _starWidth = 14;
    _maxStarCount = 5;
    _currentValue = 1;
    [self setup];
}

+ (instancetype)createViewStarCount:(NSUInteger)count starWidth:(CGFloat)starWidth itemSpace:(CGFloat)itemSpace{
    LZHStarRatingView *starView = [[LZHStarRatingView alloc] init];
    starView.maxStarCount = count;
    starView->_itemSpace = itemSpace;
    starView->_starWidth = starWidth;
    [starView setup];
    return starView;
}


- (void)setup{
    
    self.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.maxStarCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(self.starWidth+self.itemSpace), 0, self.starWidth, self.starWidth)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:LZHStarNormalName];
        
        [tempArray addObject:imageView];
        [view addSubview:imageView];
    }
    view.size = CGSizeMake((self.starWidth+self.itemSpace)*self.maxStarCount-self.itemSpace, self.starWidth);
    self.normalStarArray = [NSArray arrayWithArray:tempArray];
    self.normalView = view;
    [self addSubview:view];
    
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.maxStarCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(self.starWidth+self.itemSpace), 0, self.starWidth, self.starWidth)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:LZHStarHighLightName];
        [tempArray addObject:imageView];
        [view addSubview:imageView];
    }
    view.size = CGSizeMake((self.starWidth+self.itemSpace)*self.maxStarCount-self.itemSpace, self.starWidth);
    self.selectStarArray = [NSArray arrayWithArray:tempArray];
    self.selectView = view;
    [self addSubview:view];
    
    self.currentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, self.starWidth)];
    self.currentValueLabel.font = DefaultFontOfSize(11);
    self.currentValueLabel.textColor = GrayColor2;
    [self addSubview:self.currentValueLabel];
    self.currentValueLabel.left = self.normalView.right+self.itemSpace;
    
    //self.height = self.normalView.height;
    [self setIsShowValue:self.isShowValue];
    self.normalView.centerY = self.height/2;
    self.selectView.centerY = self.height/2;
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
    [self addGestureRecognizer:tapGR];
}


- (void)viewDidTap:(UITapGestureRecognizer*)tapGR{
    
    CGPoint locationInView = [tapGR locationInView:self.normalView];
    CGFloat value = 0;
    if (self.normalView.width > 0) {
        value = locationInView.x/self.normalView.width;
    }
    [self setCurrentValue:value];
    
}

- (void)setItemSpace:(CGFloat)itemSpace{
    if (_itemSpace != itemSpace) {
        _itemSpace = itemSpace;
        for (int i = 0; i < self.maxStarCount; i++) {
            UIImageView *normalImageView = self.normalStarArray[i];
            normalImageView.left = i*(self.starWidth+self.itemSpace);
            UIImageView *selectImageView = self.selectStarArray[i];
            selectImageView.left = i*(self.starWidth+self.itemSpace);
            
        }
        self.normalView.size = CGSizeMake((self.starWidth+self.itemSpace)*self.maxStarCount-self.itemSpace, self.starWidth);
        [self setIsShowValue:_isShowValue];
        [self setCurrentValue:_currentValue];
    }
}


- (void)setStarWidth:(CGFloat)starWidth{
    if (_starWidth != starWidth) {
        _starWidth = starWidth;
        for (int i = 0; i < self.maxStarCount; i++) {
            UIImageView *normalImageView = self.normalStarArray[i];
            normalImageView.left = i*(self.starWidth+self.itemSpace);
            normalImageView.size = CGSizeMake(starWidth, starWidth);
            UIImageView *selectImageView = self.selectStarArray[i];
            selectImageView.left = i*(self.starWidth+self.itemSpace);
            selectImageView.size = CGSizeMake(starWidth, starWidth);
            
        }
        self.normalView.size = CGSizeMake((self.starWidth+self.itemSpace)*self.maxStarCount-self.itemSpace, self.starWidth);
        self.selectView.height = starWidth;
        [self setIsShowValue:_isShowValue];
        [self setCurrentValue:_currentValue];
    }
}


- (void)setIsShowValue:(BOOL)isShowValue{
    _isShowValue = isShowValue;
    if (isShowValue) {
        self.width = self.normalView.width;
        self.currentValueLabel.hidden = NO;
    }else{
        self.width = self.currentValueLabel.right;
        self.currentValueLabel.hidden = YES;
    }
}

- (void)setCurrentValue:(double)currentValue{
    if (currentValue < 0) {
        currentValue = 0;
    }
    if (currentValue >= 1) {
        currentValue = 1;
    }else{
        
        
        
        currentValue = ((long long)(_maxStarCount*currentValue+1))/5.0f;
    }
    _currentValue = currentValue;
    if (_currentValue > 1) {
        _currentValue = 1;
    }
    
    self.selectView.width = self.normalView.width*_currentValue;
    self.currentValueLabel.text = [NSString stringWithFormat:@"%0.1f",self.maxStarCount*_currentValue];
    
    if (self.block) {
        self.block(_currentValue);
    }
    
}

- (void)setSelImage:(UIImage *)image{
    for (UIImageView *imageView in self.selectStarArray) {
        imageView.image = image;
    }
    
}

- (void)setNorImage:(UIImage *)image{
    for (UIImageView *imageView in self.normalStarArray) {
        imageView.image = image;
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
