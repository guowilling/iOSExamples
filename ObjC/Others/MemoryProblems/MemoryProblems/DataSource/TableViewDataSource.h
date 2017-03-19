//
//  ArrayDataSource.h
//
//
//  Created by SR on 6/16/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item, NSIndexPath *indexPath);

@interface TableViewDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
               tableViewStyle:(UITableViewCellStyle)tableViewStyle
           configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@property (nonatomic, assign) UITableViewCellStyle tableViewStyle;

@end
