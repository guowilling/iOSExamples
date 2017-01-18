//
//  ViewController.m
//  iOSAllFonts
//
//  Created by Willing Guo on 17/1/8.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *familyNames;
@property (nonatomic, strong) NSArray *fontNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTableView];
    
    self.familyNames = [UIFont familyNames];
    NSLog(@"familyNames: %@", self.familyNames);
    
    NSMutableArray *tempArrayM = [NSMutableArray array];
    for (NSString *familyName in self.familyNames) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        NSLog(@"fontNames: %@", fontNames);
        [tempArrayM addObject:fontNames];
    }
    self.fontNames = tempArrayM;
    //NSLog(@"fontNames: %@", self.fontNames);
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20,
                                                                           self.view.frame.size.width,
                                                                           self.view.frame.size.height - 20)
                                                          style:UITableViewStylePlain];
    
    tableView.rowHeight = 75;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.familyNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fontNames[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"125雨晴阴℃";
    cell.textLabel.font = [UIFont fontWithName:self.fontNames[indexPath.section][indexPath.row] size:25];
    cell.detailTextLabel.text = self.fontNames[indexPath.section][indexPath.row];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.familyNames[section];
}

@end
