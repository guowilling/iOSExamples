//
//  ViewController.m
//  AppInternationalization
//
//  Created by 郭伟林 on 16/12/12.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRActionSheet.h"
#import "SRInternationalizationTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = SRLocalizedStringForKey(@"AppInternationalization");
    
    [self.view addSubview:({
        UILabel *testLabel = [[UILabel alloc] init];
        testLabel.frame = CGRectMake(0, 0, 100, 50);
        testLabel.center = self.view.center;
        // SRLocalizedStringForKey(@"你 好") == SRLocalizedStringForKeyFromTable(@"你好", nil) == SRLocalizedStringForKeyFromTable(@"你好", @"CustomLocalizable")
        testLabel.text = SRLocalizedStringForKey(@"你 好");
        testLabel.textAlignment = NSTextAlignmentCenter;
        testLabel;
    })];
    
    [self.view addSubview:({
        UIButton *switchBtn = [[UIButton alloc] init];
        switchBtn.frame = CGRectMake(0, 0, 100, 50);
        switchBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
        [switchBtn setTitle:[[SRInternationalizationTool sharedInternationalizationTool] currentLanguageDescription] forState:UIControlStateNormal];
        [switchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [switchBtn addTarget:self action:@selector(switchBtnAction) forControlEvents:UIControlEventTouchUpInside];
        switchBtn;
    })];
}

- (void)switchBtnAction {
    
    [SRActionSheet sr_showActionSheetViewWithTitle:nil
                                       cancelTitle:@"取消"
                                  destructiveTitle:nil
                                       otherTitles:@[@"跟随系统", @"简体中文", @"英文", @"日文"]
                                  selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                      switch (index) {
                                          case 0:
                                              [[SRInternationalizationTool sharedInternationalizationTool] setCurrentLanguage:nil];
                                              break;
                                          case 1:
                                              [[SRInternationalizationTool sharedInternationalizationTool] setCurrentLanguage:@"zh-Hans"];
                                              break;
                                          case 2:
                                              [[SRInternationalizationTool sharedInternationalizationTool] setCurrentLanguage:@"en"];
                                              break;
                                          case 3:
                                              [[SRInternationalizationTool sharedInternationalizationTool] setCurrentLanguage:@"ja"];
                                              break;
                                      }
                                  }];
}

@end
