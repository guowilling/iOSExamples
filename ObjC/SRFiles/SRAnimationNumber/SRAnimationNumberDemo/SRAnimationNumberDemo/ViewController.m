//
//  ViewController.m
//  SRAnimationNumberDemo
//
//  Created by 郭伟林 on 2018/2/26.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAnimationNumerEngine.h"
#import "UILabel+SRAnimationNumber.h"
#import "UIButton+SRAnimationNumber.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeCurve:SRAnimationNumerCurveEaseInOut];
}

- (IBAction)select:(UISegmentedControl *)sender {
    [self changeCurve:sender.selectedSegmentIndex];
}

- (void)changeCurve:(SRAnimationNumerCurve)curve {
    [self exampleLabel1:curve];
    [self exampleLabel2:curve];
    [self exampleLabel3:curve];
    
    [self exampleButton1:curve];
    [self exampleButton2:curve];
    [self exampleButton3:curve];
}

#pragma mark - UIlabel

- (void)exampleLabel1:(SRAnimationNumerCurve)curve {
    [self.label1 sr_animationFromNumber:0 toNumber:100 duration:1.5 curve:curve format:^NSString *(CGFloat currentNumber) {
        return [NSString stringWithFormat:@"%.2f", currentNumber];
    }];
}

- (void)exampleLabel2:(SRAnimationNumerCurve)curve {
    [self.label2 sr_animationFromNumber:0 toNumber:100 duration:1.5 curve:curve attributedFormat:^NSAttributedString *(CGFloat currentNumber) {
        NSString *string = [NSString stringWithFormat:@"%.0f%%", currentNumber];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:25],
                                          NSForegroundColorAttributeName: [UIColor whiteColor]}
                                  range:NSMakeRange(0, string.length)];
        return attributedString;
    } completion:^(CGFloat endNumber) {
        self.label2.textColor = [UIColor redColor];
    }];
}

- (void)exampleLabel3:(SRAnimationNumerCurve)curve {
    [self.label3 sr_animationFromNumber:0 toNumber:123456789 duration:1.5 curve:curve format:^NSString *(CGFloat currentNumber) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.positiveFormat = @"###,##0.00";
        NSNumber *amountNumber = [NSNumber numberWithFloat:currentNumber];
        return [NSString stringWithFormat:@"¥%@", [formatter stringFromNumber:amountNumber]];
    }];
}

#pragma mark - UIButton

- (void)exampleButton1:(SRAnimationNumerCurve)curve {
    [self.button1 sr_animationFromNumber:0 toNumber:100 duration:1.5 curve:curve format:^NSString *(CGFloat currentNumber) {
        return [NSString stringWithFormat:@"%.2f", currentNumber];
    }];
}

- (void)exampleButton2:(SRAnimationNumerCurve)curve {
    [self.button2 sr_animationFromNumber:0 toNumber:100 duration:1.5 curve:curve attributedFormat:^NSAttributedString *(CGFloat currentNumber) {
        NSString *string = [NSString stringWithFormat:@"%.0f%%", currentNumber];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:25],
                                          NSForegroundColorAttributeName: [UIColor redColor]}
                                  range:NSMakeRange(0, string.length)];
        return attributedString;
    }];
}

- (void)exampleButton3:(SRAnimationNumerCurve)curve {
    [self.button3 sr_animationFromNumber:0 toNumber:123456789 duration:1.5 curve:curve format:^NSString *(CGFloat currentNumber) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.positiveFormat = @"###,##0.00";
        NSNumber *amountNumber = [NSNumber numberWithFloat:currentNumber];
        return [NSString stringWithFormat:@"¥%@", [formatter stringFromNumber:amountNumber]];
    }];
}

@end
