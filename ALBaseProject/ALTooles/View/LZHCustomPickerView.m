//
//  LZHCustomPickerView.m
//  kuxing
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHCustomPickerView.h"

@implementation LZHCustomPickerItem



@end

@interface LZHCustomPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    
}

@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) int level;


@end

@implementation LZHCustomPickerView

+ (instancetype)createWithArray:(NSArray*)array isLevel:(int)level{
    LZHCustomPickerView *pickerView = [[LZHCustomPickerView alloc] initWithFrame:ScreenBounds];
    pickerView.level = level;
    pickerView.data = array;
    
    return pickerView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    
    self.frame = ScreenBounds;
    self.backgroundColor = RGBA(0, 0, 0, 0.8);
    UIButton *maskButton = [[UIButton alloc] initWithFrame:ScreenBounds];
    [maskButton addTarget:self action:@selector(cancelDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskButton];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 162)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    //[_pickerView selectRow:_area1Index inComponent:0 animated:NO];
    //[_pickerView selectRow:_area2Index inComponent:1 animated:NO];
    self.pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _pickerView.height+52)];
    self.pickerContainerView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, _pickerView.height+8, ScreenWidth, 44)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(comfirmDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.pickerContainerView.top = ScreenHeight;
    [self addSubview:self.pickerContainerView];
    [self.pickerContainerView addSubview:button];
    [self.pickerContainerView addSubview:_pickerView];
    
    
    
    
}


- (void)showPicker{
    [AppDelegateInstance.window addSubview:self];
    [UIView animateWithDuration:0.275 animations:^{
        _pickerContainerView.bottom = self.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePicker{
    [UIView animateWithDuration:0.275 animations:^{
        _pickerContainerView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.level;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component < self.level) {
        NSArray *array = self.data;
        LZHCustomPickerItem *item = nil;
        
        for (int i = 0; i < component; ++i) {
            item = array[[pickerView selectedRowInComponent:i]];
            array = item.array;
            
        }
        return array.count;
    }
    
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0) {
//        NSDictionary *dic = [self.province objectAtIndex:row];
//        NSString *key = [[dic allKeys] firstObject];
//        return key;
//    }
//    if (component == 1) {
//        NSDictionary *dic = [self.city objectAtIndex:row];
//        NSString *key = [[dic allKeys] firstObject];
//        return key;
//    }
//    if (component == 2) {
//        return [self.district objectAtIndex:row];
//    }
//    return nil;
//}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = (UILabel*)view;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/self.level, 21)];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    
    if (component < self.level) {
        NSArray *array = self.data;
        LZHCustomPickerItem *item = nil;
        
        for (int i = 0; i < component; ++i) {
            item = array[[pickerView selectedRowInComponent:i]];
            array = item.array;
            
        }
        if (row < array.count) {
            item = array[row];
            label.text = item.name;
        }else{
            label.text = @"";
        }
        
        
        
    }
    
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component+1 < self.level) {
        [pickerView reloadComponent:component+1];
        
    }
}




- (void)comfirmDidTap:(UIButton*)button{
    if (self.block) {
        NSArray *array = self.data;
        LZHCustomPickerItem *item = nil;
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.level; ++i) {
            if (array.count == 0) {
                NSLog(@"数据出错");
                if (i == 0) {
                    return;
                }
                [resultArray addObject:[NSNull null]];
                
                break;
            }
            item = array[[self.pickerView selectedRowInComponent:i]];
            
            [resultArray addObject:item];
            array = item.array;
            
        }
        self.block(resultArray);
    }
    [self hidePicker];
}


- (void)cancelDidTap:(UIButton*)button{
    [self hidePicker];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
