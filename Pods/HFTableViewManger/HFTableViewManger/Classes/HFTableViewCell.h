//
//  HFTableViewCell.h
//  HFKitDemo
//
//  Created by helfy  on 15/8/18.
//  Copyright (c) 2015年 helfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFTableViewCellModel.h"

/**
 *  cell 最好继承该类。。如不继承。最好也有bindData: 这个方法， 都没有的话。自己使用cell的config 或者代理 进行配置吧
 */
@interface HFTableViewCell : UITableViewCell

@property (nonatomic,readonly) HFTableViewCellModel*cellModel;

/**
 *  重载该函数来设置你的UI
 */
- (void)setupView; 

- (void)bindData:(HFTableViewCellModel *)cellModel NS_REQUIRES_SUPER;

@end
