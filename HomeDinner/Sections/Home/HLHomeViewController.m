//
//  HLHomeViewController.m
//  HomeDinner
//
//  Created by houli on 2017/11/28.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HLHomeViewController.h"
#define kHEIGHT 100
#define IMAGEHEIGHT     200.0f
#define MAINSCREENWIDTH     320
@interface HLHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableview;
@property (nonatomic, strong) UIImageView * headerView;
@property(nonatomic,strong)NSArray *moreArray;
@property(nonatomic,strong)UIImageView *zoomImageView;
@end

@implementation HLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareTableview];
    self.view.backgroundColor = [UIColor cyanColor];
}

-(void)prepareTableview{
    
    UITableView *moreTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    moreTableView.delegate = self;
    moreTableView.dataSource = self;
    moreTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:<#(nonnull NSString *)#>
    [self.view addSubview:moreTableView];
    
    
    moreTableView.contentInset = UIEdgeInsetsMake(IMAGEHEIGHT, 0, 0, 0);
    
    _zoomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 20)];
    _zoomImageView.image = [UIImage imageNamed:@"IMG_0767"];
    _zoomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [moreTableView addSubview:_zoomImageView];
    
    if (!_moreArray) {
        _moreArray = [[NSArray alloc]initWithObjects:@"语言",@"体育",@"文艺",@"升学",@"职业",@"生活",@"爱好",@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    }
}

#pragma mark -TableView Delegate and Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _moreArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell ;
    //static NSString *Identifier = @"Identifier";
    cell =[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = _moreArray[indexPath.row];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y + 64; //如果有导航控制器，这里应该加上导航控制器的高度64
    if (y< -IMAGEHEIGHT) {
        CGRect frame = _zoomImageView.frame;
        frame.origin.y = y;
        frame.size.height = -y;
        _zoomImageView.frame = frame;
    }
    
}
@end
