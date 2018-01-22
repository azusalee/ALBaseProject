//
//  LZHTagCollectionView.m
//  zingchat
//
//  Created by index on 16/4/12.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import "LZHTagCollectionView.h"
#import "LZHTagCollectionFlowLayout.h"

@implementation TagLayout

- (instancetype)init{
    if (self = [super init]) {
        _font = [UIFont systemFontOfSize:15];
        _itemHeight = 20.0f;
        _normalTextColor = [UIColor blackColor];
        _normalBackgroundColor = [UIColor clearColor];
        _edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);;
        _scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _itemSpacing = 8.0f;
        _lineSpacing = 8.0f;
        _insideSpace = 5.0f;
        _canDelete = NO;
        _maxStringLength = 0;
        _isCenterLayout = NO;
    }
    return self;
}

@end


@interface LZHTagCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LZHTagCollectionViewCellDelegate>{
    NSMutableArray *_dataArray;
    LZHTagCollectionFlowLayout *_collectionLayout;
    TagLayout *_tagLayout;
    NSInteger _firstRandomIndex;
    NSMutableDictionary *_sortDict;
}

@end

@implementation LZHTagCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _tagLayout = [[TagLayout alloc] init];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTagLayout:(TagLayout *)tagLayout{
    if (self = [super initWithFrame:frame]) {
        if (tagLayout) {
            _tagLayout = tagLayout;
        }else{
            _tagLayout = [[TagLayout alloc] init];
        }
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    _dataArray = [[NSMutableArray alloc] init];
    _sortDict = [[NSMutableDictionary alloc] init];
    LZHTagCollectionFlowLayout* layout = [[LZHTagCollectionFlowLayout alloc] init];
    //layout.itemSize = CGSizeMake(50, 60);
    layout.minimumLineSpacing = _tagLayout.lineSpacing;
    layout.minimumInteritemSpacing = _tagLayout.itemSpacing;
    layout.scrollDirection = _tagLayout.scrollDirection;
    layout.sectionInset = _tagLayout.edgeInsets;
    layout.isCenterLayout = _tagLayout.isCenterLayout;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[LZHTagCollectionViewCell class] forCellWithReuseIdentifier:@"LZHTagCollectionViewCell"];
    
}

- (void)addTagArray:(NSArray<TagItemObject *> *)array{
    [_dataArray addObjectsFromArray:array];
    [self.collectionView reloadData];
}

- (void)setTagArray:(NSArray<TagItemObject *> *)array{
    [_dataArray removeAllObjects];
    if (_tagLayout.isSort) {
        [self sortArray:array];
    }else{
        [self addTagArray:array];
    }
    if (_tagLayout.isRandomBigFont && _dataArray.count > 0) {
        _firstRandomIndex = arc4random()%_dataArray.count;
    }
}

- (void)sortArray:(NSArray*)array{
    [_sortDict removeAllObjects];
    for (TagItemObject *item in array) {
        NSMutableArray *mutArray = nil;
        NSString *typeString = [NSString stringWithFormat:@"%lld",item.type];
        if ([_sortDict hasObjectForKey:typeString]) {
            mutArray = _sortDict[typeString];
        }
        if (!mutArray) {
            mutArray = [[NSMutableArray alloc] init];
            _sortDict[typeString] = mutArray;
            [_dataArray addObject:mutArray];
        }
        [mutArray addObject:item];
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_tagLayout.isSort) {
        NSArray *array = _dataArray[section];
        return array.count;
    }else{
        return _dataArray.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_tagLayout.isSort) {
        return _dataArray.count;
    }else{
        return 1;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZHTagCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LZHTagCollectionViewCell" forIndexPath:indexPath];
    
    if (!cell.isSetLayout) {
        //设置cell的样式
        cell.nameLabel.height = _tagLayout.itemHeight;
        cell.nameLabel.textColor = _tagLayout.normalTextColor;
        cell.nameLabel.font = _tagLayout.font;
        cell.backgroundImageView.height = _tagLayout.itemHeight;
        cell.selectedBackgroundImageView.height = _tagLayout.itemHeight;
        
        cell.backgroundImageView.backgroundColor = _tagLayout.normalBackgroundColor;
        if (_tagLayout.selectBackgroundColor) {
            cell.selectedBackgroundImageView.backgroundColor = _tagLayout.selectBackgroundColor;
        }
        cell.delegate = self;
        
        cell.deleteButton.height = _tagLayout.itemHeight;
        if (_tagLayout.canDelete) {
            cell.deleteButton.hidden = NO;
        }else{
            cell.deleteButton.hidden = YES;
        }
        
        if (_tagLayout.corenerRadius) {
            cell.backgroundImageView.layer.cornerRadius = _tagLayout.corenerRadius;
            cell.backgroundImageView.layer.borderWidth = _tagLayout.borderWidth;
            cell.backgroundImageView.layer.borderColor = _tagLayout.borderColor.CGColor;
            cell.backgroundImageView.clipsToBounds = YES;
        }
        
        cell.isSetLayout = YES;
    }
    
    TagItemObject *tagItem = nil;
    
    if (_tagLayout.isSort) {
        tagItem = _dataArray[indexPath.section][indexPath.row];
    }else{
        tagItem = _dataArray[indexPath.row];
    }
    if (_tagLayout.maxStringLength > 0) {
        if (tagItem.tagName.length > _tagLayout.maxStringLength) {
            NSString *cutString = [NSString stringWithFormat:@"%@...",[tagItem.tagName substringToIndex:_tagLayout.maxStringLength-1]];
            cell.nameLabel.text = cutString;
        }else{
            cell.nameLabel.text = tagItem.tagName;
        }
    }else{
        cell.nameLabel.text = tagItem.tagName;
    }
    
    if (_tagLayout.isRandomBigFont) {
        if (indexPath.row == _firstRandomIndex) {
            cell.nameLabel.font = [UIFont systemFontOfSize:_tagLayout.font.pointSize+2];
        }else{
            cell.nameLabel.font = _tagLayout.font;
        }
    }
    cell.tagItem = tagItem;
    CGSize size = [ALFuncTooles sizeWithFont:cell.nameLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) string:cell.nameLabel.text];
    CGFloat width = size.width;
    width += _tagLayout.insideSpace*2;
    cell.nameLabel.width = width;
    if (_tagLayout.canDelete) {
        cell.deleteButton.left = width-_tagLayout.insideSpace+2;
        width += TagDeleteButtonWidth;
    }
    if (width < _tagLayout.minItemWidth) {
        width = _tagLayout.minItemWidth;
    }
    if (tagItem.isSelected == YES) {
        cell.selectedBackgroundImageView.hidden = NO;
        cell.nameLabel.textColor = _tagLayout.selectTextColor;
        if (tagItem.selectColor) {
            cell.selectedBackgroundImageView.backgroundColor = tagItem.selectColor;
        }else{
            cell.selectedBackgroundImageView.backgroundColor = _tagLayout.selectBackgroundColor;
        }
        cell.backgroundImageView.layer.borderWidth = 0;
    }else{
        cell.selectedBackgroundImageView.hidden = YES;
        cell.nameLabel.textColor = _tagLayout.normalTextColor;
        cell.backgroundImageView.layer.borderWidth = _tagLayout.borderWidth;
    }
    cell.backgroundImageView.width = width;
    cell.selectedBackgroundImageView.width = width;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_tagLayout.isSort) {
        TagItemObject *tagItem = _dataArray[indexPath.section][indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(lZHTagCollectionView:didSelectWithObject:)]) {
            [self.delegate lZHTagCollectionView:self didSelectWithObject:tagItem];
        }
    }else{
        TagItemObject *tagItem = _dataArray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(lZHTagCollectionView:didSelectWithObject:)]) {
            [self.delegate lZHTagCollectionView:self didSelectWithObject:tagItem];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    TagItemObject *tagItem = nil;
    
    if (_tagLayout.isSort) {
        tagItem = _dataArray[indexPath.section][indexPath.row];
    }else{
        tagItem = _dataArray[indexPath.row];
    }
    NSString *tagString = @"";
    
    if (_tagLayout.maxStringLength > 0) {
        if (tagItem.tagName.length > _tagLayout.maxStringLength) {
            tagString = [NSString stringWithFormat:@"%@...",[tagItem.tagName substringToIndex:_tagLayout.maxStringLength-1]];
        }else{
            tagString = tagItem.tagName;
        }
    }else{
        tagString = tagItem.tagName;
    }
    
    CGSize size = [ALFuncTooles sizeWithFont:_tagLayout.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) string:tagString];
    CGFloat width = size.width;
    width += _tagLayout.insideSpace*2;
    
    if (_tagLayout.canDelete) {
        width += TagDeleteButtonWidth;
    }
    if (width < _tagLayout.minItemWidth) {
        width = _tagLayout.minItemWidth;
    }
    
    return CGSizeMake(width, _tagLayout.itemHeight);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return _tagLayout.itemSpacing;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return _tagLayout.lineSpacing;
//}

- (void)lZHTagCollectionViewCell:(LZHTagCollectionViewCell *)cell deleteWithObject:(TagItemObject *)itemObject{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lZHTagCollectionView:didDelectWithObject:)]) {
        [self.delegate lZHTagCollectionView:self didDelectWithObject:itemObject];
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
