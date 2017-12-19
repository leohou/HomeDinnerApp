//
//  AppDelegate.h
//  HomeDinner
//
//  Created by houli on 2017/11/28.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HLHomeTabBarController *tabBarController;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

