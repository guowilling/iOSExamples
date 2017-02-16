//
//  ArrayDataSource.h
//
//
//  Created by SR on 6/16/15.
//
//

#import "TableViewDataSource.h"

@interface TableViewDataSource ()

@end

@implementation TableViewDataSource

#pragma mark - Initializer

- (id)init {
    return nil;
}

- (instancetype)initWithItems:(NSArray*)items
               cellIdentifier:(NSString*)cellIdentifier
           configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
{
    return [self initWithItems:items
                cellIdentifier:cellIdentifier
                tableViewStyle:UITableViewCellStyleDefault
            configureCellBlock:configureCellBlock];
}

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
               tableViewStyle:(UITableViewCellStyle)tableViewStyle
           configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        _items = items;
        _cellIdentifier = cellIdentifier;
        _configureCellBlock = [configureCellBlock copy];
        _tableViewStyle = tableViewStyle;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    UITableViewCell *cell = nil;
    if (self.tableViewStyle != UITableViewCellStyleDefault) {
        cell = [[UITableViewCell alloc] initWithStyle:self.tableViewStyle reuseIdentifier:self.cellIdentifier];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    }
    id item = self.items[indexPath.row];
    self.configureCellBlock(cell, item, indexPath);
    return cell;
}

@end
