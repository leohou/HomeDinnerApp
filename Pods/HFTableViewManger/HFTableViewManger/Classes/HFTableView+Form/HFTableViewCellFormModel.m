//
//  HFTableViewCellFormModel.m
//  HFKitDemo
//
//  Created by helfy on 16/6/28.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFTableViewCellFormModel.h"

@implementation HFTableViewCellFormModel

- (NSString *)checkValid {
    NSString *errorStr = nil;
    if(self.isRequired) {
        if(self.cellFormValue == nil || self.cellFormValue.length<1) {
            if(self.customNullNote) {
                errorStr = self.customNullNote;
            }
            else {
                errorStr = [NSString stringWithFormat:@"%@不能为空",self.cellName];
            }
        }
        else {
            if(self.cellRegex) {
                NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.cellRegex];
                if(![regexPredicate evaluateWithObject:self.cellFormValue]) {
                    if(self.customFormatNote) {
                        errorStr = self.customFormatNote;
                    }
                    else {
                        errorStr = [NSString stringWithFormat:@"%@格式不正确",self.cellName];
                    }
                }
            }
        }
    }
    else {
        if(self.cellRegex && self.cellFormValue != nil && self.cellFormValue.length >0) {
            NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.cellRegex];
            if(![regexPredicate evaluateWithObject:self.cellFormValue]) {
                if(self.customFormatNote) {
                    errorStr = self.customFormatNote;
                }
                else {
                    errorStr = [NSString stringWithFormat:@"%@格式不正确",self.cellName];
                }
            }
        }
    }
    return errorStr;
}

@end
