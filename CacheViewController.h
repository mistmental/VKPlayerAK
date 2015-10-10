//
//  CacheViewController.h
//  VKPlayerAK
//
//  Created by mistmental on 06.10.15.
//  Copyright © 2015 mistmental. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CacheViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* cacheTableView;

@property (strong, nonatomic) UINavigationController* cacheViewNavigationController;

@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;
@property (strong, nonatomic) UITableView* searchTableView;


- (void) reloadDocumentsDirectoryAndCacheTableView;

@end
