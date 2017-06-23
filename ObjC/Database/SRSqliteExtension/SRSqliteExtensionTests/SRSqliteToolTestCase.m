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

- (void)testCreate {
    
    NSString *createSQLString = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
    BOOL result = [SRSqliteTool deal:createSQLString uid:nil];
    XCTAssertEqual(result, YES);
}

- (void)testQuery {
    
    NSString *deleteSQLString = @"delete from t_stu";
    BOOL deleteResult = [SRSqliteTool deal:deleteSQLString uid:nil];
    XCTAssertTrue(deleteResult);
    
    NSString *insert1 = @"insert into t_stu(id, name, age, score) values (1, 'sz', 18, 0)";
    BOOL insert1Result = [SRSqliteTool deal:insert1 uid:nil];
    XCTAssertTrue(insert1Result);
    
    NSString *insert2 = @"insert into t_stu(id, name, age, score) values (2, 'zs', 81, 1)";
    BOOL insert2Result = [SRSqliteTool deal:insert2 uid:nil];
    XCTAssertTrue(insert2Result);
    
    NSString *querySQLString = @"select * from t_stu";
    NSMutableArray *result = [SRSqliteTool querySql:querySQLString uid:nil];
    
    NSArray *verification = @[@{@"age": @18,
                                @"id": @1,
                                @"name": @"sz",
                                @"score": @0},
                              @{@"age": @81,
                                @"id": @2,
                                @"name": @"zs",
                                @"score": @1}];
    XCTAssertTrue([result isEqualToArray:verification]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
