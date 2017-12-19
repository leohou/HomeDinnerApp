//
//  HFTableCellObj.m
//  HFKitDemo
//
//  Created by helfy  on 15/8/18.
//  Copyright (c) 2015年 helfy. All rights reserved.
//

#import "HFTableViewCellModel.h"

@implementation HFTableViewCellModel

+ (instancetype)cellModelForCellClassName:(NSString *)cellClassName {
    HFTableViewCellModel *cellModel = [[[self class] alloc] init];
    cellModel.tablViewCellClassName = cellClassName;
    return cellModel;
}
+ (instancetype)cellModelForCellClassName:(NSString *)cellClassName cellData:(id)cellData {
    HFTableViewCellModel *cellModel =  [self cellModelForCellClassName:cellClassName];
    cellModel.cellData = cellData;
    return cellModel;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setupDefauleValues];
    }
    return self;
}

- (void)setupDefauleValues {
    self.tablViewCellClassName = @"UITableViewCell";
}

- (NSString *)cellIdentifier {
    if(_cellIdentifier) {
        return _cellIdentifier;
    }
    return self.tablViewCellClassName;
}

@end