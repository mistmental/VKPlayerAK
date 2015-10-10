//
//  CachPlayerViewController.h
//  VKPlayerAK
//
//  Created by mistmental on 10/10/15.
//  Copyright © 2015 mistmental. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CachePlayerViewControllerDelegate;
@protocol PlayingMusicWithouRepeatsDelegate;

@interface CachePlayerViewController : UIViewController <PlayingMusicWithouRepeatsDelegate>

@property (weak, nonatomic) id <CachePlayerViewControllerDelegate> musicDelegate;


@property (assign, nonatomic) NSString* musicDuration;
@property (strong, nonatomic) NSString* musicArtist;
@property (strong, nonatomic) NSString* musicTitle;
@property (strong, nonatomic) NSString* imageURL;
@property (strong, nonatomic) NSString* urlToSong;
@property (strong, nonatomic) NSString* audioID;
@property (strong, nonatomic) NSString* ownerID;

@property (assign, nonatomic) NSInteger indexPathOfMusicView;

@property (strong, nonatomic) UISlider* timeMusicSlider;
@property (strong, nonatomic) UILabel* timeMusicSliderLabel;
@property (strong, nonatomic) NSTimer* timerSlider;



- (void) createMusicPlayerButtons;
- (void) createMusicPlayerLabels;
- (void) updateLabelsAndButtons;
- (void) createMusicTimeSlider;

@end


@protocol CachePlayerViewControllerDelegate <NSObject>

- (void) playNextMusic;
- (void) playPreviousMusic;


@end
