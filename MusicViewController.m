//
//  MusicViewController.m
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import "MusicViewController.h"
#import "ServerManager.h"
#import "UserProperty.h"
#import "MusicPlayerOptions.h"
#import "MusicPlayerViewController.h"
#import "CacheViewController.h"

#define searchTableViewMode 1
#define myMusicTableVIeMode 0

@protocol MusicPlayerViewControllerDelegate;

@interface MusicViewController () <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate, MusicPlayerViewControllerDelegate, UISearchBarDelegate, UITabBarControllerDelegate>





@property (assign, nonatomic) int tableViewMode;

@property (strong, nonatomic) AVAudioPlayer* audioPlayer;
@property (strong, nonatomic) NSData* musicData;

@property (strong, nonatomic) MusicPlayerViewController* VC;





@end

@implementation MusicViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.musicArray = [[NSMutableArray alloc] init];
    
    
    
    [self createMusicTableView];
    
    [self createSearcheBarOfTableView];
    
    [self getListOfMusic];
    
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

}

- (void) createMusicTableView {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if (self.wTableView == nil) {
        self.wTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - self.view.bounds.size.height/21 - 120)];
        
        [self.view addSubview:self.wTableView];
        
    }
    
        self.wTableView.dataSource = self;
          self.wTableView.delegate = self;
    
    self.tableViewMode = myMusicTableVIeMode;

}
- (void) getListOfMusic {
    
    [[ServerManager sharedManager] getMusicWithCount:100
                                           withOffset:[self.musicArray count]
                                             ifSucces:^(NSArray *music) {
                                                 [self.musicArray addObjectsFromArray:music];
                                                 [self.wTableView reloadData];

           
                                             } andIfFailure:^(NSError *error) {
                                                 NSLog(@"Error = %@", error.localizedDescription);
                                             }];
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return [self.musicArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString* identifire = @"identifire";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
       
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    
   
        if (indexPath.row == [self.musicArray count]) {
            cell.textLabel.text = [NSString stringWithFormat:@"..."];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
        else {
            UserProperty* music = [self.musicArray objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", music.artist, music.songName];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
       return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
   
        if (indexPath.row == [self.musicArray count]) {
            [self getListOfMusic];
        }
        else {
            UserProperty* music = [self.musicArray objectAtIndex:indexPath.row];
            NSLog(@"%@", music.songURL);
            NSLog(@"%@", music.audioID);
            
            self.currectIndexPath = indexPath.row;
            
            NSLog(@"%@", music.duration);
            
            [self viewMusicPlayerViewControllerWithNameofArtist:music.artist andSongTitle:music.songName withDuration:music.duration andImage:nil andUrlToMusic:music.songURL andAudioID:music.audioID andOwnerID:music.ownerID];
            
            
            
            [[MusicPlayerOptions sharedInstance] playFile:music.songURL withDuration:music.duration];
            
            
        }
    
}


- (void) viewMusicPlayerViewControllerWithNameofArtist:(NSString*) artist andSongTitle:(NSString*) title withDuration:(NSString*) duration andImage:(NSString*) image andUrlToMusic:(NSString*) url andAudioID:(NSString*) audioID andOwnerID:(NSString*) ownerID{

    if (self.VC == nil) {
        self.VC = [[MusicPlayerViewController alloc] init];
    }
    self.VC.urlToSong = url;
    self.VC.imageURL = image;
    self.VC.musicDuration = duration;
    self.VC.musicTitle = title;
    self.VC.musicArtist = artist;
    self.VC.audioID = audioID;
    self.VC.ownerID = ownerID;
    
    [self.VC updateLabelsAndButtons];
    self.VC.musicDelegate = self;
    
 
    
    [MusicPlayerOptions sharedInstance].audioData = nil;
    [MusicPlayerOptions sharedInstance].avWebAudioOrVideoPlayerWithData = nil;
    [MusicPlayerOptions sharedInstance].repeatMode = avmode_withoutrepeat;
    [MusicPlayerOptions sharedInstance].dataMode = avmode_webstream;
    [MusicPlayerOptions  sharedInstance].isDataLoading = NO;
    
    [[MusicPlayerOptions sharedInstance].queue cancelAllOperations];
    
//    if (self.VC.musicPlayerNavigationController == nil) {
//        self.VC.musicPlayerNavigationController = [[UINavigationController alloc] initWithRootViewController:self.VC];
//        self.VC.musicPlayerNavigationController.navigationBar.backgroundColor = [UIColor blackColor];
//        [self.VC.musicPlayerNavigationController.navigationItem.backBarButtonItem setTintColor:[UIColor whiteColor]];
//                                                                                 
//    }
    
    
         [self.musicViewNavigationController pushViewController:self.VC animated:YES];

    
}


- (void) playNextMusic{
  
    if (self.currectIndexPath < [self.musicArray count] - 1) {
        self.currectIndexPath++;
        NSLog(@"index in TableView: %d", self.currectIndexPath);
        
        [self selectWTableViewCellFromAnotheView];
    }
    else if (self.currectIndexPath >= [self.musicArray count] -1 ){
        NSLog(@"Last element in tableView");
        return;
    }
    NSLog(@"%d", self.musicArray.count);
    
}

- (void) playPreviousMusic {
    
    if (self.currectIndexPath > 0) {
        self.currectIndexPath--;
        NSLog(@"index in TableView: %d", self.currectIndexPath);
        
        [self selectWTableViewCellFromAnotheView];
    }
    else if (self.currectIndexPath == 0) {
        NSLog(@"first element in tableView");
        return;
    }
    

}

- (void) selectWTableViewCellFromAnotheView {
    
    NSIndexPath* indexPath= [NSIndexPath indexPathForRow:self.currectIndexPath inSection:1];
    
   [self.wTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [self tableView:self.wTableView didSelectRowAtIndexPath:indexPath];
    
    UserProperty* music = [self.musicArray objectAtIndex:self.currectIndexPath];
    
    if (self.VC == nil) {
        self.VC = [[MusicPlayerViewController alloc] init];
    }
    self.VC.urlToSong = music.songURL;
    self.VC.imageURL = nil;
    self.VC.musicDuration = music.duration;
    self.VC.musicTitle = music.songName;
    self.VC.musicArtist = music.artist;
    self.VC.audioID = music.audioID;
    self.VC.ownerID = music.ownerID;
    
    [self.VC updateLabelsAndButtons];
    
    NSLog(@"%@", music.songURL);
    
    [[MusicPlayerOptions sharedInstance] playFile:music.songURL withDuration:music.duration];
    

}

- (void) createSearcheBarOfTableView {
    
    if (self.searchBar == nil) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height/10)];
        self.searchBar.delegate = self;
    }
    
    
    [self.view addSubview:self.searchBar];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    
        [self.musicArray removeAllObjects];
        
        [self getSearchListOfMusic];
    
    


}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.searchBar.text.length==0) {
        [self.musicArray removeAllObjects];
        [self getListOfMusic];
        NSLog(@"my music");
    }

}


- (void) getSearchListOfMusic {
    
    [[ServerManager sharedManager] searchMusicWithSearchText:self.searchBar.text withCount:400 ifSucces:^(NSArray *searchMusic) {
        [self.musicArray addObjectsFromArray:searchMusic];
        [self.wTableView reloadData];
        
    } andIfFailure:^(NSError *error) {
        NSLog(@"Error = %@", error.localizedDescription);
    }];

    
}
@end
