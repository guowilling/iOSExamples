
#import "BubbleTransition.h"

@interface BubbleTransition () <CAAnimationDelegate>

@property (nonatomic, assign) CGRect anchorRect;

@property (nonatomic, strong) NSObject<UIViewControllerContextTransitioning> *transitioningContext;

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation BubbleTransition

+ (instancetype)transitionWithAnchorRect:(CGRect)anchorRect {
    
    return [[BubbleTransition alloc] initWithAnchorRect:anchorRect];
}

- (instancetype)initWithAnchorRect:(CGRect)anchorRect {
    
    if (self = [super init]) {
        _anchorRect = anchorRect;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.transitionType == BubbleTransitionTypeShow) {
        return 0.5;
    }
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (_transitionType == BubbleTransitionTypeShow) {
        [self showBubbleMaskAnimationTo:transitionContext];
        [self showScaleAnimationTo:transitionContext];
    } else if (_transitionType == BubbleTransitionTypeHide){
        [self hideBubbleMaskAnimationTo:transitionContext];
        [self hideScaleAnimationTo:transitionContext];
    }
}

#pragma mark - 显示

// 圆形动画
- (void)showBubbleMaskAnimationTo:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    _transitioningContext = transitionContext;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    // CAShapeLayer 圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //toView.layer.mask = maskLayer;
    maskLayer.bounds = fromView.layer.bounds;
    maskLayer.position = fromView.layer.position;
    maskLayer.fillColor = toView.backgroundColor.CGColor;
    [fromView.layer addSublayer:maskLayer];
    _maskLayer = maskLayer;
    
    CGFloat radius = [self radiusOfBubbleInView:toView startPoint:CGPointMake(CGRectGetMidX(_anchorRect), CGRectGetMidY(_anchorRect))];
    // 开始的圆环
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:_anchorRect];
    // 结束的圆环
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(_anchorRect, -radius, -radius)];
    
    maskLayer.path = finalPath.CGPath; // maskLayer 的 path 指定为最终的 path 避免动画结束后反弹
    
    // 圆形动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((finalPath.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

// 位移和缩放动画
- (void)showScaleAnimationTo:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    // 位移动画
    toView.layer.position = CGPointMake(CGRectGetMidX(toView.bounds), CGRectGetMidY(toView.bounds));
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(_anchorRect), CGRectGetMidY(_anchorRect))];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toView.bounds), CGRectGetMidY(toView.bounds))];
    positionAnimation.duration = [self transitionDuration:transitionContext];
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [toView.layer addAnimation:positionAnimation forKey:@"position"];
    
    // 缩放动画
    toView.transform = CGAffineTransformMakeScale(1, 1);
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(0);
    scaleAnimation.toValue = @(1);
    scaleAnimation.duration = [self transitionDuration:transitionContext];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [toView.layer addAnimation:scaleAnimation forKey:@"scale"];
}

#pragma mark - 隐藏

- (void)hideBubbleMaskAnimationTo:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    _transitioningContext = transitionContext;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.bounds = toView.layer.bounds;
    maskLayer.position = toView.layer.position;
    maskLayer.fillColor = fromView.backgroundColor.CGColor;
    //fromView.layer.mask = maskLayer;
    [toView.layer addSublayer:maskLayer];
    _maskLayer = maskLayer;
    
    CGFloat radius = [self radiusOfBubbleInView:toView startPoint:CGPointMake(CGRectGetMidX(_anchorRect), CGRectGetMidY(_anchorRect))];
    //开始的圆环
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(_anchorRect, -radius, -radius)];
    //结束的圆环
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:_anchorRect];
    
    maskLayer.path = finalPath.CGPath;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((finalPath.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)hideScaleAnimationTo:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    fromView.layer.position = CGPointMake(CGRectGetMidX(_anchorRect), CGRectGetMidY(_anchorRect));
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromView.bounds), CGRectGetMidY(fromView.bounds))];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(_anchorRect), CGRectGetMidY(_anchorRect))];
    positionAnimation.duration = [self transitionDuration:transitionContext];
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation.delegate = self;
    [fromView.layer addAnimation:positionAnimation forKey:@"position"];
    
    fromView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(1);
    scaleAnimation.toValue = @(0);
    scaleAnimation.duration = [self transitionDuration:transitionContext];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [fromView.layer addAnimation:scaleAnimation forKey:@"scale"];
}

#pragma mark - Others

/**
 遍历 view 的四个角得到最长的半径
 */
- (CGFloat)radiusOfBubbleInView:(UIView*)view startPoint:(CGPoint)startPoint {
    
    // 四个角所在的点
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(view.bounds.size.width, 0);
    CGPoint point3 = CGPointMake(0 ,view.bounds.size.height);
    CGPoint point4 = CGPointMake(view.bounds.size.width,view.bounds.size.height);
    NSArray *pointArrar = @[[NSValue valueWithCGPoint:point1],
                            [NSValue valueWithCGPoint:point2],
                            [NSValue valueWithCGPoint:point3],
                            [NSValue valueWithCGPoint:point4]];
    
    // 最长的半径(冒泡排序)
    CGFloat radius = 0;
    for (NSValue *value in pointArrar) {
        CGPoint point = [value CGPointValue];
        CGFloat apartX = point.x - startPoint.x;
        CGFloat apartY = point.y - startPoint.y;
        CGFloat realRadius = sqrt(apartX*apartX + apartY*apartY);
        if (radius <= realRadius) {
            radius = realRadius;
        }
    }
    return radius;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [_transitioningContext completeTransition:![_transitioningContext transitionWasCancelled]]; // 通知上下文动画结束
    
    [_maskLayer removeFromSuperlayer]; // 移除遮罩 layer
    _maskLayer = nil;
}

@end
