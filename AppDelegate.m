//
//  AppDelegate.m
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicViewController.h"
#import "LoginViewController.h"
#import "CacheViewController.h"


@interface AppDelegate () <UITabBarControllerDelegate, UITabBarDelegate, PresentMusicTableViewControllerDelegate>


@property (strong, nonatomic) NSMutableArray* vviewControllersArray;

@property (strong, nonatomic) LoginViewController* loginVC;
@property (strong, nonatomic) MusicViewController* musicVC;
@property (strong, nonatomic) CacheViewController* cacheVC;

@property (strong, nonatomic) UITabBarItem* loginItem;
@property (strong, nonatomic) UITabBarItem* cacheItem;
@property (strong, nonatomic) UITabBarItem* musicItem;


@property (strong, nonatomic) UITabBarController* tabBarController;

@property (strong, nonatomic) NSMutableArray* itemsArray;

@property (strong, nonatomic) UITabBar* tabBar;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.window.bounds.size.height - 100, self.window.bounds.size.width, 80)];
    
    self.loginVC = [[LoginViewController alloc] init];
    self.musicVC = [[MusicViewController alloc] init];
    self.cacheVC = [[CacheViewController alloc] init];
    
    
    //    musicVC.presentDelegate = self;
    self.loginVC.presentTableViewDelegate = self;
   
    
    UIImage* imageMuscivItemUnselected = [[UIImage imageNamed:@"vk_unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* imageMuscivItemSelected = [[UIImage imageNamed:@"vk_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* imageCacheItemUnselected = [[UIImage imageNamed:@"cache_unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* imageCacheItemSelected = [[UIImage imageNamed:@"cache_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* imageLoginItemUnselected = [[UIImage imageNamed:@"login_unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* imageLoginItemSelected = [[UIImage imageNamed:@"login_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    self.loginItem = [[UITabBarItem alloc] initWithTitle:@"LOGIN" image:imageLoginItemUnselected selectedImage:imageLoginItemSelected];
    self.loginItem.tag = 0;
    self.musicItem = [[UITabBarItem alloc] initWithTitle:@"WEB" image:imageMuscivItemUnselected selectedImage:imageMuscivItemSelected];
    self.musicItem.tag = 1;
    self.cacheItem = [[UITabBarItem alloc] initWithTitle:@"CACHE" image:imageCacheItemUnselected selectedImage:imageCacheItemSelected];
    self.cacheItem.tag = 2;
    

    
    
    self.itemsArray = [[NSMutableArray alloc] initWithObjects:self.loginItem,self.musicItem,self.cacheItem, nil];
    
    NSDictionary* params = @{
                             NSForegroundColorAttributeName : [UIColor grayColor],
                             NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:20.f],
                             };
    for (UITabBarItem* object in self.itemsArray) {
       
        [object setTitleTextAttributes:params forState:UIControlStateNormal];
    }
    [self.tabBar setItemPositioning:UITabBarItemPositioningFill];
    
    [self.tabBar setItems:self.itemsArray];
    
    [self.tabBar setBarTintColor:[UIColor blackColor]];
    

    
    
    self.tabBar.delegate = self;

    
    if (self.musicVC.musicViewNavigationController == nil) {
        self.musicVC.musicViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.musicVC];
        
    }
    if (self.cacheVC.cacheViewNavigationController == nil) {
        self.cacheVC.cacheViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.cacheVC];
    }
    
    
    self.vviewControllersArray = [[NSMutableArray alloc] initWithObjects:self.loginVC, self.musicVC.musicViewNavigationController, self.cacheVC.cacheViewNavigationController, nil];
    //
    
    
    
    
    NSLog(@"СЕЙЧАС БУДЕТ ПИЗДЕЦ");
    [self.tabBarController setViewControllers:self.vviewControllersArray];
    NSLog(@"ВОТ И ОН");
    NSLog(@"%@", self.vviewControllersArray);
   
    self.window.rootViewController = self.tabBarController;
    [self.tabBarController.view addSubview:self.tabBar];
     self.tabBar.selectedItem = self.loginItem;
    [self tabBar:self.tabBar didSelectItem:self.loginItem];


    return YES;
}
- (void) presentMusicTableViewController {
    
    if (self.musicVC.musicViewNavigationController == nil) {
        
        self.musicVC.musicViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.musicVC];
        
        [self.musicVC.musicViewNavigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
        [self.musicVC.musicViewNavigationController.navigationBar setBarStyle:UIBarStyleBlack];
        [self.musicVC.view addSubview:self.musicVC.musicViewNavigationController.navigationBar];
        
    }
    self.tabBar.selectedItem = self.musicItem;
    [self tabBar:self.tabBar didSelectItem:self.musicItem];

    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
       for (UITabBarItem* object in self.itemsArray) {
           NSDictionary* params = @{
                                    
                                    NSForegroundColorAttributeName : [UIColor grayColor],
                                    NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:20.f],
                                    };

        [object setTitleTextAttributes:params forState:UIControlStateNormal];
        
    }
    
    if (item == self.tabBar.selectedItem) {
        NSDictionary* selectedParams = @{
                                         NSForegroundColorAttributeName : [UIColor whiteColor],
                                         NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:23.f],
                                         };
        [self.tabBar.selectedItem setTitleTextAttributes:selectedParams forState:UIControlStateNormal];
        [self.tabBar setTintColor:[UIColor blackColor]];
        

    }
    switch (item.tag) {
            
        case 0:
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:item.tag];
            break;
        case 1:
             self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:item.tag];
            break;
        case 2:
            [self.cacheVC reloadDocumentsDirectoryAndCacheTableView];
            [self.cacheVC.cacheTableView reloadData];
             self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:item.tag];
            
            break;
            
        default:
            break;
    }


}
- (void) viewWillLayoutSubviews
{
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 100;
    tabFrame.origin.y = self.window.frame.size.height - 100;
    self.tabBar.frame = tabFrame;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self viewWillLayoutSubviews];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "AK.VKPlayerAK" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"VKPlayerAK" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"VKPlayerAK.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
