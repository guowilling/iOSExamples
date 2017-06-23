//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRModelProtocol.h"

typedef NS_ENUM(NSUInteger, ColumnNameToValueRelationType) {
    ColumnNameToValueRelationTypeMore,
    ColumnNameToValueRelationTypeLess,
    ColumnNameToValueRelationTypeEqual,
    ColumnNameToValueRelationTypeMoreEqual,
    ColumnNameToValueRelationTypeLessEqual,
};

@interface SRSqliteModelTool : NSObject

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;

+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;
+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;
+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;
+ (NSArray *)queryModels:(Class)cls sql:(NSString *)sql uid:(NSString *)uid;

@end
