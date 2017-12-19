//
//  HFTableViewCellFormModel.h
//  HFKitDemo
//
//  Created by helfy on 16/6/28.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFTableViewCellModel.h"

@interface HFTableViewCellFormModel : HFTableViewCellModel

@property (nonatomic, assign) BOOL isRequired;       //是否为必填项 YES:不能为空 默认NO，为空不提示
@property (nonatomic, strong) NSString *cellFormKey;   //提交时的key
@property (nonatomic, strong) NSString *cellFormValue; //提交时的value。这地方不同于cellData。cellData 的类型不定。主要是是cell展示数据
@property (nonatomic, strong) NSString *cellName;   // 名称。主要用于错误提示
@property (nonatomic, strong) NSString *cellRegex;  //判断cellFormValue的正则表达式，只要不为空，都会判断



@property (nonatomic, strong) NSString *customNullNote;  //自定义为空错误提示，
@property (nonatomic, strong) NSString *customFormatNote;  //自定义格式错误提示

/**
 *  检查有效性
 *
 *  @return 错误提示。返回nil表示有效
 */
- (NSString *)checkValid;


@end
