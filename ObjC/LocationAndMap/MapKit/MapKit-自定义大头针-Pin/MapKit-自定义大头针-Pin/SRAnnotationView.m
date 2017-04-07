//
//  HMAnnotationView.m
//  10-自定义大头针(最基本)
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "SRAnnotationView.h"
#import "SRAnnotation.h"

@implementation SRAnnotationView

+ (instancetype)annotationViewWithMap:(MKMapView *)mapView {
    
    static NSString *identifier = @"SRAnnotationView";
    SRAnnotationView *annoView = (SRAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annoView == nil) {
        annoView = [[SRAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
    }
    return annoView;
}

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.canShowCallout = YES;
        self.leftCalloutAccessoryView  = [UIButton buttonWithType:UIButtonTypeContactAdd];
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    return self;
}

- (void)setAnnotation:(SRAnnotation *)annotation {
    
    [super setAnnotation:annotation];
    
    [self setImage:[UIImage imageNamed:annotation.icon]];
}

@end
