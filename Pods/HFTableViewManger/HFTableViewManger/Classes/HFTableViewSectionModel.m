//
//  HFTableSectionObj.m
//  HFKitDemo
//
//  Created by helfy  on 15/9/6.
//  Copyright (c) 2015年 helfy. All rights reserved.
//

#import "HFTableViewSectionModel.h"

@implementation HFTableViewSectionModel {
    dispatch_semaphore_t _lock;
}

+ (instancetype)sectionModelWithCellModels:(NSMutableArray *)cellModels {
    HFTableViewSectionModel *sectionModel = [[HFTableViewSectionModel alloc] init];
    sectionModel.cellModels = cellModels;
    return sectionModel;
}

- (id)init {
    self = [super init];
    if(self) {
        _lock = dispatch_semaphore_create(1);
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault {
    self.cellModels = [NSMutableArray array];
    self.headHeigth = 40;
    self.footerHeigth = 0.000001f;
}

- (void)addCellModel:(HFTableViewCellModel *)model {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [self.cellModels addObject:model];
    dispatch_semaphore_signal(_lock);
}

@end
