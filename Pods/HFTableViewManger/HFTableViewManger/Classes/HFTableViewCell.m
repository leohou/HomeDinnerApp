//
//  HFTableViewCell.m
//  HFKitDemo
//
//  Created by helfy  on 15/8/18.
//  Copyright (c) 2015年 helfy. All rights reserved.
//

#import "HFTableViewCell.h"

@implementation HFTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    //TODO
}

- (void)bindData:(HFTableViewCellModel *)cellModel {
    _cellModel = cellModel;
    
    //TODO:
}

@end
