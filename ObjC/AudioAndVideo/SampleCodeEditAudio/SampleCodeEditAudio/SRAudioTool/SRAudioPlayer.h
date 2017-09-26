//
//  SRAudioPlayer.h
//  RecordAudioSImpleCode
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRSingleton.h"

@interface SRAudioPlayer : NSObject

SRSingletonInterface

@property (nonatomic, assign) CGFloat volumn;

@property (nonatomic, assign, readonly) CGFloat playProgress;

- (void)playAudioWithPath:(NSString *)path;

- (void)pause;

- (void)resume;

- (void)stop;

@end
