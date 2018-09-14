
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"1111111");
//    dispatch_sync(dispatch_get_main_queue(), ^{ // 死锁
//        NSLog(@"2222222");
//    });
//    NSLog(@"3333333");
    
    
//    NSLog(@"1111111");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"currentThread: %@", [NSThread currentThread]);
//        dispatch_sync(dispatch_get_main_queue(), ^{ // 死锁
//            NSLog(@"currentThread: %@", [NSThread currentThread]);
//        });
//        NSLog(@"2222222");
//    });
//    NSLog(@"3333333");
    
    
//    2018-09-12 16:25:25.634913+0800 GCD线程间通信[10478:2696614] 1111111
//    2018-09-12 16:25:25.636185+0800 GCD线程间通信[10478:2696677] currentThread: <NSThread: 0x1c407bd40>{number = 3, name = (null)}
//    2018-09-12 16:25:27.637341+0800 GCD线程间通信[10478:2696614] currentThread: <NSThread: 0x1c0070f40>{number = 1, name = main}
//    2018-09-12 16:25:27.637396+0800 GCD线程间通信[10478:2696614] 2222222
//    2018-09-12 16:25:27.637756+0800 GCD线程间通信[10478:2696677] 3333333
//    NSLog(@"1111111");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"currentThread: %@", [NSThread currentThread]);
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [NSThread sleepForTimeInterval:2.0];
//            NSLog(@"currentThread: %@", [NSThread currentThread]);
//            NSLog(@"2222222");
//        });
//        NSLog(@"3333333");
//    });
    
    
//    2018-09-12 16:25:56.771265+0800 GCD线程间通信[10794:2698517] 1111111
//    2018-09-12 16:25:56.771631+0800 GCD线程间通信[10794:2698598] currentThread: <NSThread: 0x1c4460940>{number = 3, name = (null)}
//    2018-09-12 16:25:56.771699+0800 GCD线程间通信[10794:2698598] 3333333
//    2018-09-12 16:25:58.772770+0800 GCD线程间通信[10794:2698517] currentThread: <NSThread: 0x1c0072280>{number = 1, name = main}
//    2018-09-12 16:25:58.772814+0800 GCD线程间通信[10794:2698517] 2222222
    NSLog(@"1111111");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ // 子线程执行耗时操作
        NSLog(@"currentThread: %@", [NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{ // 主线程更新 UI
            [NSThread sleepForTimeInterval:2.0];
            NSLog(@"currentThread: %@", [NSThread currentThread]);
            NSLog(@"2222222");
        });
        NSLog(@"3333333");
    });
}

@end
