//
//  HFTableSectionObj.h
//  HFKitDemo
//
//  Created by helfy  on 15/9/6.
//  Copyright (c) 2015年 helfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HFTableViewCellModel.h"
@interface HFTableViewSectionModel : NSObject

+ (instancetype)sectionModelWithCellModels:(NSMutableArray *)cellModels;

@property (nonatomic,strong) NSMutableArray *cellModels;  //section 下的cellModels
@property (nonatomic,copy) NSString *sectionKey;   //对section 的标识。用户获取section。如果不设置，不能通过key 获取或者reload该section
//header
@property (nonatomic,copy) NSString *headTitle;    //默认nil
@property (nonatomic,assign) CGFloat headHeigth;   // 默认40
@property (nonatomic,strong) UIView * headView;     //默认nil   设置后 headTitle 失效 ， 高度会直接使用view的高度

//footer
@property (nonatomic,copy) NSString *footerTitle;    //默认nil
@property (nonatomic,assign) CGFloat footerHeigth;   //默认0.000001f
@property (nonatomic,strong) UIView * footerView;     //默认nil  设置后 footerTitle 失效， 高度会直接使用view的高度

- (void)addCellModel:(HFTableViewCellModel *)model;
@end
