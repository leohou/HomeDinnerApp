//
//  HFTableCellObj.h
//  HFKitDemo
//
//  Created by helfy  on 15/8/18.
//  Copyright (c) 2015年 helfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HFTableViewCellModel : NSObject
/**
 *  通过cellClassName 直接初始化 cellModel
 *
 *  @param cellClassName cell 的类名
 *
 *  @return cellModel
 */
+ (instancetype)cellModelForCellClassName:(NSString *)cellClassName;

+ (instancetype)cellModelForCellClassName:(NSString *)cellClassName cellData:(id)cellData;


@property (nonatomic, strong) NSString *tablViewCellClassName;

@property (nonatomic, strong) NSString *cellIdentifier;  //默认是cell的className，处理重用设置

@property (nonatomic, strong) UINib *cellNib;  //不设置则默认为以className为nib

@property (nonatomic, assign) CGFloat cellHeigth;  //行高  如不设置。会根据约束自行计算

@property (nonatomic, strong) id cellData;  //cell 的数据 类型自定



/**
 *  cell响应事件，快捷设置cell 的响应，适合设置或者个人中心cell 对应不同事件的配置，  该设置优先响应，并不再响应table的代理回调 如果不设置。则响应table 的代理
 */
@property (nonatomic,assign) SEL cellAction;   //响应对象 是 tableView 的delegate ,参数为cellModel
@property (nonatomic,strong) void (^cellDidSelectBlock)(UITableViewCell *cell,HFTableViewCellModel *cellModel); //不能同时设置cellAction，若设置cellAction，该回调不响应

@property (nonatomic,strong) void (^configCellBlock)(UITableViewCell *cell,HFTableViewCellModel *cellModel);  //配置cell 的回调。主要用于valueData不能满足设置的情况。设置该回调进行配置，比如cell有事件回调处理


@end


