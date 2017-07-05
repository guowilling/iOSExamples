//
//  HomeAnimationTool.h
//  AirbnbHomeAnimationDemo
//
//  Created by 郭伟林 on 2017/7/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^NoParameterBlock)(void);
typedef void(^IDParameterBlock)(id);

@interface HomeAnimationTool : NSObject

- (IDParameterBlock)begainAnimationWithCollectionView:(UICollectionView *)collectionView
                             didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                                   fromViewController:(UIViewController *)fromViewController
                                     toViewController:(UIViewController *)toViewController
                                          finishBlock:(NoParameterBlock)finishBlock;

@end
