//
//  LZHTabCollectionViewController.m
//  MyFrameTest
//
//  Created by Mac on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "LZHTabCollectionViewController.h"

@interface LzhTabCollectionCell : UICollectionViewCell


@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation LzhTabCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.nameLabel];
    
    
    
}

@end


@interface LzhVcCollectionCell : UICollectionViewCell


@property (nonatomic, strong) UIViewController *curController;


@end

@implementation LzhVcCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    
    
    
    
}

@end

@interface LZHTabCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation LZHTabCollectionViewController

- (void)dealloc{
    _tabCollectionView.delegate = nil;
    _tabCollectionView.dataSource = nil;
    
    _vcCollectionView.delegate = nil;
    _vcCollectionView.dataSource = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabItemHeight-2, self.tabItemWidth, 2)];
    
    {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.tabItemWidth, self.tabItemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _tabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tabItemHeight) collectionViewLayout:layout];
        _tabCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tabCollectionView.backgroundColor = [UIColor whiteColor];
        _tabCollectionView.delegate = self;
        _tabCollectionView.dataSource = self;
        _tabCollectionView.scrollsToTop = NO;
        _tabCollectionView.showsVerticalScrollIndicator = NO;
        _tabCollectionView.showsHorizontalScrollIndicator = NO;
        _tabCollectionView.bounces = NO;
        _tabCollectionView.userInteractionEnabled = YES;
        
        [_tabCollectionView registerClass:[LzhTabCollectionCell class] forCellWithReuseIdentifier:@"LzhTabCollectionCell"];
        [_tabCollectionView addSubview:self.indicatorView];
    }
    
    
    
    for (int i = 0; i < self.vcArray.count; ++i) {
        UIViewController *controller = self.vcArray[i];
        [self addChildViewController:controller];
    }
    
    {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.tabItemWidth, self.tabItemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _vcCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _vcCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _vcCollectionView.backgroundColor = [UIColor whiteColor];
        _vcCollectionView.delegate = self;
        _vcCollectionView.dataSource = self;
        _vcCollectionView.scrollsToTop = NO;
        _vcCollectionView.showsVerticalScrollIndicator = NO;
        _vcCollectionView.showsHorizontalScrollIndicator = NO;
        _vcCollectionView.bounces = NO;
        _vcCollectionView.userInteractionEnabled = YES;
        
        [_vcCollectionView registerClass:[LzhVcCollectionCell class] forCellWithReuseIdentifier:@"LzhVcCollectionCell"];
        
        [self.view addSubview:_vcCollectionView];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.vcCollectionView) {
        NSInteger index = (NSInteger)((scrollView.contentOffset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width);
        self.curSelectIndex = index;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.vcCollectionView) {
        CGRect indicatorFrame = self.indicatorView.frame;
        indicatorFrame.origin.x = self.curSelectIndex*self.tabItemWidth;
        self.indicatorView.frame = indicatorFrame;
        [self.tabCollectionView reloadData];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.tabCollectionView) {
        return self.tabArray.count;
    }else{
        return self.vcArray.count;
    }
    
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.tabCollectionView) {
        LzhTabCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LzhTabCollectionCell" forIndexPath:indexPath];
        NSString *title = self.tabArray[indexPath.row];
        cell.nameLabel.text = title;
        if (indexPath.row == self.curSelectIndex) {
            if (self.selectColor) {
                cell.nameLabel.textColor = self.selectColor;
            }
            
        }else{
            if (self.normalColor) {
                cell.nameLabel.textColor = self.normalColor;
            }
            
        }
        
        
        
        return cell;
    }else{
        LzhVcCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LzhVcCollectionCell" forIndexPath:indexPath];
        UIViewController *controller = self.vcArray[indexPath.row];
        
        [cell.curController.view removeFromSuperview];
        
        cell.curController = controller;
        [cell.contentView addSubview:controller.view];
        
        
        
        return cell;
    }
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (collectionView == self.tabCollectionView){
        NSInteger index = indexPath.row;
        
        [self.vcCollectionView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0) animated:NO];
        self.curSelectIndex = index;
        [self.tabCollectionView reloadData];
        CGRect indicatorFrame = self.indicatorView.frame;
        indicatorFrame.origin.x = self.curSelectIndex*self.tabItemWidth;
        self.indicatorView.frame = indicatorFrame;
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.tabCollectionView){
        return CGSizeMake(self.tabItemWidth, self.tabItemHeight);
    }else{
        return self.vcCollectionView.frame.size;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
