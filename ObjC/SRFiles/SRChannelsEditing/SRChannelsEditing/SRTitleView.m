
#import "SRTitleView.h"

@interface SRTitleView()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) BOOL needEditBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation SRTitleView

+ (instancetype)titleView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle needEditBtn:(BOOL)needEditBtn {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:0].firstObject;
    self.titleLabel.text = title;
    self.subtitleLabel.text = subTitle;
    self.editBtn.hidden = !needEditBtn;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.editBtn.layer.cornerRadius = self.editBtn.frame.size.height * 0.5;
    self.editBtn.layer.borderColor = [UIColor colorWithRed:0.93 green:0.37 blue:0.47 alpha:1.0].CGColor;
    self.editBtn.layer.borderWidth = 1;
}

- (IBAction)editBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        self.subtitleLabel.text = @"拖拽可以排序";
    } else {
        self.subtitleLabel.text = @"点击进入频道";
    }
    if (self.editBtnSelectedDidChangeBlock) {
        self.editBtnSelectedDidChangeBlock(sender.isSelected);
    }
}

@end
