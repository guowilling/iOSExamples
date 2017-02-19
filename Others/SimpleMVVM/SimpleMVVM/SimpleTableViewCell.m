//
//  SimpleTableViewCell.m
//  SimpleMVVM
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SimpleTableViewCell.h"
#import "SimpleModel.h"

@interface SimpleTableViewCell ()

@end

@implementation SimpleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setSimpleModel:(SimpleModel *)simpleModel {
    
    _simpleModel = simpleModel;
    
    self.textLabel.text = simpleModel.text;
}

@end
