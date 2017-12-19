//
//  HLBaseNavigationVController.m
//  HomeDinner
//
//  Created by houli on 2017/11/28.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HLBaseNavigationController.h"

@interface HLBaseNavigationController ()

@end

@implementation HLBaseNavigationController
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSDictionary * dict=[NSDictionary dictionaryWithObject:[[WPAppSkin mainSkin] contentColorGray1] forKey:NSForegroundColorAttributeName];
//    self.navigationBar.titleTextAttributes = dict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setting
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // You do not need this method if you are not supporting earlier iOS Versions
    
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}


@end
