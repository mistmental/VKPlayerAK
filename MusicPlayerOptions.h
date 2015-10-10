//
//  MusicPlayerOptions.h
//  VKPlayerAK
//
//  Created by mistmental on 19.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


#define avmode_datastream 6
#define avmode_webstream 5
#define avmode_withoutrepeat 4
#define avmode_repeat 3
#define avmode_pause 2
#define avmode_play 1
#define avmode_stop 0


@protocol PlayingMusicWithouRepeatsDelegate;


@interface MusicPlayerOptions : NSObject

@property (weak, nonatomic) id <PlayingMusicWithouRepeatsDelegate> repeatsDelegate;

@property (strong, nonatomic) NSTimer* sysTimer;

@property (assign, nonatomic) int mode;
@property (assign, nonatomic) int repeatMode;
@property (assign, nonatomic) int dataMode;

@property (assign,nonatomic) double volume;

@property (assign, nonatomic) double av_volume;

@property (strong, nonatomic) AVPlayer* avWebAudioOrVideoPlayer;

@property (strong, nonatomic) AVAudioPlayer* avWebAudioOrVideoPlayerWithData;
@property (strong, nonatomic) AVAudioPlayer* avLocalAudioOrVideoPlayer;

@property (weak,nonatomic) AVPlayerLayer* av_videoLayer;

@property (strong, nonatomic) NSOperationQueue* queue;
@property (strong, nonatomic) NSOperation* downloadMusicOperation;

@property (strong, nonatomic) NSString* currectURLMusicString;

@property (strong, nonatomic) NSData* audioData;
@property (assign, nonatomic) int secondsInTimer;
@property (assign, nonatomic) BOOL isThisRepeat;

@property (assign, nonatomic) BOOL isDataLoading;



+ (MusicPlayerOptions*) sharedInstance;


- (void) playFile: (NSString*) file withDuration:(NSString*) duration;
- (void) playFile: (NSString*) file;
- (void) play;
- (void) stop;
- (void) pause;
- (void) playMusicFromCurrentTime:(int) currentTimeSlider;
- (void) rewindAudioUrlStreamTo: (int) currentTimeSlider;

@end

@protocol PlayingMusicWithouRepeatsDelegate <NSObject>
@required
- (void) playingMusicWithoutRepeats;

@end
