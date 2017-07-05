//
//  HomeAnimationTool.m
//  AirbnbHomeAnimationDemo
//
//  Created by 郭伟林 on 2017/7/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "HomeAnimationTool.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

typedef NS_OPTIONS(NSInteger, TailorType) {
    TailorTypeNone = 1 << 0,
    TailorTypeTop = 1 << 1,
    TailorTypeMiddle = 1 << 3,
    TailorTypeBottom = 1 << 2,
};

@interface HomeAnimationTool ()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *animationImageViewPool;

@end

@implementation HomeAnimationTool

- (IDParameterBlock)begainAnimationWithCollectionView:(UICollectionView *)collectionView
                             didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                                   fromViewController:(UIViewController *)fromViewController
                                     toViewController:(UIViewController *)toViewController
                                          finishBlock:(NoParameterBlock)finishBlock
{
    UICollectionViewCell *tapedCollectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *tapedImageView = [self getImageViewOfCollectionCell:tapedCollectionCell];
    CGRect tapedImageViewFrame = [tapedImageView.superview convertRect:tapedImageView.frame toView:nil];
    
    CGFloat topTailorY = tapedImageViewFrame.origin.y;
    CGFloat bottomTailorY = topTailorY + tapedImageViewFrame.size.height;
    
    CGRect topAnimationFrameStart = CGRectMake(0, 0, kScreenW, topTailorY);
    CGRect bottomAnimationFrameStart = CGRectMake(0, bottomTailorY, kScreenW, kScreenH - bottomTailorY);
    
    CGRect topAnimationFrameEnd = CGRectMake(0, -topTailorY, kScreenW, topTailorY);
    CGRect bottomAnimationFrameEnd = CGRectMake(0, kScreenH, kScreenW, kScreenH - bottomTailorY);
    
    UIImage *snapImage = [self snapShotWithView:fromViewController.view.window];
    UIImage *topAnimationImage = [self tailorImage:snapImage tailorPoint:topTailorY tailorType:TailorTypeTop];
    UIImage *bottomAnimationImage = [self tailorImage:snapImage tailorPoint:bottomTailorY tailorType:TailorTypeBottom];
    
    UIImageView *topAnimationImageView = [self dequeueImageView];
    topAnimationImageView.frame = topAnimationFrameStart;
    topAnimationImageView.image = topAnimationImage;
    [fromViewController.view.window addSubview:topAnimationImageView];
    
    UIImageView *bottomAnimationImageView = [self dequeueImageView];
    bottomAnimationImageView.frame = bottomAnimationFrameStart;
    bottomAnimationImageView.image = bottomAnimationImage;
    [fromViewController.view.window addSubview:bottomAnimationImageView];
    
    NSDictionary *animationData = [self addAnimationImageViewsOfCollectionView:collectionView];
    __block NSMutableArray *animationImageViews = animationData[@"animationImageViews"];
    for (UIImageView *imageView in animationImageViews) {
        [fromViewController.view.window addSubview:imageView];
    }
    NSMutableArray *animationStartFrames = animationData[@"animationStartFrames"];
    
    NSMutableArray *animationEndFrames = [self calculateAniamtionEndFramesWithAnimationStartFrames:animationStartFrames
                                                                               tapedImageViewFrame:tapedImageViewFrame];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromViewController.navigationController.navigationBar.hidden = YES;
        fromViewController.view.hidden = YES;
        
        topAnimationImageView.frame = topAnimationFrameEnd;
        bottomAnimationImageView.frame = bottomAnimationFrameEnd;
        
        for (int i = 0; i < animationImageViews.count; i++) {
            UIImageView *imageView = animationImageViews[i];
            NSValue *value = animationEndFrames[i];
            CGRect rect = [value CGRectValue];
            imageView.frame = rect;
        }
    } completion:^(BOOL finished) {
        [fromViewController.navigationController pushViewController:toViewController animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (finishBlock) {
                finishBlock();
            }
        });
        
        [self enqueueImageView:topAnimationImageView];
        [self enqueueImageView:bottomAnimationImageView];
        
        for (UIImageView *imageView in animationImageViews) {
            [self enqueueImageView:imageView];
        }
        animationImageViews = nil;
        
        fromViewController.view.hidden = NO;
    }];
    
    return [self dismissAnimationWithTopAnimationImage:topAnimationImage
                                topAnimationStartFrame:topAnimationFrameStart
                                  topAnimationEndFrame:topAnimationFrameEnd
                                  bottomAnimationImage:bottomAnimationImage
                             bottomAnimationStartFrame:bottomAnimationFrameStart
                               bottomAnimationEndFrame:bottomAnimationFrameEnd
                                         visiableCells:collectionView.visibleCells
                                  animationStartFrames:animationStartFrames
                                    animationEndFrames:animationEndFrames
                                    fromViewController:toViewController
                                      toViewController:fromViewController];
}


- (NSDictionary *)addAnimationImageViewsOfCollectionView:(UICollectionView *)collectionView {
    
    NSArray *cells = collectionView.visibleCells;
    NSMutableArray *animationImageViews = [NSMutableArray arrayWithCapacity:cells.count];
    NSMutableArray *animationStartFrames = [NSMutableArray arrayWithCapacity:cells.count];
    for (UICollectionViewCell *cell in cells) {
        UIImageView *imageView = [self getImageViewOfCollectionCell:cell];
        CGRect rect = [imageView.superview convertRect:imageView.frame toView:nil];
        NSValue *value = [NSValue valueWithCGRect:rect];
        [animationStartFrames addObject:value];
        
        UIImageView *animationImageView = [self dequeueImageView];
        animationImageView.image = imageView.image;
        animationImageView.frame = rect;
        [animationImageViews addObject:animationImageView];
    }
    return @{@"animationImageViews": animationImageViews,
             @"animationStartFrames": animationStartFrames};
}

- (NSMutableArray *)calculateAniamtionEndFramesWithAnimationStartFrames:(NSArray *)animationStartFrames tapedImageViewFrame:(CGRect)tapImageViewFrame {
    
    CGRect tapedAnimationImageViewFrame_end = CGRectMake(0, 0, kScreenW, kScreenW * 2.0/3.0);
    
    NSMutableArray *animationEndFrames = [NSMutableArray arrayWithCapacity:animationStartFrames.count];
    
    for (int i = 0; i < animationStartFrames.count; i++) {
        NSValue *value = animationStartFrames[i];
        CGRect rect = [value CGRectValue];
        CGRect targetRect = tapedAnimationImageViewFrame_end;
        if (rect.origin.x < tapImageViewFrame.origin.x) { // 在点击 cell 的左侧
            CGFloat detla = tapImageViewFrame.origin.x - rect.origin.x;
            targetRect.origin.x = -(detla * kScreenW)/tapImageViewFrame.size.width;
        } else if (rect.origin.x == tapImageViewFrame.origin.x) {
        } else{ // 在点击 cell 的右侧
            CGFloat detla = rect.origin.x - tapImageViewFrame.origin.x;
            targetRect.origin.x = (detla * kScreenW)/tapImageViewFrame.size.width;
        }
        NSValue *targetValue = [NSValue valueWithCGRect:targetRect];
        [animationEndFrames addObject:targetValue];
    }
    
    return animationEndFrames;
}

- (IDParameterBlock)dismissAnimationWithTopAnimationImage:(UIImage *)topAnimationImage
                                   topAnimationStartFrame:(CGRect)topAnimationStartFrame
                                     topAnimationEndFrame:(CGRect)topAnimationEndFrame
                                     bottomAnimationImage:(UIImage *)bottomAnimationImage
                                bottomAnimationStartFrame:(CGRect)bottomAnimationStartFrame
                                  bottomAnimationEndFrame:(CGRect)bottomAnimationEndFrame
                                            visiableCells:(NSArray *)visiableCells
                                     animationStartFrames:(NSArray *)animationStartFrames
                                       animationEndFrames:(NSArray *)animationEndFrames
                                       fromViewController:(UIViewController *)fromViewController
                                         toViewController:(UIViewController *)toViewController
{
    __weak typeof(self) weakSelf = self;
    IDParameterBlock dismissAnimationBlock = ^(UIViewController *vc) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        UIImageView *topAnimationImageView = [strongSelf dequeueImageView];
        topAnimationImageView.frame = topAnimationEndFrame;
        topAnimationImageView.image = topAnimationImage;
        [vc.view.window addSubview:topAnimationImageView];
        
        UIImageView *bottomAnimationImageView = [strongSelf dequeueImageView];
        bottomAnimationImageView.frame = bottomAnimationEndFrame;
        bottomAnimationImageView.image = bottomAnimationImage;
        [vc.view.window addSubview:bottomAnimationImageView];
        
        
        __block NSMutableArray *animationImageViews = [NSMutableArray array];
        for (int i = 0; i < visiableCells.count; i++) {
            UIImageView *imageView = [strongSelf dequeueImageView];
            [animationImageViews addObject:imageView];
            NSValue *value = animationEndFrames[i];
            CGRect rect = [value CGRectValue];
            imageView.frame = rect;
            imageView.image = [strongSelf getImageViewOfCollectionCell:visiableCells[i]].image;
            [vc.view.window addSubview:imageView];
        }
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            topAnimationImageView.frame = topAnimationStartFrame;
            bottomAnimationImageView.frame = bottomAnimationStartFrame;
            
            for (int i = 0; i<animationImageViews.count; i++) {
                UIImageView *imageView = animationImageViews[i];
                NSValue *value = animationStartFrames[i];
                CGRect rect = [value CGRectValue];
                imageView.frame = rect;
            }
        } completion:^(BOOL finished) {
            [strongSelf enqueueImageView:topAnimationImageView];
            [strongSelf enqueueImageView:bottomAnimationImageView];
            
            [fromViewController.navigationController popViewControllerAnimated:NO];
            
            for (UIImageView *imageView in animationImageViews) {
                [strongSelf enqueueImageView:imageView];
            }
            animationImageViews = nil;
            
            toViewController.navigationController.navigationBar.hidden = NO;
        }];
    };
    
    return dismissAnimationBlock;
}

#pragma mark - Assist Methods

- (UIImageView *)getImageViewOfCollectionCell:(UICollectionViewCell *)cell {
    
    UIImageView *imageView = nil;
    UIView *collectionViewContentView = cell.subviews.firstObject;
    NSArray *views = collectionViewContentView.subviews;
    for (UIView *view in views) {
        if (view.tag == 12345) {
            imageView = (UIImageView *)view;
            break;
        }
    }
    return imageView;
}

- (void)enqueueImageView:(UIImageView *)imageView {
    
    if (imageView.superview) {
        imageView.image = nil;
        [imageView removeFromSuperview];
        [self.animationImageViewPool addObject:imageView];
    }
}

- (UIImageView *)dequeueImageView {
    
    UIImageView *imageView = nil;
    if (!_animationImageViewPool) {
        _animationImageViewPool = [NSMutableArray array];
    }
    if (self.animationImageViewPool.count > 0) {
        imageView = self.animationImageViewPool.firstObject;
        [self.animationImageViewPool removeObject:imageView];
    } else{
        imageView = [UIImageView new];
    }
    return imageView;
}

- (UIImage *)tailorImage:(UIImage *)image tailorPoint:(CGFloat)point tailorType:(TailorType)type {
    
    return [self tailorImage:image tailorPoint:point tailorType:type tailorHeight:0];
}

- (UIImage *)tailorImage:(UIImage *)image tailorPoint:(CGFloat)point tailorType:(TailorType)type tailorHeight:(CGFloat)height {
    
    CGSize imageSize = image.size;
    if (point > 0 && point < imageSize.height) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGRect rect = CGRectNull;
        switch (type) {
            case TailorTypeNone:
                break;
            case TailorTypeTop:
                rect = CGRectMake(0, 0, imageSize.width*scale, point*scale);
                break;
            case TailorTypeMiddle:
                rect = CGRectMake(0, point*scale, imageSize.width*scale, height*scale);
                break;
            case TailorTypeBottom:
                rect = CGRectMake(0, point*scale, imageSize.width*scale, (imageSize.height-point)*scale);
                break;
        }
        CGImageRef sourceImageRef = [image CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        return newImage;
    }
    return nil;
}

- (UIImage *)snapShotWithView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
