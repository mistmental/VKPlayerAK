//
//  MenuTabBarController.h
//  VKPlayerAK
//
//  Created by mistmental on 06.10.15.
//  Copyright © 2015 mistmental. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuTabBarController : UITabBarController <UITabBarDelegate, UITabBarControllerDelegate>




//@property (strong, nonatomic) UITabBarController* menuTabBarController;

@property (strong, nonatomic) UITabBarController* menuTabBarController;

@property (strong, nonatomic) UITabBar* menuTabBar;
@property (strong, nonatomic) NSMutableArray* menuTabBarItemsArray;
@property (strong, nonatomic) NSMutableArray* viewControllersArray;

@property (strong, nonatomic) IBOutlet UITabBarItem* loginTab;
@property (strong, nonatomic) IBOutlet UITabBarItem* webMusicTab;
@property (strong, nonatomic) IBOutlet UITabBarItem* cacheTab;

@property (strong, nonatomic) IBOutlet UITabBarItem* nilTab;


- (void) createMenuTabBar;


@end
