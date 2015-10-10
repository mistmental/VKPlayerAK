//
//  MenuTabBarController.m
//  VKPlayerAK
//
//  Created by mistmental on 06.10.15.
//  Copyright © 2015 mistmental. All rights reserved.
//

#import "MenuTabBarController.h"
#import "LoginViewController.h"
#import "MusicViewController.h"
#import "CacheViewController.h"



@interface MenuTabBarController ()



@property (strong, nonatomic) LoginViewController* loginVC;
@property (strong, nonatomic) MusicViewController* musicVC;
@property (strong, nonatomic) CacheViewController* cacheVC;

@end

@implementation MenuTabBarController 
@synthesize tabBar;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self createMenuTabBar];
    
}

- (void) createMenuTabBar
{
    
//    self.menuTabBar = [[UITabBar alloc] init];
//    [self.menuTabBar setTintColor:[UIColor whiteColor]];
//    self.menuTabBar.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 100);
//    [self.menuTabBar setBarStyle:UIBarStyleBlack];
//    
//    
//    [self.menuTabBar setContentMode:UIViewContentModeBottom];
//    NSDictionary* titleParams = @{NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:20]};
//    self.nilTab = [[UITabBarItem alloc] initWithTitle:@"" image:nil selectedImage:nil];
//    self.nilTab.enabled = NO;
//    
//    self.loginTab = [[UITabBarItem alloc] initWithTitle:@"LOGIN" image:nil tag:0];
//    [self.loginTab setTitleTextAttributes:titleParams forState:UIControlStateNormal];
//    
//    self.webMusicTab = [[UITabBarItem alloc] initWithTitle:@"WEB" image:nil tag:1];
//    [self.webMusicTab setTitleTextAttributes:titleParams forState:UIControlStateNormal];
//    
//    self.cacheTab = [[UITabBarItem alloc] initWithTitle:@"CACHE" image:nil tag:2];
//    [self.cacheTab setTitleTextAttributes:titleParams forState:UIControlStateNormal];
//
//   
//    
//    self.menuTabBarItemsArray = [NSMutableArray arrayWithObjects:self.loginTab,self.nilTab, self.webMusicTab, self.nilTab, self.cacheTab, nil];
//    
//    [self.menuTabBar setItems:self.menuTabBarItemsArray animated:YES];
//    
//    self.menuTabBar.delegate = self;
//  
//    
//    [self.view addSubview:self.menuTabBar];
    
    
    
    
    
    
    
    self.menuTabBarController = [[UITabBarController alloc] init];

   [self.menuTabBarController.tabBar setBarStyle:UIBarStyleBlack];
        NSDictionary* titleParams = @{NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:20]};
        self.nilTab = [[UITabBarItem alloc] initWithTitle:@"" image:nil selectedImage:nil];
        self.nilTab.enabled = NO;
    
    
        self.loginTab = [[UITabBarItem alloc] initWithTitle:@"LOGIN" image:nil tag:0];
        [self.loginTab setTitleTextAttributes:titleParams forState:UIControlStateNormal];
    
        self.webMusicTab = [[UITabBarItem alloc] initWithTitle:@"WEB" image:nil tag:1];
        [self.webMusicTab setTitleTextAttributes:titleParams forState:UIControlStateNormal];
    
        self.cacheTab = [[UITabBarItem alloc] initWithTitle:@"CACHE" image:nil tag:2];
        [self.cacheTab setTitleTextAttributes:titleParams forState:UIControlStateNormal];
    
    
    
        self.menuTabBarItemsArray = [NSMutableArray arrayWithObjects:self.loginTab,self.nilTab, self.webMusicTab, self.nilTab, self.cacheTab, nil];
    
       [tabBar setItems:self.menuTabBarItemsArray animated:YES];
        
        tabBar.delegate = self;
    
    
    
    
    self.loginVC = [[LoginViewController alloc] init];
    self.loginVC.title = @"one";
   UINavigationController* NCloginVC = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    self.musicVC = [[MusicViewController alloc] init];
    self.musicVC.title = @"two";
   UINavigationController* NCmusicVC = [[UINavigationController alloc] initWithRootViewController:self.musicVC];
    self.cacheVC = [[CacheViewController alloc] init];
    self.cacheVC.title = @"three";
   UINavigationController* NCcacheVC = [[UINavigationController alloc] initWithRootViewController:self.cacheVC];
    
   self.viewControllersArray = [[NSMutableArray alloc] initWithObjects:NCloginVC, NCmusicVC, NCcacheVC, nil];
   
    self.menuTabBarController.viewControllers = self.viewControllersArray;
   
   [tabBar setSelectedItem:self.loginTab];
   
     self.menuTabBarController.delegate = self;
    [self.view addSubview:self.menuTabBarController.view];
  }
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    
    
    NSLog(@"%@", item.title);
    switch (item.tag) {
        case 0:
            [self.menuTabBarController setCustomizableViewControllers:[self.viewControllersArray objectAtIndex:0]]      ;
//            [self presentViewController:[self.viewControllersArray objectAtIndex:item.tag] animated:YES completion:^{
//                NSLog(@"done");
//            }];
            break;
            
        case 1:
//
            break;
            
        case 2:
            
            break;
        default:
            break;
    }
    
    
}


- (void) viewWillLayoutSubviews

{
    CGRect tabFrame = self.menuTabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 100;
    tabFrame.origin.y = self.view.frame.size.height - 100;
    self.menuTabBar.frame = tabFrame;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    NSLog(@"OOO");
    
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"OOO");
}

@end
