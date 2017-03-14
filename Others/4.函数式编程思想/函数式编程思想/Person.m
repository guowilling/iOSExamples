
#import "Person.h"

@implementation Person

- (void)eat1 {
    
    NSLog(@"eat1");
}

- (void)run1 {
    
    NSLog(@"run1");
}

- (Person *)eat2 {
    
    NSLog(@"eat2");
    return self;
}

- (Person *)run2 {
    
    NSLog(@"run2");
    return self;
}

- (Person * _Nonnull (^)())eat3 {
    
    Person * (^myEatBlock)() = ^ Person * () {
        NSLog(@"eat3");
        return self;
    };
    return myEatBlock;
}

- (Person * _Nonnull (^)())run3 {
    
    return ^ Person * {
        NSLog(@"run3");
        return self;
    };
}

- (Person * _Nonnull (^)(NSString * _Nonnull))eat4 {
    
    return ^ Person * (NSString * food) {
        NSLog(@"eat %@", food);
        return self;
    };
}

- (Person * _Nonnull (^)(float))run4 {
    
    return ^ Person * (float distance) {
        NSLog(@"run %.2f meters", distance);
        return self;
    };
}

@end
