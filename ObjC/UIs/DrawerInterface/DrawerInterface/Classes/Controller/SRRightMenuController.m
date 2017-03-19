
#import "SRRightMenuController.h"

@interface SRRightMenuController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation SRRightMenuController

- (void)didShow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.iconImageView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            self.iconImageView.image = [UIImage imageNamed:@"user_defaultgift"];
                        }
                        completion:^(BOOL finished) {
                            [UIView transitionWithView:self.iconImageView
                                              duration:1.0
                                               options:UIViewAnimationOptionTransitionFlipFromRight
                                            animations:^{
                                                self.iconImageView.image = [UIImage imageNamed:@"default_avatar"];
                                            }
                                            completion:nil];
                        }];
    });
}

@end
