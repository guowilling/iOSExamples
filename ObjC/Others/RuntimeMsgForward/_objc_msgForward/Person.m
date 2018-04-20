
#import "Person.h"
#import "Car.h"
#import <objc/runtime.h>

void run(id self, SEL _cmd)
{
    NSLog(@"%@ %s", self, sel_getName(_cmd));
}

@implementation Person

/**
 一:
 + (BOOL)resolveInstanceMethod:(SEL)sel
 + (BOOL)resolveClassMethod:(SEL)sel
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(run)) {
        class_addMethod(self, sel, (IMP)run, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

/**
 二:
 - (id)forwardingTargetForSelector:(SEL)aSelector
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [[Car alloc] init];
}

/**
 三:
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
 - (void)forwardInvocation:(NSInvocation *)anInvocation
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selName = NSStringFromSelector(aSelector);
    if ([selName isEqualToString:@"run"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = [anInvocation selector];
    Car *car = [[Car alloc] init];
    if ([car respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:car];
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector { // Crash
    [super doesNotRecognizeSelector:aSelector];
}

// "v@:", 每个方法默认隐藏两个参数, self 和 _cmd, self 代表方法调用着, _cmd 代表这个方法的 SEL.
// 'v' 代表返回值是 void, '@' 代表 self, ':' 代表 _cmd

@end
