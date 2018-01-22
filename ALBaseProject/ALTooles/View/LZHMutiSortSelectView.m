//
//  LZHMutiSortSelectView.m
//  youmi
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "LZHMutiSortSelectView.h"
#import "LZHMutiSortSelectTableViewCell.h"

@interface LZHMutiSortSelectView()<UITableViewDelegate,UITableViewDataSource>
{
    
}


@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSMutableArray *currentSelectArray;


@end


@implementation LZHMutiSortSelectView




- (void)setupWithLevel:(NSInteger)level{
    if (level < 1) {
        return;
    }
    self.level = level;
    self.currentSelectArray = [[NSMutableArray alloc] initWithArray:@[@(0),@(0),@(0)]];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    CGFloat tableViewWidth = self.width/level;
    for (int i = 0; i < level; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*tableViewWidth, 0, tableViewWidth, self.height) style:UITableViewStylePlain];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self addSubview:tableView];
        [tempArray addObject:tableView];
        
    }
    self.tableViewArray = [NSArray arrayWithArray:tempArray];
    
}

- (void)reloadData{
    for (UITableView *tableView in self.tableViewArray) {
        [tableView reloadData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    for (int i = 0; i < self.tableViewArray.count; ++i) {
        UITableView *subTableView = self.tableViewArray[i];
        if (subTableView == tableView) {
            if (self.delegate) {
                return [self.delegate LZHMutiSortSelectView:self countAtCol:i];
            }else{
                return 0;
            }
        }
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZHMutiSortSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZHMutiSortSelectTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LZHMutiSortSelectTableViewCell" owner:self options:nil][0];
    }
    
    NSNumber *curSelCol = @(0);
    for (int i = 0; i < self.tableViewArray.count; ++i) {
        UITableView *subTableView = self.tableViewArray[i];
        if (subTableView == tableView) {
            curSelCol = self.currentSelectArray[i];
            if (self.delegate) {
                NSString *title = [self.delegate LZHMutiSortSelectView:self titleAtRow:indexPath.row andCol:i];
                cell.nameLabel.text = title;
            }
        }
    }
    
    if (curSelCol.integerValue == indexPath.row) {
        cell.nameLabel.textColor = ThemeColor;
    }else{
        cell.nameLabel.textColor = DarkColor1;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    for (int i = 0; i < self.tableViewArray.count; ++i) {
        UITableView *subTableView = self.tableViewArray[i];
        if (subTableView == tableView) {
            if (self.delegate) {
                [self.delegate LZHMutiSortSelectView:self didSelectAtRow:indexPath.row andCol:i];
            }
            [self.currentSelectArray replaceObjectAtIndex:i withObject:@(indexPath.row)];
        }
    }
    [self reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
