
#import "HeaderView.h"

@implementation HeaderView

+ (instancetype)headerView:(CGRect)frame {
    
    HeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil].firstObject;
    headerView.frame = frame;
    return headerView;
}

@end
