//
//  SRLrcView.m
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/28.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRLrcView.h"
#import "SRLrcCell.h"
#import "SRLrcLine.h"

@interface SRLrcView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

/** 所有歌词 */
@property (nonatomic, strong) NSMutableArray *lrcLines;

/** 当前歌词行 */
@property (nonatomic, assign) int currentIndex;

@end

@implementation SRLrcView

#pragma mark - 懒加载

- (NSMutableArray *)lrcLines
{
    if (_lrcLines == nil) {
        self.lrcLines = [NSMutableArray array];
    }
    return _lrcLines;
}

#pragma mark - 初始化

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 35;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.frame.size.height * 0.5, 0, self.tableView.frame.size.height * 0.5, 0);
}

- (void)setLrcname:(NSString *)lrcname
{
    _lrcname = [lrcname copy];
    
    [self.lrcLines removeAllObjects]; // 清空旧歌词数据
    
    // 加载新歌词
    NSURL *url = [[NSBundle mainBundle] URLForResource:lrcname withExtension:nil];
    NSString *lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcCmps = [lrcStr componentsSeparatedByString:@"\n"];
    
    // 保存每一行歌词
    for (NSString *lrcCmp in lrcCmps) {
        SRLrcLine *line = [[SRLrcLine alloc] init];
        if (![lrcCmp hasPrefix:@"["]) continue;
        if ([lrcCmp hasPrefix:@"[ti:"] || [lrcCmp hasPrefix:@"[ar:"] || [lrcCmp hasPrefix:@"[al:"] ) { // 歌词头部信息(歌名、歌手、专辑)
            NSString *word = [[lrcCmp componentsSeparatedByString:@":"] lastObject];
            line.word = [word substringToIndex:word.length - 1];
        } else { // 歌词非头部信息
            NSArray *array = [lrcCmp componentsSeparatedByString:@"]"];
            line.time = [[array firstObject] substringFromIndex:1];
            line.word = [array lastObject];
        }
        [self.lrcLines addObject:line];
    }
    
    [self.tableView reloadData]; // 刷新表格
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    // 拖动滑块倒退
    if (currentTime < _currentTime) {
        self.currentIndex = -1;
    }
    
    _currentTime = currentTime;
    int minute = currentTime / 60;
    int second = (int)currentTime % 60;
    int msecond = (currentTime - (int)currentTime) * 100;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d", minute, second, msecond];
    
    int count = (int)self.lrcLines.count ;
    for (int idx = self.currentIndex + 1; idx < count; idx++) {
        SRLrcLine *currentLine = self.lrcLines[idx];
  
        NSString *currentLineTime = currentLine.time; // 当前模型的时间
        
        // 下一个模型的时间
        NSString *nextLineTime = nil;
        NSUInteger nextIdx = idx + 1;
        if (nextIdx < self.lrcLines.count) {
            SRLrcLine *nextLine = self.lrcLines[nextIdx];
            nextLineTime = nextLine.time;
        }
        
        // 判断是否为正在显示的歌词
        if (([currentTimeStr compare:currentLineTime] != NSOrderedAscending)
            && ([currentTimeStr compare:nextLineTime] == NSOrderedAscending)
            && self.currentIndex != idx) {
            // 刷新tableView
            NSArray *reloadRows = @[[NSIndexPath indexPathForRow:self.currentIndex inSection:0],
                                    [NSIndexPath indexPathForRow:idx inSection:0]];
            self.currentIndex = idx;
            [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
            
            // 滚动到对应的行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRLrcCell *cell = [SRLrcCell cellWithTableView:tableView];
    cell.lrcLine = self.lrcLines[indexPath.row];
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
    } else {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

@end
