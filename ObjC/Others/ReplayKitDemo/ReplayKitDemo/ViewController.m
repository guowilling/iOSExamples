//
//  ViewController.m
//  ReplayKitDemo
//
//  Created by 郭伟林 on 17/5/22.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import <ReplayKit/ReplayKit.h>

@interface ViewController () <RPPreviewViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startReplayKit:(UIButton *)sender {
    
    if (sender.isSelected) {
        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            if (error) {
                NSLog(@"stopRecordingWithHandler error: %@", error);
            }
            if (previewViewController) {
                previewViewController.previewControllerDelegate = self;
                [self presentViewController:previewViewController animated:YES completion:nil];
            }
        }];
        sender.selected = NO;
        return;
    }
    
    if ([RPScreenRecorder sharedRecorder].available) {
        sender.selected = YES;
        [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
            NSLog(@"startRecordingWithMicrophoneEnabled error: %@", error);
        }];
    }
}

- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {

    [previewController dismissViewControllerAnimated:YES completion:nil];
}

@end
