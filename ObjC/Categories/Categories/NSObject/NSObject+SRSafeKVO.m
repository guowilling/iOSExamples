//
//  NSObject+SRSafeKVO.m
//  SRSafeKVODemo
//
//  Created by 郭伟林 on 2018/8/17.
//  Copyright © 2018年 SR. All rights reserved.
//  防止添加和移除监听的次数不成对, 引起的程序崩溃

#import "NSObject+SRSafeKVO.h"
#import <objc/runtime.h>

@implementation NSObject (SRSafeKVO)

+ (void)load {
    Method addObserverM = class_getInstanceMethod(self, @selector(addObserver:forKeyPath:options:context:));
    Method hook_addObserverM = class_getInstanceMethod(self, @selector(hook_addObserver:forKeyPath:options:context:));
    if (class_addMethod(self, @selector(addObserver:forKeyPath:options:context:), method_getImplementation(hook_addObserverM), method_getTypeEncoding(hook_addObserverM))) {
        class_replaceMethod(self,
                            @selector(hook_addObserver:forKeyPath:options:context:),
                            method_getImplementation(addObserverM),
                            method_getTypeEncoding(addObserverM));
    } else {
        method_exchangeImplementations(addObserverM, hook_addObserverM);
    }
    
    {
        Method removeObserverM = class_getInstanceMethod(self, @selector(removeObserver:forKeyPath:context:));
        Method hook_removeObserverM = class_getInstanceMethod(self, @selector(hook_removeObserver:forKeyPath:context:));
        if (class_addMethod(self, @selector(removeObserver:forKeyPath:context:), method_getImplementation(hook_removeObserverM), method_getTypeEncoding(hook_removeObserverM))) {
            class_replaceMethod(self,
                                @selector(hook_removeObserver:forKeyPath:context:),
                                method_getImplementation(removeObserverM),
                                method_getTypeEncoding(removeObserverM));
        } else {
            method_exchangeImplementations(removeObserverM, hook_removeObserverM);
        }
    }
    
    {
        Method removeObserverM = class_getInstanceMethod(self, @selector(removeObserver:forKeyPath:));
        Method hook_removeObserverM = class_getInstanceMethod(self, @selector(hook_removeObserver:forKeyPath:));
        if (class_addMethod(self, @selector(removeObserver:forKeyPath:), method_getImplementation(hook_removeObserverM), method_getTypeEncoding(hook_removeObserverM))) {
            class_replaceMethod(self,
                                @selector(hook_removeObserver:forKeyPath:),
                                method_getImplementation(removeObserverM),
                                method_getTypeEncoding(removeObserverM));
        } else {
            method_exchangeImplementations(removeObserverM, hook_removeObserverM);
        }
    }
}

- (void)hook_addObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    if (![self hasObserverdKeyPath:keyPath]) {
        [self hook_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)hook_removeObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath context:(nullable void *)context {
    if ([self hasObserverdKeyPath:keyPath]) {
        [self hook_removeObserver:observer forKeyPath:keyPath context:context];
    }
}

- (void)hook_removeObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath {
    if ([self hasObserverdKeyPath:keyPath]) {
        [self hook_removeObserver:observer forKeyPath:keyPath];
    }
}

- (BOOL)hasObserverdKeyPath:(NSString *)destKeyPath {
    id info = self.observationInfo;
    NSArray *array = [info valueForKeyPath:@"_observances._property._keyPath"];
    for (id keyPath in array) {
        if ([keyPath isEqualToString:destKeyPath]) {
            return YES;
        }
    }
    return NO;
}

@end
