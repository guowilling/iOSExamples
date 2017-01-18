//
//  ViewController.m
//  ApplicationSandbox
//
//  Created by Willing Guo on 17/1/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

/**
 应用沙盒: 应用沙盒就是文件系统, 每个应用都有自己的应用沙盒, 与其他应用的文件系统隔离.
 {
     应用程序包: 包含所有的资源文件和可执行文件.
     
     Documents: 保存应用运行时生成的需要持久化的数据, 苹果官方建议将程序中创建的或在程序中浏览到的文件数据保存在该目录, iTunes备份和恢复的时候会包括此目录.
     
     Library: 存储程序的默认设置和其他状态信息, iTunes会自动备份该目录.
         Libaray/Caches: 存放缓存文件, 此目录下的文件不会在应用退出后删除, 一般用于存放比较大的, 不是特别重要的资源, iTunes不会备份此目录.
         Libaray/Preferences: 保存应用的偏好设置, iOS系统的设置应用会在该目录中查找应用的设置信息, iTunes会自动备份该目录.
     
     tmp: 保存应用运行时所需的临时数据, 使用完毕后再从该目录删除. 应用没有运行时, 系统也有可能会清除该目录下的文件, iphone重启时该目录下的文件会丢失, iTunes不会同步该目录.
 }
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 沙盒根目录
    NSString *homeDirectory = NSHomeDirectory();
    NSLog(@"homeDirectory:%@", homeDirectory);
    
    // Documents目录
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documentsPaths objectAtIndex:0];
    NSLog(@"Documents:%@", documentsPath);
    
    {
        // 写入文件
        NSString *testFilePath = [documentsPath stringByAppendingPathComponent:@"testFile.txt"];
        NSArray *testContent = @[@"guo", @"wei", @"lin"];
        [testContent writeToFile:testFilePath atomically:YES];
        
        // 读取文件
        NSArray *fromTestFile = [[NSArray alloc] initWithContentsOfFile:testFilePath];
        NSLog(@"read from test file: %@", fromTestFile);
    }
    
    {
        // 创建目录
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES
                                attributes:nil error:nil];
        
        // 写入文件
        NSString *testDirectoryTestFilePath1 = [testDirectory stringByAppendingPathComponent:@"testFile1.txt"];
        NSString *testString1 = @"guoweilin";
        [fileManager createFileAtPath:testDirectoryTestFilePath1 contents:[testString1 dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        // 写入文件
        NSString *testString2 = @"guowilling";
        NSString *testDirectoryTestFilePath2 = [testDirectory stringByAppendingPathComponent:@"testFile2.txt"];
        [testString2 writeToFile:testDirectoryTestFilePath2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        {
            NSFileManager *fileManage = [NSFileManager defaultManager];
            
            // 获取目录里所有文件名包括文件夹
            NSArray *files1 = [fileManage subpathsOfDirectoryAtPath:documentsPath error:nil];
            NSLog(@"%@", files1);
            
            files1 = [fileManage subpathsAtPath:documentsPath];
            NSLog(@"%@", files1);
            
            NSArray *files2 = [fileManage subpathsOfDirectoryAtPath:testDirectory error:nil];
            NSLog(@"%@", files2);
            
            files2 = [fileManage subpathsAtPath:testDirectory];
            NSLog(@"%@", files2);
        }
        
        {
            // 通过fileManager操作当前目录
            [fileManager changeCurrentDirectoryPath:[documentsPath stringByExpandingTildeInPath]];
            NSString *fileName = @"testChangeCurrentDirectory.txt";
            NSArray *testArray = [[NSArray alloc] initWithObjects:@"hello world0!", @"hello world1!", @"hello world2!", nil];
            [testArray writeToFile:fileName atomically:YES];
            //[fileManager removeItemAtPath:fileName error:nil];
        }
    }
    
    {
        // 混合数据的读写
        NSString *dataMFileName = @"testMutableData.txt";
        NSString *dataMFilePath = [documentsPath stringByAppendingPathComponent:dataMFileName];
        NSString *tempString = @"Hello!";
        int dataInt = 55;
        float dataFloat = 0.55f;
        NSMutableData *mutableData = [[NSMutableData alloc] init];
        [mutableData appendData:[tempString dataUsingEncoding:NSUTF8StringEncoding]];
        [mutableData appendBytes:&dataInt length:sizeof(dataInt)];
        [mutableData appendBytes:&dataFloat length:sizeof(dataFloat)];
        [mutableData writeToFile:dataMFilePath atomically:YES];
        
        int intData;
        float floatData = 0.0;
        NSString *stringData;
        NSData *reader = [NSData dataWithContentsOfFile:dataMFilePath];
        stringData = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(0, [tempString length])] encoding:NSUTF8StringEncoding];
        [reader getBytes:&intData range:NSMakeRange([tempString length], sizeof(intData))];
        [reader getBytes:&floatData range:NSMakeRange([tempString length] + sizeof(intData), sizeof(floatData))];
        NSLog(@"stringData:%@  intData:%d  floatData:%f", stringData, intData, floatData);
    }
    
    {
        // Libaray目录
        NSArray  *libarayPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libaray = [libarayPaths objectAtIndex:0];
        NSLog(@"Libaray:%@", libaray);
        
        // Libaray/Caches目录
        NSArray  *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *caches = [cachesPaths objectAtIndex:0];
        NSLog(@"Caches:%@", caches);
        
        // Library/Preference目录
        // 通过NSUserDefaults类存取该目录下的设置文件信息
    }
    
    {
        // tmp目录
        NSString *tmp = NSTemporaryDirectory();
        NSLog(@"tmp:%@", tmp);
    }
    
    /** 
     文件操作
     {
         写入文件: 写入文件需要首先判定该文件的上级文件夹是否存在, 存在才可以进行写入, 否则需先创建上级路径. 使用writeToFile: 方法, 写入文件的同时系统会自动创建该文件.
         
         一般数据类型比如: 数组、字典、NSData、NSString 都可以直接调用writeToFile: 方法写入文件.
     
         自动创建文件代码: [arrayA writeToFile:filePath atomically:YES];
     
         手动创建文件代码: [fileManager createFileAtPath:destinationPath contents:[string dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]
     }
     
     {
         读取文件: 如果文件的内容的数据类型是一般数据类型, 则可以直接读取文件的内容到一般数据类型中.
     
         代码: NSArray *arrayA = [[NSArray alloc] initWithContentsOfFile:filePath];
     
         PS: 有些时候需要用到混合数据的写入与读取, 可以使用 NSMutableData 实现
     }
     */
    
    /** 
     文件夹操作
     {
         创建文件夹: 使用 Foundation 框架下的 NSFileManager 类可以进行沙盒文件夹操作.
         
         新建文件夹需指定文件夹的绝对路径, 并且要保证新建文件夹的上级路径已经存在, 否则需要先创建上级文件夹路径.
         
         代码:
         if ([[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
             return NO;
         } else {
             [[NSFileManager defaultManager] createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
             return YES;
         }
     }

     PS: 如何保证新建文件夹的上级文件夹已经存在, Foundation 框架中的 NSPathUtilities 类中提供了一些操作路径的方法:
     stringByDeletingLastPathComponent: 去掉路径中的最后一级成员, 比如: aa/bb/cc 执行后变为 aa/bb
     pathComponents: 拆分路径, 比如: aa/bb/cc 执行后得到数组 @[@"aa", @"bb", @"cc"]
     lastPathComponent: 获取路径中的最后一级成员, 比如: aa/bb/cc 执行后得到 cc
     ...
     
     {
         删除文件夹: 删除文件夹需先判定该文件夹是否存在 fileExistsAtPath: 方法, 如果存在执行删除操作使用removeItemAtPath: 方法.
         代码:
         if ([[NSFileManager defaultManager] fileExistsAtPath:pathFull]) {
             [[NSFileManager defaultManager] removeItemAtPath:pathFull error:&error];
         }
     }
     
     {
         移动文件夹: 文件夹移动需要两个参数, 文件夹原绝对路径与目标绝对路径 moveItemAtPath: 方法
         代码:
         if ([fileManager moveItemAtPath:prePath toPath:cenPath error:&error]!=YES) {
             NSLog(@"移动文件失败");
         } else {
             NSLog(@"移动文件成功");
         }
         PS: 文件夹移动需要注意的是, 要确保目标路径中除了目标文件夹之外的路径确实存在. 否则移动到一个还没有创建的文件夹下是会失败的, 这和创建文件夹是一样的.
     }
     
     {
         重命名文件夹: 重命名文件夹也需要两个参数, 原绝对路径与目标绝对路径, 其实重命名文件夹就是使用移动文件夹的方式实现的.
     }
     
     {
         获取目录下的所有文件与文件夹名称.
         代码:
         NSArray *fileNameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imagesFolder error:nil];
     }
     */
}

@end
