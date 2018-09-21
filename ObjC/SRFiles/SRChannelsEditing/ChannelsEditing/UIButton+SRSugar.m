
#import "UIButton+SRSugar.h"

@implementation UIButton (SRSugar)

+ (UIButton * (^)(UIButtonType))button {
    return ^UIButton *(UIButtonType type) {
        return [UIButton buttonWithType:type];
    };
}

- (UIButton * (^)(UIColor * ))backgroundColor {
    return ^UIButton *(UIColor *backgroundColor) {
        [self setBackgroundColor:backgroundColor];
        return self;
    };
}

- (UIButton * (^)(NSString *, UIControlState))title {
    return ^UIButton *(NSString *title, UIControlState status) {
        [self setTitle:title forState:status];
        return self;
    };
}

- (UIButton * (^)(UIColor *))titleColor {
    return ^UIButton *(UIColor *titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton * (^)(UIImage *, UIControlState))image {
    return ^UIButton * (UIImage *image, UIControlState status) {
        [self setImage:image forState:status];
        return self;
    };
}

- (UIButton * (^)(UIImage *, UIControlState))backgroundImage {
    return ^UIButton *(UIImage *backgroundImage, UIControlState state){
        [self setBackgroundImage:backgroundImage forState:state];
        return self;
    };
}

- (UIButton * (^)(UIColor *, CGFloat))border {
    return ^UIButton *(UIColor *borderColor,CGFloat borderWidth) {
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = borderWidth;
        return self;
    };
}

@end
