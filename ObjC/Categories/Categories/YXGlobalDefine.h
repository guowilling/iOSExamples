
#ifndef YXGlobalDefine_h
#define YXGlobalDefine_h

#ifdef DEBUG
#define YXLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"HH:mm:ss:SSSS"];\
NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"[%s:%d %s] %s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [dateString UTF8String], [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}
#else
#define YXLog(FORMAT, ...) nil
#endif

#define WEAK_SELF __weak typeof(self) weakSelf = self;
#define STRONG_SELF __strong typeof(weakSelf) strongSelf = weakSelf;

#define IS_iOS10        [[UIDevice currentDevice] systemVersion].floatValue >= 10.0
#define kSystemVersion  [UIDevice currentDevice].systemVersion.floatValue

// 版本适配
//if (@available(iOS 11.0, *)) {
//}

#define ValidString(str)      (str != nil && [str isKindOfClass:[NSString class]] && ![str isEqualToString:@""])
#define ValidDictionary(dict) (dict != nil && [dict isKindOfClass:[NSDictionary class]])
#define ValidArray(arr)       (arr != nil && [arr isKindOfClass:[NSArray class]] && [arr count] > 0)

#endif /* YXGlobalDefine_h */
