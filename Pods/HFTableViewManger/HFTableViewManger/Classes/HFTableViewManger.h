//
//  HFTableViewManger.h
//  HFKitDemo
//
//  Created by helfy on 16/6/24.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HFTableViewCellModel.h"
#import "HFTableViewSectionModel.h"
#import "HFTableViewCell.h"

@interface HFTableView:UITableView
@end

/**
 *  manger 主要用户tableView delegate & dataSource 的管理 ，主要解决
 *  1.目前使用tableView 设置过于繁琐，
 *  2.用model 绑定cell。
 */

@interface HFTableViewManger : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readonly, strong) UITableView *tableView; //请勿直接设置tablView代理。设置了也没用
@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<UITableViewDataSource> dataSource;

@property(nonatomic, readonly, strong)  NSMutableArray *dataSourceModels; //需要展示的models
@property(nonatomic, readonly) BOOL isMutableSection; //是多section模式的的

/**
 *   根据tableView的样式初始化一个manger
 *
 *  @param style tablView的样式
 *
 *  @return 实例对象
 */
+ (instancetype)mangerForTableViewStyle:(UITableViewStyle)style;

/**
 *  把数据转化成符合格式的cellObj。 用于列表数据
 *  如果数据中对应多种cell 样式，需按需求设置对应的cellClassName 再使用setupDataSourceModels: isAddmore:
*
 *  @param dataSource  数据原型
 *  @param className  cell 的className
 *  @param addMore    yes 数据直接添加到已有数据之后。NO 覆盖
 */
- (void)setupDataSourceModelsForData:(NSArray *)dataSource cellClassName:(NSString *)className  isAddmore:(BOOL)addMore;

/**
 *  自己转换成cellObj后进行设置

 *  @param cellObj cellObj
 *  @param addMore yes 数据直接添加到已有数据之后。NO 覆盖
 */
- (void)setupDataSourceModels:(NSArray *)dataModels isAddmore:(BOOL)addMore;

/**
 *  通过cellModel 获取到indexPath
 *
 *  @param cellModel cellModel
 *  @return NSIndexPath
 */
- (NSIndexPath *)cellIndexForCellModel:(HFTableViewCellModel *)cellModel;


#pragma mark -- reload 

/**
 *  该方法主要用户cellModel 中值的变化。并不是new 的cellModel
 *
 *  @return void
 */
-(void)reloadCellForCellModel:(HFTableViewCellModel *)cellModel withRowAnimation:(UITableViewRowAnimation)animation;

@end
