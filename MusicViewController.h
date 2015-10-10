//
//  MusicViewController.h
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentMusicPlayViewControllerDelegate;


@interface MusicViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UINavigationController* musicViewNavigationController;
@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;

@property (strong, nonatomic) NSMutableArray* musicArray;

@property (strong, nonatomic) UITableView* wTableView;
@property (strong, nonatomic) UITableView* searchTableView;



@property (assign, nonatomic) int currectIndexPath;


@property (weak, nonatomic) id <PresentMusicPlayViewControllerDelegate> presentDelegate;



- (void) getListOfMusic;
- (void) getSearchListOfMusic;


@end

@protocol PresentMusicPlayViewControllerDelegate <NSObject>

- (void) presentMusicPlayViewController;



@end
