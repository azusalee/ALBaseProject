//
//  ALLocalAreaPickerView.h
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ALLocalAreaPickerViewBlock)(NSString *province, NSString *city, NSString *district, long long province_id, long long city_id, long long district_id);

@interface ALLocalAreaPickerView : UIView


@property (nonatomic, strong) ALLocalAreaPickerViewBlock block;
@property (nonatomic, readonly) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger level;

- (void)setBlock:(ALLocalAreaPickerViewBlock)block;
- (void)showPicker;
- (void)hidePicker;


- (long long)getProvinceIdWithName:(NSString*)name;
- (long long)getCityIdWithName:(NSString*)name;

@end
