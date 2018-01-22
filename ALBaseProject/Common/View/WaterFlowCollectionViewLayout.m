//
//  WaterFlowCollectionViewLayout.m
//  kuxing
//
//  Created by mac on 17/5/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "WaterFlowCollectionViewLayout.h"

@interface WaterFlowCollectionViewLayout()

/** 这个字典用来存储每一列最大的Y值(每一列的高度) */
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
/** 存放所有的布局属性 */
@property(nonatomic,strong)NSMutableArray *attributeArray;
@end

@implementation WaterFlowCollectionViewLayout


- (NSMutableDictionary *)maxYDict
{
    if (!_maxYDict) {
        
        self.maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}

- (NSMutableArray *)attributeArray
{
    if (!_attributeArray) {
        self.attributeArray = [[NSMutableArray alloc] init];
    }
    return _attributeArray;
}

#pragma mark -初始化默认值
- (instancetype)init
{
    if (self = [super init]) {
        self.columnMargin = 15;
        self.rowMargin = 10;
        self.columnsCount = 3;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

// 布局每一个indexPath的位置
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount - 1) * self.columnMargin) / self.columnsCount;
    // 代理计算传入高的值
    CGFloat height = [self.delegate flowLayout:self heightForWidth:width atIndexPath:indexPath];
    
    // 2.0假设最短的那一列的第0列
    __block NSString *minColumn = @"0";
    // 遍历字典找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    // 2.1计算位置
    CGFloat x = self.sectionInset.left + (self.columnMargin + width) * [minColumn intValue];
    CGFloat y = [self.maxYDict[minColumn] floatValue]+ _rowMargin;
    
    self.maxYDict[minColumn] = @(y + height);
    // 3.创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
}

- (void)prepareLayout
{
    [super prepareLayout];
    // 1.清空最大的Y值
    for (int i = 0; i<self.columnsCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        self.maxYDict[column] = @(self.sectionInset.top);
    }
    [self.attributeArray removeAllObjects];
    
    // 总 item 数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i <count; i++) {
        UICollectionViewLayoutAttributes *attris = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.attributeArray addObject:attris];
    }
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.attributeArray;
}

// 计算ContentSize
- (CGSize)collectionViewContentSize
{
    // 默认最大Y值在第0列
    __block NSString *maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom);
    
}

@end
