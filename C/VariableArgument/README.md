# VariableArgument(可变参数的实现原理)

最近写了一个自定义的 ActionSheet, 参考系统的 UIActionSheet 的创建方式设计 API. 我们知道系统的 UIActionSheet 是使用可变参数来接收最后一个参数的, 我一直也只是知道怎么用, 于是这次查资料了解了可变参数的实现原理.

cocoa的API里使用到可变参数的地方:

````objc
+ (instancetype)arrayWithObjects:(ObjectType)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id<UIAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");
- (instancetype)initWithTitle:(nullable NSString *)title delegate:(nullable id<UIActionSheetDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");

````

## 哨兵参数

首先我们来看看C语言中常用的哨兵参数的实现:

````objc
int add(int firstNum, ...)
{
    int sum = 0;
    int number = firstNum;
    va_list argumentList;
    va_start(argumentList, firstNum);
    while(1)
    {
        printf("number = %d\n", number);
        sum += firstNum;
        number = va_arg(argumentList, int);
        if (number == 0) // 0作为哨兵参数
        {
            break;
        }
    }
    va_end(argumentList);
    return sum;
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        printf("sum is %d\n", add(1, 2, 3, 4, 5, 0)); // 调用add函数传入可变参数必须以0结尾
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
````
上面我们注意到, 哨兵参数实际上就是指定一个结束参数, 当遇到这个参数时停止接收参数.

## 可变参数

我们再来看看OC里的可变参数的实现:

````objc
// 注意: 可变参数只能是所有参数中的最后一个. 
// NS_REQUIRES_NIL_TERMINATION 用于编译时检查结尾是否为nil.
- (void)variableArgumentsMethod:(NSString *)arg1, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *stringArray = [NSMutableArray array];
    va_list args;
    va_start(args, arg1);
    if(arg1) {
        NSLog(@"%@", arg1);
        [stringArray addObject:arg1];
        
        NSString *nextArg;
        while((nextArg = va_arg(args, NSString *))) {
            [stringArray addObject:nextArg];
            NSLog(@"%@", nextArg);
        }
    }
    NSLog(@"%@", stringArray);
    va_end(args);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self variableArgumentsMethod:@"Hello", @"World", @"!", nil];
}
````

上面我们主要用到了以下几个函数:
> * **va_list argumentList** : 定义一个指向可变参数列表的指针argumentList.

> * **va_start(argumentList, last\_determine\_param)** : 使用argumentList指针指向函数参数列表中的第一个参数.
  - 说明 : 可变参数之前必须有一个或多个确定参数, last\_determine\_param是位于可变参数之前的最后一个固定参数( ... 之前的最后一个参数). 调用va_start()时last\_determine\_param被用作第二个参数传入.
  - 函数参数列表中参数在内存中的顺序与函数声明时的顺序是一致的, 比如有一个可变参数函数的声明是: **void va_test(char a, char b, char c, ...)**, 则它的固定参数依次是a, b, c, last_determine_param为c, 因此就是 va\_start(arg_ptr, c).

> * **va_arg(argList, type)** : 返回argumentList所指的当前可变参数, 返回类型为type, 并使指针argumentList指向可变参数列表中的下一个参数.

> * **va_end(argList)** : 必须调用va_end()确保堆栈的正确恢复.

上述宏的原型如下:

> * **void va\_start(va\_list argptr, last_parm);**
> * **type va\_arg(va_list argptr, type);**
> * **void va\_end(va_list argptr);**

它们都包含在头文件stdarg.h.

下面是自定义ActionSheet中可变参数的实际使用方式:

````objc
+ (void)sr_showActionSheetViewWithTitle:(NSString *)title
                               delegate:(id<SRActionSheetDelegate>)delegate
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSString *)firstOtherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;           
````

````objc
+ (void)sr_showActionSheetViewWithTitle:(NSString *)title
                               delegate:(id<SRActionSheetDelegate>)delegate
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSString *)firstOtherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherButtonTitles = [NSMutableArray array];
    va_list argumentList;
    if (firstOtherButtonTitle) {
        [otherButtonTitles addObject:firstOtherButtonTitle];
        va_start(argumentList, firstOtherButtonTitle);
        NSString *nextOtherButtonTitle = nil;
        while ((nextOtherButtonTitle = va_arg(argumentList, NSString *))) {
            [otherButtonTitles addObject:nextOtherButtonTitle];
        }
        va_end(argumentList);
    }
    
    [[[self alloc] initWithTitle:title
               cancelButtonTitle:cancelButtonTitle
          destructiveButtonTitle:destructiveButtonTitle
               otherButtonTitles:otherButtonTitles
                        delegate:delegate] show];
}
````