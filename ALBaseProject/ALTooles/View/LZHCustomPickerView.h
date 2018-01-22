//
//  LZHCustomPickerView.h
//  kuxing
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LZHCustomPickerItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) id value;

@end

@interface LZHCustomPickerView : UIView

typedef void (^LZHCustomPickerViewBlock)(NSArray *resultArray);


@property (nonatomic, strong) LZHCustomPickerViewBlock block;
@property (nonatomic, readonly) UIPickerView *pickerView;


//level需要大于0
+ (instancetype)createWithArray:(NSArray*)array isLevel:(int)level;

- (void)setBlock:(LZHCustomPickerViewBlock)block;
- (void)showPicker;
- (void)hidePicker;

@end
