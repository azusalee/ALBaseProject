//
//  ALLocalAreaPickerView.m
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ALLocalAreaPickerView.h"

@interface ALLocalAreaPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger _area1Index;
    NSInteger _area2Index;
    NSInteger _area3Index;
}

@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) NSArray *area1Array;
@property (nonatomic, strong) NSArray *area2Array;
@property (nonatomic, strong) NSArray *area3Array;

@property (nonatomic, strong) NSArray *allCityArray;
@property (nonatomic, strong) NSArray *allDistrictArray;


@end

@implementation ALLocalAreaPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (long long)getProvinceIdWithName:(NSString *)name{
    
    for (int i = 0; i < self.area1Array.count; ++i) {
        NSDictionary *dict = [self.area1Array objectAtIndex:i];
        NSString *region_name = [dict objectForKey:@"region_name"];
        if ([name isEqualToString:region_name]) {
            long long region_id = [[dict objectForKey:@"id"] longLongValue];
            return region_id;
        }
        
    }
    
    
    return 0;
    
}

- (long long)getCityIdWithName:(NSString *)name{
    for (int i = 0; i < self.allCityArray.count; ++i) {
        NSDictionary *dict = [self.allCityArray objectAtIndex:i];
        NSString *region_name = [dict objectForKey:@"region_name"];
        if ([name isEqualToString:region_name]) {
            long long region_id = [[dict objectForKey:@"id"] longLongValue];
            return region_id;
        }
        
    }
    
    
    return 0;
}

- (NSArray*)readFile:(NSString*)fileName
{
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    
    NSStringEncoding *useEncodeing = nil;
    //带编码头的如utf-8等，这里会识别出来
    NSString *body = [NSString stringWithContentsOfFile:txtPath usedEncoding:useEncodeing error:nil];
    
    //识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
    if (!body) {
        body = [NSString stringWithContentsOfFile:txtPath encoding:0x80000632 error:nil];
        //NSLog(@"%@",body);
    }
    //还是识别不到，按GB18030编码再解码一次.
    if (!body) {
        body = [NSString stringWithContentsOfFile:txtPath encoding:0x80000631 error:nil];
        //NSLog(@"%@",body);
    }
    
    NSArray *array = [self jsonStringToKeyValues:body];
    
    return array;
}

//json字符串转化成OC键值对
- (id)jsonStringToKeyValues:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = nil;
    if (JSONData) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return responseJSON;
}



- (void)setup{
    self.level = 3;
    NSArray *provinceArray = [self readFile:@"省份"];
    self.allCityArray = [self readFile:@"城市"];
    self.allDistrictArray = [self readFile:@"县区"];
    
    
    self.area1Array = provinceArray;
    
    [self changeProvince:provinceArray[0]];
    
    
    self.frame = ScreenBounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    UIButton *maskButton = [[UIButton alloc] initWithFrame:ScreenBounds];
    [maskButton addTarget:self action:@selector(cancelDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskButton];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 162)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_pickerView selectRow:_area1Index inComponent:0 animated:NO];
    [_pickerView selectRow:_area2Index inComponent:1 animated:NO];
    self.pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _pickerView.height+52)];
    self.pickerContainerView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, _pickerView.height+8, ScreenWidth, 44)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(comfirmDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.pickerContainerView.top = ScreenHeight;
    [self addSubview:self.pickerContainerView];
    [self.pickerContainerView addSubview:button];
    [self.pickerContainerView addSubview:_pickerView];
    
    //
    
    
}

- (void)changeProvince:(NSDictionary*)porvinceDict{
    long long provinceId = [[porvinceDict objectForKey:@"id"] longLongValue];
    
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    for (NSDictionary *cityDict in self.allCityArray) {
        long long parent_id = [[cityDict objectForKey:@"parent_id"] longLongValue];
        if (parent_id == provinceId) {
            [cityArray addObject:cityDict];
        }
    }
    self.area2Array = cityArray;
    
    [self.pickerView reloadComponent:1];
    
    [self changeCity:self.area2Array[0]];
}

- (void)changeCity:(NSDictionary*)cityDict{
    long long cityId = [[cityDict objectForKey:@"id"] longLongValue];
    
    NSMutableArray *disArray = [[NSMutableArray alloc] init];
    for (NSDictionary *disDict in self.allDistrictArray) {
        long long parent_id = [[disDict objectForKey:@"parent_id"] longLongValue];
        if (parent_id == cityId) {
            [disArray addObject:disDict];
        }
    }
    self.area3Array = disArray;
    [self.pickerView reloadComponent:2];
}


- (void)showPicker{
    
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    
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
    if (component == 0) {
        
        return self.area1Array.count;
    }
    if (component == 1) {
        
        return self.area2Array.count;
    }else if (component == 2){
        return self.area3Array.count;
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        
        NSDictionary *province = [self.area1Array objectAtIndex:row];
        NSString *provice_name = [province objectForKey:@"region_name"];
        
        
        label.text = provice_name;
        
    }else if (component == 1) {
        
        NSDictionary *city = [self.area2Array objectAtIndex:row];
        NSString *city_name = [city objectForKey:@"region_name"];
        
        label.text = city_name;
        
    }else if (component == 2) {
        
        NSDictionary *district = [self.area3Array objectAtIndex:row];
        NSString *district_name = [district objectForKey:@"region_name"];
        
        label.text = district_name;
        
    }
    
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        NSDictionary *province = self.area1Array[row];
        [self changeProvince:province];
        
        
        
    }else if (component == 1){
        NSDictionary *city = self.area2Array[row];
        [self changeCity:city];
        
    }else if (component == 2){
        
    }
}




- (void)comfirmDidTap:(UIButton*)button{
    if (self.block) {
        NSDictionary *area1 = nil;
        NSDictionary *area2 = nil;
        NSDictionary *area3 = nil;
        NSInteger row1 = [_pickerView selectedRowInComponent:0];
        NSInteger row2 = [_pickerView selectedRowInComponent:1];
        NSInteger row3 = [_pickerView selectedRowInComponent:2];
        
        area1 = self.area1Array[row1];
        area2 = self.area2Array[row2];
        area3 = self.area3Array[row3];
        
        NSString *provice_name = [area1 objectForKey:@"region_name"];
        NSString *city_name = [area2 objectForKey:@"region_name"];
        NSString *district_name = [area3 objectForKey:@"region_name"];
        
        self.block(provice_name,city_name,district_name,[[area1 objectForKey:@"id"] longLongValue],[[area2 objectForKey:@"id"] longLongValue],[[area3 objectForKey:@"id"] longLongValue]);
    }
    [self hidePicker];
}


- (void)cancelDidTap:(UIButton*)button{
    [self hidePicker];
}




@end
