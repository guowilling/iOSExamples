
#import <Foundation/Foundation.h>

@interface Person : NSObject

- (void)eat1;
- (void)run1;

- (nonnull Person *)eat2;
- (nonnull Person *)run2;

- (Person * _Nonnull (^ _Nonnull)())eat3;
- (Person * _Nonnull (^ _Nonnull)())run3;

- (Person * _Nonnull (^ _Nonnull)(NSString * _Nonnull food))eat4;
- (Person * _Nonnull (^ _Nonnull)(float distance))run4;

@end
