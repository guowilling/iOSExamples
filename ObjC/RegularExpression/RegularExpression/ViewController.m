//
//  ViewController.m
//  RegularExpression
//
//  Created by Willing Guo on 17/1/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "RegexKitLite.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *testString = @"[偷笑] http://foo.com/blah_blah @Ring花椰菜:就舍不得打[test]就惯#急急急#着他吧[挖鼻屎]//@崔西狮:小拳头举起又放下了//@toto97:@崔西狮 http://foo.com/blah_blah";
    
    // [表情]
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    // #话题#
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // URL
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    NSArray *componentsMatched = [testString componentsMatchedByRegex:pattern];
    NSLog(@"componentsMatched: %@", componentsMatched);
    
    [testString enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        // 匹配到一个结果, 就会调一次这个block.
        NSLog(@"%@", *capturedStrings);
        // 停止遍历
        //*stop = YES;
    }];
    
//    [testString enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//        NSLog(@"%@", *capturedStrings);
//    }];
}

void test2()
{
    NSString *testString = @"[偷笑] http://foo.com/blah_blah @Ring花椰菜:就舍不得打[test] 就惯#急急急#着他吧[挖鼻屎]//@崔西狮:小拳头举起又放下了 说点啥好呢…… //@toto97:@崔西狮 http://foo.com/blah_blah";
    
    // [表情]
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    // #话题#
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // URL
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    // | 匹配多个条件相当于or
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:testString options:0 range:NSMakeRange(0, testString.length)];
    for (NSTextCheckingResult *result in results) {
        NSLog(@"%@ %@", NSStringFromRange(result.range), [testString substringWithRange:result.range]);
    }
}

void test1()
{
    NSString *username = @"1234abcd";
    NSString *pattern = @"^\\d.*\\d$"; // 数字开头和数字结尾, 中间任意个任意字符.
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:username options:0 range:NSMakeRange(0, username.length)];
    NSLog(@"%zd", results.count);
    
//    Pattern : 匹配样式\规则
//    NSString *pattern = @"[0-9][0-9]"; // 两个连在一起的数字
//    NSString *pattern = @"\\d\\d\\d";  // 三个连在一起的数字
//    NSString *pattern = @"\\d{3}";     // 同上
//    NSString *pattern = @"\\d{2,4}";   // 2-4个连在一起的数字 例如@"555522"两个结果
    
//    ? : 0个或者1个
//    + == {1,} : 至少1个
//    * : 0个或者n个
//    
//    . : 任意符号
//    ^ 以什么开头
//    $ 以什么结束
//    
//    {x}   x个
//    {x,y} x到y个
//    .+ 任意1个以上
//    .* 任意0或n个
//    .? 任意0或1个
}

void test0()
{
    NSString *username = @"1234abcd";
    
    BOOL flag = YES;
    for (int i = 0; i<username.length; i++) {
        unichar c = [username characterAtIndex:i];
        if (!(c >= '0' && c <= '9')) {
            flag = NO;
            break;
        }
    }
    
    if (flag) {
        NSLog(@"只包含数字");
    } else {
        NSLog(@"包含非数字");
    }
}

@end
