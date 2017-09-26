//
//  SRSingleton.h
//  RecordAudioSImpleCode
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#ifndef SRSingleton_h
#define SRSingleton_h

#define SRSingletonInterface  + (instancetype)shareInstance;

#define SRSingletonImplement(class) \
\
static class *_shareInstance; \
\
+ (instancetype)shareInstance { \
\
if(!_shareInstance) {\
_shareInstance = [[class alloc] init]; \
} \
return _shareInstance; \
} \
\
+(instancetype)allocWithZone:(struct _NSZone *)zone { \
\
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_shareInstance = [super allocWithZone:zone]; \
}); \
return _shareInstance; \
\
}

#endif /* SRSingleton_h */
