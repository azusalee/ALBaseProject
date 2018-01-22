//
//  LZHMutiSortSelectView.h
//  youmi
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZHMutiSortSelectView;

@protocol LZHMutiSortSelectViewDelegate

- (NSString*)LZHMutiSortSelectView:(LZHMutiSortSelectView*)sorSelView titleAtRow:(NSInteger)row andCol:(NSInteger)col;

- (void)LZHMutiSortSelectView:(LZHMutiSortSelectView*)sorSelView didSelectAtRow:(NSInteger)row andCol:(NSInteger)col;
- (NSInteger)LZHMutiSortSelectView:(LZHMutiSortSelectView*)sorSelView countAtCol:(NSInteger)col;

@end

@interface LZHMutiSortSelectView : UIView


@property (nonatomic, strong) NSArray *tableViewArray;
@property (nonatomic, strong) id<LZHMutiSortSelectViewDelegate> delegate;


- (void)setupWithLevel:(NSInteger)level;//1以上
- (void)reloadData;


@end
