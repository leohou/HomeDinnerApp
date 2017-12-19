//
//  HLHomeTabBarController.m
//  HomeDinner
//
//  Created by houli on 2017/11/28.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HLHomeTabBarController.h"
#define kWP_TABBAR_TITLE_PADDING (-3)

@interface HLHomeTabBarController ()
@property(nonatomic,strong) HLHomeViewController *homeViewController;
@property(nonatomic,strong) HLMyMainViewController *myMainController;

@property (nonatomic, strong) UITabBarItem *homeTabBarItem;
@property (nonatomic, strong) UITabBarItem *myMainTabBarItem;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HLHomeTabBarController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [self _setGuidePage];
    //设置统一的导航栏样式
//    UIImage *backgroundImage = [UIImage imageWithColor:[[WPAppSkin mainSkin] navigationBarCustomColor]];
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
//    
//    [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[[WPAppSkin mainSkin] seprateLineColor]]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [[WPAppSkin mainSkin] contentColorWhite]}];
//    [[UISegmentedControl appearance] setTintColor:[[WPAppSkin mainSkin] contentColorWhite]];
//    [self.tabBar setShadowImage:[UIImage imageWithColor:[WPAppSkin mainSkin].seprateLineColor1]];
//    UIImage *backgroundImage1 = [UIImage imageWithColor:[[WPAppSkin mainSkin] contentColorWhite]];
//    [self.tabBar setBackgroundImage:backgroundImage1];
//    
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [[WPAppSkin mainSkin] seprateLineColor1];;
//    view.frame = CGRectMake(0, -0.5, self.tabBar.frame.size.width, 0.2);
//    view.layer.shadowColor = [[WPAppSkin mainSkin] contentColorBlack].CGColor;
//    view.layer.shadowOpacity = 0.5f;
//    
//    
//    [[UITabBar appearance]insertSubview:view atIndex:0];
//    
    
    self.homeViewController = [[HLHomeViewController alloc] init];
    HLBaseNavigationController *hlHomeNavigationController = [[HLBaseNavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    [hlHomeNavigationController setViewControllers:@[self.homeViewController]];
    hlHomeNavigationController.tabBarItem = self.homeTabBarItem;
    
    self.myMainController = [[HLMyMainViewController alloc] init];
    HLBaseNavigationController *hlMyMainNavigationController = [[HLBaseNavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    [hlMyMainNavigationController setViewControllers:@[self.myMainController]];
    hlMyMainNavigationController.tabBarItem = self.myMainTabBarItem;
    
    
    [self setViewControllers:@[hlHomeNavigationController,
                               hlMyMainNavigationController,
                               ]];
}

//- (void)_setGuidePage{
//
//    [AFOnce runOnce:^(AFOnceBlockInfo *blockInfo) {
//
//        WSGuidePageView *guide =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WSGuidePageView class]) owner:self options:nil] firstObject];
//
//        guide.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//
//        [self.view addSubview:guide];
//
//
//    } elseRun:^(AFOnceBlockInfo *blockInfo) {
//
//
//    } forKey:kFirstAddressHasTurnOut];
//    //
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - setting
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - UITabBarControllerDelegate methods
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item == self.homeTabBarItem) {//  首页
        
    }else if (item == self.myMainTabBarItem){
        
        
    }
}

#pragma mark - property getter

- (UITabBarItem *)homeTabBarItem
{
    if (!_homeTabBarItem) {
        _homeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                          image:[[UIImage imageNamed:@"shouyeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"shouyeIcon_ac"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _homeTabBarItem.titlePositionAdjustment = UIOffsetMake(0, kWP_TABBAR_TITLE_PADDING);
    }
    return _homeTabBarItem;
}
- (UITabBarItem *)myMainTabBarItem
{
    if (!_myMainTabBarItem) {
        _myMainTabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                        image:[[UIImage imageNamed:@"myMainIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                selectedImage:[[UIImage imageNamed:@"myMainIcon_ac"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _myMainTabBarItem.titlePositionAdjustment = UIOffsetMake(0, kWP_TABBAR_TITLE_PADDING);
        
    }
    return _myMainTabBarItem;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prompt"]];
        
    }
    return _imageView;
}
@end
