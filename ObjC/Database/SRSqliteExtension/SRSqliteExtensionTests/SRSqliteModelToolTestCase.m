//
//  SRSqliteModelToolTestCase.m
//  SRSqliteExtension
//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SRSqliteModelTool.h"
#import "Student.h"

@interface SRSqliteModelToolTestCase : XCTestCase

@end

@implementation SRSqliteModelToolTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testCreateTable {
    
    BOOL result = [SRSqliteModelTool createTable:[Student class] uid:nil];
    XCTAssertTrue(result);
}

- (void)testRequiredUpdate {
    
    BOOL isUpdate = [SRSqliteModelTool isTableRequiredUpdate:[Student class] uid:nil];
    XCTAssertFalse(isUpdate);
}

- (void)testUpdateTable {
    
    BOOL update = [SRSqliteModelTool updateTable:[Student class] uid:nil];
    XCTAssertTrue(update);
}

- (void)testSaveModel {
    
    Student *stu = [[Student alloc] init];
    stu.stuNum = 1;
    stu.name = @"David";
    stu.age = 99;
    stu.score = 999;
    stu.arr = @[@"tmp"];
    stu.dic = @{@"tmp@": @"tmp"};
    [SRSqliteModelTool saveOrUpdateModel:stu uid:nil];
}

- (void)testDeleteModel {
    
    Student *stu = [[Student alloc] init];
    stu.stuNum = 1;
    stu.name = @"David";
    stu.age = 99;
    stu.score = 999;
    [SRSqliteModelTool deleteModel:stu uid:nil];
}

- (void)testDeleteModelWhere1 {
    
    [SRSqliteModelTool deleteModel:[Student class] whereStr:@"score <= 4" uid:nil];
}

- (void)testDeleteModelWhere2 {
    
    [SRSqliteModelTool deleteModel:[Student class] columnName:@"name" relation:ColumnNameToValueRelationTypeEqual value:@444 uid:nil];
}

- (void)testQueryAllModels1 {
    
    NSArray *results = [SRSqliteModelTool queryAllModels:[Student class] uid:nil];
    NSLog(@"%@", results);
}

- (void)testQueryAllModels {
    
    NSArray *results = [SRSqliteModelTool queryModels:[Student class] columnName:@"name" relation:ColumnNameToValueRelationTypeEqual value:@"David" uid:nil];
    NSLog(@"%@", results);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
