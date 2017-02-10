//
//  SRSettingCell.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRSettingCell.h"
#import "SRSettingArrowItem.h"
#import "SRSettingSwitchItem.h"
#import "SRSettingLabelItem.h"

@interface SRSettingCell ()

@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, strong) UILabel *labelView;
@property (nonatomic, weak) UIView *divider;

@end

@implementation SRSettingCell

#pragma mark - 懒加载

- (UIImageView *)arrowImage {
    
    if (_arrowImage == nil) {
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _arrowImage;
}

- (UISwitch *)switchBtn {
    
    if (_switchBtn == nil) {
        _switchBtn = [[UISwitch alloc] init];
        [_switchBtn addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (void)valueChange {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.switchBtn.isOn forKey:self.settingItem.title];
    [defaults synchronize];
}

- (UILabel *)labelView {
    
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.frame = CGRectMake(0, 0, 88, 44);
        _labelView.backgroundColor = [UIColor redColor];
    }
    return _labelView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell";
    SRSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SRSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBackgroundColor];
        [self addDivider];
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setupBackgroundColor {
    
    UIView *norView = [[UIView alloc] init];
    norView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = norView;
    UIView *selView = [[UIView alloc] init];
    selView.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:228 / 255.0 blue:209/ 255.0 alpha:1.0];
    self.selectedBackgroundView = selView;
}

- (void)addDivider {
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:228 / 255.0 blue:209/ 255.0 alpha:1.0];
    [self.contentView addSubview:divider];
    divider.alpha = 0.4;
    self.divider = divider;
}

// 重写该方法拦截系统设置cell的frame, 自定义cell的frame.
- (void)setFrame:(CGRect)frame {
    
    frame.size.width -= 20;
    frame.origin.x += 10;
    
    [super setFrame:frame];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat dividerX = 0;
    CGFloat dividerW = [UIScreen mainScreen].bounds.size.width;
    CGFloat dividerH = 1;
    CGFloat dividerY = self.contentView.frame.size.height - dividerH;
    self.divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
}

- (void)setSettingItem:(SRSettingItem *)item {
    
    _settingItem = item;
    
    self.textLabel.text = _settingItem.title;
    self.imageView.image = [UIImage imageNamed:_settingItem.icon];
    
    if ([_settingItem isKindOfClass:[SRSettingArrowItem class]]) {
        self.accessoryView = self.arrowImage;
        self.detailTextLabel.text = self.settingItem.subTitle;
    } else if ([_settingItem isKindOfClass:[SRSettingSwitchItem class]]) {
        self.accessoryView = self.switchBtn;
        self.switchBtn.on = [[NSUserDefaults standardUserDefaults] boolForKey:self.settingItem.title];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([_settingItem isKindOfClass:[SRSettingLabelItem class]]) {
        self.accessoryView = self.labelView;
    } else {
        // 防止循环使用cell时, 辅助视图显示出错.
        self.accessoryView = nil;
    }
}

@end
