//
//  HFTableViewManger.m
//  HFKitDemo
//
//  Created by helfy on 16/6/24.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFTableViewManger.h"
#import <UIKit/UIKit.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import <objc/message.h>
@implementation HFTableView
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    if([dataSource isKindOfClass:[HFTableViewManger class]]) {
        [super setDataSource:dataSource];
    }
}
- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    if([delegate isKindOfClass:[HFTableViewManger class]]) {
        [super setDelegate:delegate];
    }
}
@end

@implementation HFTableViewManger {
    dispatch_semaphore_t _lock;
    dispatch_queue_t _queue;
    NSFileManager *_fileManger;
    NSBundle *_bundle;
}

+ (instancetype)mangerForTableViewStyle:(UITableViewStyle)style {
    HFTableViewManger *tableViewManger = [[HFTableViewManger alloc] init];
    [tableViewManger setupViewWithStyle:style];
    return tableViewManger;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _lock = dispatch_semaphore_create(1);
        _queue = dispatch_queue_create("HFTableViewManger", NULL);
        _fileManger = [NSFileManager defaultManager];
        _bundle = [NSBundle mainBundle];
       
        [self setupData];
//        id (*typed_msgSend)(id, SEL) = (void *)objc_msgSend;
//        typed_msgSend(self, sel_registerName("setupData"));;
    }
    return self;
}
- (void)setupData {
    _dataSourceModels = [NSMutableArray array];
}

- (void)setupViewWithStyle:(UITableViewStyle)style {
    _tableView = [[HFTableView alloc] initWithFrame:CGRectZero style:style];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
#pragma mark getter & setter
//必须要设置一下，tableView应该是一开始在respondsToSelector 做了缓存。如果不设置，自身的转发机制将不能被触发
- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    _delegate = delegate;
    self.tableView.delegate = self;
}
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    _dataSource = dataSource;
    self.tableView.dataSource = self;
}
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
}
#pragma mark regist Cell
//设置完成之后需要对Cell的Model提取设置一些东西
- (void) registerCellClassForcellModels {
    
    if (self.isMutableSection) {
        for (HFTableViewSectionModel *sectionModel in self.dataSourceModels) {
            for (HFTableViewCellModel *cellModel in sectionModel.cellModels) {
                [self registercellModel:cellModel];
            }
        }
    }
    else{
        for (HFTableViewCellModel *cellModel in self.dataSourceModels) {
            [self registercellModel:cellModel];
        }
    }
}

- (void)registercellModel:(HFTableViewCellModel *)cellModel {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if(cellModel.cellNib) {
        [self.tableView registerNib:cellModel.cellNib forCellReuseIdentifier:cellModel.cellIdentifier];
    }
    else {
        NSString *path = [_bundle pathForResource:cellModel.tablViewCellClassName ofType:@"nib"];
        if([_fileManger fileExistsAtPath:path]) {
            UINib *nib = [UINib nibWithNibName:cellModel.tablViewCellClassName bundle:nil];
            [self.tableView registerNib:nib forCellReuseIdentifier:cellModel.cellIdentifier];
        }
        else {
            [self.tableView registerClass:NSClassFromString(cellModel.tablViewCellClassName) forCellReuseIdentifier:cellModel.cellIdentifier];
        }
    }
    dispatch_semaphore_signal(_lock);
}
- (void)registerForClassName:(NSString *)className {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSString *path = [_bundle pathForResource:className ofType:@"nib"];
    if([_fileManger fileExistsAtPath:path]) {
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:className];
    }
    else {
        [self.tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
    dispatch_semaphore_signal(_lock);
}
#pragma
/**
 *  把数据转化成符合格式的cellModel。
 *  如果数据中对应多种cell 样式，需按需求设置对应的cellClassName 再使用setCellModelsForObjs: isAddmore:
 *  @param dataSource  数据原型
 *  @param className  cell 的className
 *  @param addMore    yes 数据直接添加到已有数据之后。NO 覆盖
 */
- (void)setupDataSourceModelsForData:(NSArray *)dataSource cellClassName:(NSString *)className  isAddmore:(BOOL)addMore {
    
    dispatch_async(_queue, ^{
        NSMutableArray *cellModels = [NSMutableArray array];
        //注册cell
        [self registerForClassName:className];
        //先判断 dataSource 的obj 是否是NSArray 如果 是array认为是section模式
        _isMutableSection = NO;
        if(dataSource.count >0) {
            if([[[dataSource firstObject] class] isSubclassOfClass:[NSArray class]]) {
                _isMutableSection = YES;
            }
        }
        if(_isMutableSection == NO) {
            for (id subModel in dataSource) {
                HFTableViewCellModel *cellModel = [HFTableViewCellModel cellModelForCellClassName:className cellData:subModel];
                [cellModels addObject:cellModel];
            }
        }
        else {
            for (NSArray *sectionArray in dataSource) {
                HFTableViewSectionModel *sectionModel = [[HFTableViewSectionModel alloc] init];
                NSMutableArray *subcellModels = [NSMutableArray array];
                for (id subModel in sectionArray) {
                    HFTableViewCellModel*cellModel = [HFTableViewCellModel cellModelForCellClassName:className cellData:subModel];
                    [subcellModels addObject:cellModel];
                }
                sectionModel.cellModels = subcellModels;
                [cellModels addObject:sectionModel];
            }
        }
        if(addMore) {
            [self.dataSourceModels addObjectsFromArray:cellModels];
        }
        else {
            _dataSourceModels = cellModels;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}

/**
 *  自己转换成cellModel后进行设置
 *
 *  @param cellModel cellModel
 *  @param addMore yes 数据直接添加到已有数据之后。NO 覆盖
 */
- (void)setupDataSourceModels:(NSArray *)dataModels  isAddmore:(BOOL)addMore {
 
    dispatch_async(_queue, ^{
        if(addMore) {
            [self.dataSourceModels addObjectsFromArray:dataModels];
        }
        else {
            _dataSourceModels = [dataModels mutableCopy];
        }
        _isMutableSection = NO;
        if(self.dataSourceModels.count >0) {
            if([[self.dataSourceModels firstObject] isKindOfClass:[HFTableViewSectionModel class]]) {
                _isMutableSection = YES;
            }
        }
        [self  registerCellClassForcellModels];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

}

#pragma mark -- reload  待测
- (void)reloadSectionForSectionIndex:(NSUInteger )sectionIndex withRowAnimation:(UITableViewRowAnimation)animation {
    if(self.isMutableSection && sectionIndex < self.dataSourceModels.count) {
        HFTableViewSectionModel *sectionModel = self.dataSourceModels[sectionIndex];
        for (HFTableViewCellModel *cellModel in sectionModel.cellModels) {
            [self registercellModel:cellModel];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
    }
}
- (void)reloadSectionForSectionKey:(NSString *)sectionKey withRowAnimation:(UITableViewRowAnimation)animation
{
    if(self.isMutableSection && sectionKey.length > 0) {
        HFTableViewSectionModel *sectionModel = [self sectionModelForKey:sectionKey];
        for (HFTableViewCellModel *cellModel in sectionModel.cellModels) {
            [self registercellModel:cellModel];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.dataSourceModels indexOfObject:sectionModel]] withRowAnimation:animation];
    }
}

- (void)replaceSection:(HFTableViewSectionModel *)sectionModel sectionIndex:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)animation
{
    if(self.isMutableSection && sectionIndex < self.dataSourceModels.count) {
        HFTableViewSectionModel *oldsectionModel = self.dataSourceModels[sectionIndex];
        if(oldsectionModel) {
            NSInteger sectionIndex = [self.dataSourceModels indexOfObject:oldsectionModel];
            [self.dataSourceModels replaceObjectAtIndex:sectionIndex withObject:sectionModel];
            [self reloadSectionForSectionIndex:sectionIndex withRowAnimation:animation];
        }
    }
}
- (void)replaceSection:(HFTableViewSectionModel *)sectionModel sectionKey:(NSString *)sectionKey withRowAnimation:(UITableViewRowAnimation)animation
{
    if(self.isMutableSection && sectionKey.length > 0) {
        HFTableViewSectionModel *oldsectionModel = [self sectionModelForKey:sectionKey];
        if(oldsectionModel) {
            NSInteger sectionIndex = [self.dataSourceModels indexOfObject:oldsectionModel];
            [self.dataSourceModels replaceObjectAtIndex:sectionIndex withObject:sectionModel];
            [self reloadSectionForSectionIndex:sectionIndex withRowAnimation:animation];
        }
    }
}


- (void)replaceCellModel:(HFTableViewCellModel *)cellModel cellIndex:(NSIndexPath *)indexpath withRowAnimation:(UITableViewRowAnimation)animation
{
    if(cellModel && indexpath && indexpath.section < self.dataSourceModels.count) {
        HFTableViewSectionModel *section = self.dataSourceModels[indexpath.section];
        [section.cellModels replaceObjectAtIndex:indexpath.row withObject:cellModel];
        [self registercellModel:cellModel];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:animation];
    }
}


- (void)deleteCellForIndex:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    
    if (self.isMutableSection) {
        [((HFTableViewSectionModel *)self.dataSourceModels[indexPath.section]).cellModels removeObjectAtIndex:indexPath.row];
    }
    else {
        [self.dataSourceModels removeObjectAtIndex:indexPath.row];
    }
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)deleteCellForCellModel:(HFTableViewCellModel *)cellModel withRowAnimation:(UITableViewRowAnimation)animation
{
    NSUInteger sectionIndex = 0;
    NSUInteger rowIndex = 0;
    if (self.isMutableSection) {
        for (HFTableViewSectionModel *sectionModel in self.dataSourceModels) {
            if([sectionModel.cellModels containsObject:cellModel]) {
                rowIndex = [sectionModel.cellModels indexOfObject:cellModel];
                break;
            }
            sectionIndex ++;
        }
    }
    else {
        rowIndex = [self.dataSourceModels indexOfObject:cellModel];
    }
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    [self deleteCellForIndex:indexpath withRowAnimation:animation];
}


//该方法主要用户cellModel 中值的变化。并不是new 的cellModel
- (void)reloadCellForCellModel:(HFTableViewCellModel *)cellModel withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *indexPath = [self cellIndexForCellModel:cellModel];
    if(indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
    }
}


#pragma mark UITableViwDelegate & UITableViwDataSourece

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self. isMutableSection) {
        HFTableViewSectionModel *sectionModel = self.dataSourceModels[section];
        if(sectionModel.headView) {
            return CGRectGetHeight(sectionModel.headView.frame);
        }
        return sectionModel.headHeigth;
    }
    
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (self. isMutableSection) {
        HFTableViewSectionModel *sectionModel = self.dataSourceModels[section];
        
        if(sectionModel.footerView) {
            return CGRectGetHeight(sectionModel.footerView.frame);
        }
        return sectionModel.footerHeigth;
    }
    
    return 0.000001f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self. isMutableSection) {
        HFTableViewSectionModel *sectionModel = self.dataSourceModels[section];
        return sectionModel.headTitle;
    }
    
    return nil;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self. isMutableSection) {
        HFTableViewSectionModel *sectionModel = self.dataSourceModels[section];
        return sectionModel.footerTitle;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self. isMutableSection) {
        HFTableViewSectionModel *sectionModel = self.dataSourceModels[section];
        return sectionModel.headView;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self. isMutableSection) {
        HFTableViewSectionModel *sectionModel = self.dataSourceModels[section];
        return sectionModel.footerView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self. isMutableSection) {
        return self.dataSourceModels.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self. isMutableSection) {
        HFTableViewSectionModel *sectionModel = self.dataSourceModels[section];
        return [sectionModel.cellModels count];
    }
    else {
        return self.dataSourceModels.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HFTableViewCellModel *cellModel = [self cellModelForIndexPath:indexPath];
    if([[cellModel class] isSubclassOfClass:[HFTableViewCellModel class]]) {
        if(cellModel.cellHeigth  > 0) {
            return cellModel.cellHeigth;
        }
        else {
           CGFloat cellHigth = [tableView fd_heightForCellWithIdentifier:cellModel.cellIdentifier
                                     cacheByIndexPath:indexPath
                                        configuration:^(id cell) {
                                            if([cell respondsToSelector:@selector(bindData:)]) {
                                                [cell bindData:cellModel];
                                            }
                                        }];
            return cellHigth > 1? cellHigth : 40;
        }
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HFTableViewCellModel *cellModel = [self cellModelForIndexPath:indexPath];
    HFTableViewCell *cell = [sender dequeueReusableCellWithIdentifier:cellModel.cellIdentifier forIndexPath:indexPath];
    if([cell respondsToSelector:@selector(bindData:)]) {
        [cell bindData:cellModel];
    }
    !cellModel.configCellBlock?:cellModel.configCellBlock(cell,cellModel);
   return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    HFTableViewCellModel *cellModel = [self cellModelForIndexPath:indexPath];
    if(cellModel.cellAction) {
        if([self.delegate respondsToSelector:cellModel.cellAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:cellModel.cellAction withObject:cellModel];
#pragma clang diagnostic pop
        }
        return;
    }
    else if(cellModel.cellDidSelectBlock) {
        cellModel.cellDidSelectBlock([sender cellForRowAtIndexPath:indexPath],cellModel);
          return;
    }
//未单独设置的，由delegate 自行处理
    if([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:sender didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark 数据提取

- (HFTableViewCellModel *)cellModelForIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    HFTableViewCellModel *cellModel = nil;
    if (self.isMutableSection) {
        cellModel = ((HFTableViewSectionModel *)self.dataSourceModels[indexPath.section]).cellModels[indexPath.row];
    }
    else {
        cellModel = self.dataSourceModels[indexPath.row];
    }
    dispatch_semaphore_signal(_lock);

    return cellModel;
}

- (HFTableViewSectionModel *)sectionModelForKey:(NSString *)sectionKey {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    HFTableViewSectionModel *findSectionModel = nil;
    if(self.isMutableSection && sectionKey.length > 0) {
        for (HFTableViewSectionModel *sectionModel in self.dataSourceModels) {
            if([sectionModel.sectionKey isEqualToString:sectionKey]) {
                findSectionModel = sectionModel;
                break;
            }
        }
    }
    dispatch_semaphore_signal(_lock);

    return findSectionModel;
}

- (NSInteger)sectionIndexForModelKey:(NSString *)sectionKey {
    
    HFTableViewSectionModel *sectionModel = [self sectionModelForKey:sectionKey];
    if(sectionModel) {
        return [self.dataSourceModels indexOfObject:sectionModel];
    }
    return NSNotFound;
}

- (NSIndexPath *)cellIndexForCellModel:(HFTableViewCellModel *)cellModel {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSIndexPath *indexpath = nil;
    int sectionIndex = 0;
    int rowIndex = 0;
    if(self.isMutableSection) {
        for (HFTableViewSectionModel *sectionModel in self.dataSourceModels) {
            rowIndex = 0;
            for (HFTableViewCellModel *subModel  in sectionModel.cellModels) {
                if([subModel isEqual:cellModel]) {
                    indexpath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                }
                rowIndex ++;
            }
            sectionIndex ++;
        }
    }
    else
    {
        for (HFTableViewCellModel *subModel  in self.dataSourceModels) {
            if([subModel isEqual:cellModel]) {
                indexpath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
            rowIndex++;
        }
    }
    dispatch_semaphore_signal(_lock);
    return indexpath;
}

#pragma delegate & dataSource  转发
- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    if(!responds) {
        return ([self.delegate respondsToSelector:aSelector] || [self.dataSource respondsToSelector:aSelector]);
    }
    return responds;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
   else if ([self.dataSource respondsToSelector:aSelector]) {
        return self.dataSource;
    }
    return [super forwardingTargetForSelector:aSelector];
}

//- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
//{
//    if ([self.delegate respondsToSelector:selector]) {
//        NSMethodSignature *signature = [(id)self.delegate methodSignatureForSelector:selector];
//        return signature;
//    }
//    
//    if ([self.dataSource respondsToSelector:selector]) {
//        NSMethodSignature *signature = [(id)self.dataSource methodSignatureForSelector:selector];
//        return signature;
//    }
//    return [super methodSignatureForSelector:selector];
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    if ([self.delegate respondsToSelector:[anInvocation selector]]) {
//        return [anInvocation invokeWithTarget:self.delegate];
//    }
//    if ([self.dataSource respondsToSelector:[anInvocation selector]]) {
//        return [anInvocation invokeWithTarget:self.dataSource];
//    }
//    return [super forwardInvocation:anInvocation];
//}



@end
