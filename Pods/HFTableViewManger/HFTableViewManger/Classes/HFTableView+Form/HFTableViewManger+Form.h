//
//  HFTableViewManger+Form.h
//  HFKitDemo
//
//  Created by helfy on 16/6/28.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFTableViewManger.h"
#import "HFTableViewCellFormModel.h"
@interface HFTableViewManger (Form)
@property (nonatomic,assign) BOOL scrollerToEndEdit;  //滑动完成编辑


/**
 *  获取所需的cellModel
 *
 *  @param indexPath indexPath
 *
 *  @return cellmodel
 */
- (HFTableViewCellModel *)cellModelForModelKey:(NSString *)modelKey;  //推荐使用key来获取。


/**
 *  打开键盘检测
 */
- (void)openKeyboardObserver;

/**
 *  关闭键盘检测
 */
- (void)closeKeyboardObserver;

/**
 *  滚动到某一行进进行编辑 ，主要用于非键盘的输入，如选择器，
        如果键盘输入。只需要在cell 中响应 isFirstResponder 即可
 *
 *  @param cellModel cellModel
 */
- (void)scrollerToCellEditForCellModel:(HFTableViewCellFormModel *)cellModel;

/**
 *  获取页面的表单数据
 *
 *  @param success 数据生成成功回调
 *  @param fail    有错误回调
 */
- (void)formDataWithSuccess:(void(^)(NSDictionary *formData))success fail:(void(^)(NSString *errorString))fail;
@end
