//
//  LZHTagCollectionFlowLayout.m
//  zingchat
//
//  Created by index on 16/4/16.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import "LZHTagCollectionFlowLayout.h"

@implementation LZHTagCollectionFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    if (attributes.count > 0) {
        UICollectionViewLayoutAttributes *firstLayoutAttributes = attributes[0];
        if (firstLayoutAttributes.frame.origin.x != self.sectionInset.left) {
            CGRect frame = firstLayoutAttributes.frame;
            frame.origin.x = self.sectionInset.left;
            firstLayoutAttributes.frame = frame;
        }
    }
    
    NSInteger currentRowFirstIndex = 0;
    
    CGFloat currentRowTotalWidth = 0;
    
    if (attributes.count > 0) {
        UICollectionViewLayoutAttributes *firstLayoutAttributes = attributes[0];
        currentRowTotalWidth += firstLayoutAttributes.frame.size.width;
        if (attributes.count == 1) {
            if (self.isCenterLayout) {
                CGFloat leftEdge = (self.collectionViewContentSize.width-currentRowTotalWidth)/2;
                CGRect frame = firstLayoutAttributes.frame;
                frame.origin.x = leftEdge;
                firstLayoutAttributes.frame = frame;
            }
        }
    }
    
    
    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        if (self.isCenterLayout) {
            //居中的代码
            if (currentLayoutAttributes.frame.origin.y != prevLayoutAttributes.frame.origin.y) {
                CGFloat leftEdge = (self.collectionViewContentSize.width-currentRowTotalWidth)/2;
                for (NSInteger j = currentRowFirstIndex; j < i; ++j) {
                    UICollectionViewLayoutAttributes *layoutAttributes = attributes[j];
                    CGRect frame = layoutAttributes.frame;
                    frame.origin.x = leftEdge;
                    layoutAttributes.frame = frame;
                    leftEdge += frame.size.width+self.minimumInteritemSpacing;
                }
                currentRowFirstIndex = i;
                currentRowTotalWidth = currentLayoutAttributes.frame.size.width;
            }else{
                currentRowTotalWidth += currentLayoutAttributes.frame.size.width+self.minimumInteritemSpacing;
            }
            
            if (i == attributes.count - 1) {
                CGFloat leftEdge = (self.collectionViewContentSize.width-currentRowTotalWidth)/2;
                for (NSInteger j = currentRowFirstIndex; j <= i; ++j) {
                    UICollectionViewLayoutAttributes *layoutAttributes = attributes[j];
                    CGRect frame = layoutAttributes.frame;
                    frame.origin.x = leftEdge;
                    layoutAttributes.frame = frame;
                    leftEdge += frame.size.width+self.minimumInteritemSpacing;
                }
                //currentRowFirstIndex = i;
                //currentRowTotalWidth = currentLayoutAttributes.frame.size.width;
            }
        }else{
            //我们想设置的最大间距，可根据需要改
            NSInteger maximumSpacing = self.minimumInteritemSpacing;
            //前一个cell的最右边
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
            //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
            if((self.scrollDirection == UICollectionViewScrollDirectionHorizontal || origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) && (prevLayoutAttributes.frame.origin.y == currentLayoutAttributes.frame.origin.y) ) {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
    
    return attributes;
}

@end
