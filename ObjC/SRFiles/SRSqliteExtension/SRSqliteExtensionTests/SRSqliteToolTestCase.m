//
//  SRSqliteToolTestCase.m
//  SRSqliteExtension
//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SRSqliteTool.h"

@interface SRSqliteToolTestCase : XCTestCase

@end

@implementation SRSqliteToolTestCase

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
    
    NSString *createTable = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
    BOOL result = [SRSqliteTool executeSQL:createTable uid:nil];
    XCTAssertEqual(result, YES);
}

- (void)testQuery {
    
    NSString *deleteData = @"delete from t_stu";
    BOOL deleteResult = [SRSqliteTool executeSQL:deleteData uid:nil];
    XCTAssertTrue(deleteResult);
    
    NSString *insertStu1 = @"insert into t_stu(id, name, age, score) values (1, 'aa', 15, 99)";
    BOOL insertResult1 = [SRSqliteTool executeSQL:insertStu1 uid:nil];
    XCTAssertTrue(insertResult1);
    
    NSString *insertStu2 = @"insert into t_stu(id, name, age, score) values (2, 'bb', 25, 99)";
    BOOL insertResult2 = [SRSqliteTool executeSQL:insertStu2 uid:nil];
    XCTAssertTrue(insertResult2);
    
    NSString *queryStu = @"select * from t_stu";
    NSArray *queryResult = [SRSqliteTool querySQL:queryStu uid:nil];
    NSArray *verification = @[@{@"id": @1,
                                @"name": @"aa",
                                @"age": @15,
                                @"score": @99},
                              @{@"id": @2,
                                @"name": @"bb",
                                @"age": @25,
                                @"score": @99}];
    XCTAssertTrue([queryResult isEqualToArray:verification]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
