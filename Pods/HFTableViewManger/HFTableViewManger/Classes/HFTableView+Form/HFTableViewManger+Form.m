//
//  HFTableViewManger+Form.m
//  HFKitDemo
//
//  Created by helfy on 16/6/28.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFTableViewManger+Form.h"
#import "HFTableViewCellFormModel.h"
#import <objc/runtime.h>
@implementation HFTableViewManger(Form)

static char scrollerToEndEditString;
#pragma getter & setter
- (void)setScrollerToEndEdit:(BOOL)scrollerToEndEdit {
    [self willChangeValueForKey:@"scrollerToEndEditString"];
    objc_setAssociatedObject(self, &scrollerToEndEditString,
                             @(scrollerToEndEdit),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"scrollerToEndEditString"];
}

- (BOOL)scrollerToEndEdit {
    return  [objc_getAssociatedObject(self, &scrollerToEndEditString) boolValue];
}

- (HFTableViewCellModel *)cellModelForModelKey:(NSString *)modelKey {
    HFTableViewCellModel *cellModel = nil;
    if(self.isMutableSection) {
        for (HFTableViewSectionModel *sectionModel in self.dataSourceModels) {
            
            for (HFTableViewCellModel *subModel  in sectionModel.cellModels) {
                
                if([subModel isKindOfClass:[HFTableViewCellFormModel class]]) {
                    if([((HFTableViewCellFormModel *)subModel).cellFormKey isEqualToString:modelKey]) {
                        return subModel;
                    }
                }
            }
        }
    }
    else {
        for (HFTableViewCellModel *subModel  in self.dataSourceModels) {

            if([subModel isKindOfClass:[HFTableViewCellFormModel class]]) {
                if([((HFTableViewCellFormModel *)subModel).cellFormKey isEqualToString:modelKey])
                {
                    return subModel;
                }
            }
        }
    }
    return cellModel;
}

- (void)formDataWithSuccess:(void(^)(NSDictionary *formData))success fail:(void(^)(NSString *errorString))fail
{
    [self.tableView endEditing:YES];
    NSMutableDictionary *formData = [NSMutableDictionary dictionary];
    if(self.isMutableSection) {
        for (HFTableViewSectionModel *sectionModel in self.dataSourceModels) {
            for (HFTableViewCellFormModel *formModel in sectionModel.cellModels) {
                if([formModel isKindOfClass:[HFTableViewCellFormModel class]]) {
                   NSString *errorString = [formModel checkValid];
                    if(errorString) {
                        !fail?:fail(errorString);
                        return;
                    }
                    if(formModel.cellFormValue && formModel.cellFormKey) {
                     [formData setValue:formModel.cellFormValue forKey:formModel.cellFormKey];
                    }
                }
            }
        }
    }
    else{
        for (HFTableViewCellFormModel *formModel in self.dataSourceModels) {
            if([formModel isKindOfClass:[HFTableViewCellFormModel class]]) {
                NSString *errorString = [formModel checkValid];
                if(errorString) {
                    !fail?:fail(errorString);
                    return;
                }
                if(formModel.cellFormValue && formModel.cellFormKey) {
                    [formData setValue:formModel.cellFormValue forKey:formModel.cellFormKey];
                }
            }
        }
    }
    !success?:success(formData);
}

#pragma mark 滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.scrollerToEndEdit) {
        [self.tableView endEditing:YES];
    }
    if([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollerToCellEditForCellModel:(HFTableViewCellFormModel *)cellModel {
    [self.tableView endEditing:YES];
    [self.tableView scrollToRowAtIndexPath:[self cellIndexForCellModel:cellModel] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
#pragma mark -- 事件监听
- (void)openKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)closeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- 键盘弹出 & 收起
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float height = rect.size.height;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, height, self.tableView.contentInset.right)];
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
  
    NSArray *visibleCells = [self.tableView visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        if([cell isFirstResponder]) {
            float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:duration];
            [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            [UIView commitAnimations];
            return;
        }
    }

 
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, 0, self.tableView.contentInset.right)];
}

@end
