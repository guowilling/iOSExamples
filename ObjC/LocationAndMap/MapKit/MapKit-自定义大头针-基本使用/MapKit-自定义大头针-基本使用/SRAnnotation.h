//
//  SRAnnotation.h
//  MapKit-自定义大头针-基本使用
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SRAnnotation : NSObject <MKAnnotation>

/** 大头针位置 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/** 大头针标题 */
@property (nonatomic, copy) NSString *title;

/** 大头针子标题 */
@property (nonatomic, copy) NSString *subtitle;

@end
