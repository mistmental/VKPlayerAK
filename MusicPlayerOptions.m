//
//  MusicPlayerOptions.m
//  VKPlayerAK
//
//  Created by mistmental on 19.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import "MusicPlayerOptions.h"
 

@interface MusicPlayerOptions ()

@property (strong, nonatomic) NSString* currentMusicOrVideoURLString;
@property (strong, nonatomic) NSString* currentMusicDurationString;
@property (assign, nonatomic) int currentMusicDurationNumber;

@property (assign, nonatomic) int howMuchSecondPlayed;



@end

@implementation MusicPlayerOptions


+ (MusicPlayerOptions*) sharedInstance {
    
    static MusicPlayerOptions* manager;
    if (manager == nil) {
        manager = [[MusicPlayerOptions alloc] init];
       
        manager.sysTimer = nil;
        manager.dataMode = avmode_webstream;
        manager.mode = avmode_play;
        manager.repeatMode = avmode_withoutrepeat;
        manager.av_volume = 1;
        
    }
    
    return manager;
}


#pragma mark - startPlayMusicFile WithDuration

-  (void) playFile:(NSString *)file withDuration:(NSString*) duration {
    
    self.currentMusicDurationString = duration;
    self.currentMusicDurationNumber = [duration intValue];
    NSLog(@"DURATION : %d",self.currentMusicDurationNumber);
    
    self.currectURLMusicString = file;
    
    [self playFile:self.currectURLMusicString];
}

-  (void) playFile: (NSString*) file {

    if (self.mode == avmode_play) {
        
        self.secondsInTimer = 0;
        self.howMuchSecondPlayed = 0;
        
        self.avWebAudioOrVideoPlayer = nil;
        self.avWebAudioOrVideoPlayerWithData = nil;
        
        [self.queue cancelAllOperations];
        [self.downloadMusicOperation cancel];
        NSURL *url = nil;
        
        if ([file hasPrefix:[NSString stringWithFormat:@"http"]])
        {
            
            url = [NSURL URLWithString:[file stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
          
        }
        else
        {
            NSLog(@"Error: BAD URL");
        }
        
              if (self.dataMode == avmode_webstream && self.repeatMode == avmode_withoutrepeat) {

                  self.audioData = nil;
                  self.avWebAudioOrVideoPlayerWithData = nil;
                  self.avWebAudioOrVideoPlayer = [[AVPlayer alloc] initWithURL:url]; //create channel from url
                  
                  if (self.avWebAudioOrVideoPlayer == nil) {
                      NSLog(@"PLAYER IS NIL");
                  }
            
                  
                  
            
            
            
        }
        if (self.dataMode == avmode_webstream && self.isDataLoading == NO && self.repeatMode == avmode_repeat) {
            
           
            self.avWebAudioOrVideoPlayerWithData = nil;
            
            self.avWebAudioOrVideoPlayer = [[AVPlayer alloc] initWithURL:url]; //create channel from url
            
            
            
            
            
            
        }
        
        if (self.dataMode == avmode_datastream && self.repeatMode == avmode_repeat) {
            
            NSError* error;
            if (self.isDataLoading == YES) {
                
                
                self.avWebAudioOrVideoPlayerWithData = [[AVAudioPlayer alloc] initWithData:self.audioData error:&error];
                if (self.avWebAudioOrVideoPlayer) {
                    self.avWebAudioOrVideoPlayer = nil;
                }
                
            }
            
            
            if (self.isDataLoading == NO) {
            
                if (self.avWebAudioOrVideoPlayer == nil) {
                    self.avWebAudioOrVideoPlayer = [[AVPlayer alloc] initWithURL:url];
                }
            
            }
        }
        
        [self play];
    }
    
}

-  (void) play {
    
    if (self.avWebAudioOrVideoPlayer) { //for channel from URL
        [self.avWebAudioOrVideoPlayer play];
        
    }
    else if (self.avWebAudioOrVideoPlayerWithData) {
        [self.avWebAudioOrVideoPlayerWithData play];
        
    }
    else if (self.avLocalAudioOrVideoPlayer) { //for channel from CACHE
        [self.avLocalAudioOrVideoPlayer play];
        
    }
    

    [self new_timer];

}

#pragma mark - create NEW_TIMER

-  (void) new_timer {
    
    if (self.sysTimer == nil) { //create timer for video or music
        
        self.sysTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer_work:) userInfo:nil repeats:YES];
    }
}

-  (void) timer_work: (NSTimer*) timer {
    
    if (self.mode == avmode_pause) {
        return;
    }

   
    
    if ( (self.avWebAudioOrVideoPlayer.rate == 1 && !self.avWebAudioOrVideoPlayer.error) || self.avWebAudioOrVideoPlayerWithData.rate == 1) {
        
    
        if (self.mode == avmode_play) {
            

            self.secondsInTimer++;
            self.howMuchSecondPlayed++;
            NSLog(@"Second of audio: %d", self.secondsInTimer);
            NSLog(@"howMuchSecondPlayedCurrentAudio: %d", self.howMuchSecondPlayed);
            
            if (self.howMuchSecondPlayed == 10) {
                [self asynchronousDownloadToStringURL:self.currectURLMusicString inQueue:self.queue withOperation:self.downloadMusicOperation forData:self.audioData];
            }
            
            
            if (self.secondsInTimer >= self.currentMusicDurationNumber)
            {
            
                if (self.repeatMode == avmode_repeat) {
                    self.dataMode = avmode_datastream;
                    [[MusicPlayerOptions sharedInstance] playFile:self.currectURLMusicString withDuration:self.currentMusicDurationString];
                    
                
                }
                if (self.repeatMode == avmode_withoutrepeat && self.dataMode == avmode_webstream) {
                    [self.repeatsDelegate playingMusicWithoutRepeats];
                }

                if (self.repeatMode == avmode_withoutrepeat && self.dataMode == avmode_datastream){
                    self.dataMode = avmode_webstream;
                    [self.repeatsDelegate playingMusicWithoutRepeats];
                }
            
            }
        
        
        }
    }
    
}
    
-  (void) pause {
    
        if (self.avWebAudioOrVideoPlayer) {
            [self.avWebAudioOrVideoPlayer pause];
            
        }
        else if (self.avWebAudioOrVideoPlayerWithData) {
        [self.avWebAudioOrVideoPlayerWithData pause];

        }
        else if (self.avLocalAudioOrVideoPlayer) {
            [self.avLocalAudioOrVideoPlayer pause];
           
        }
    self.mode = avmode_pause;
    }


    
#pragma mark - volume
    
-  (double) volume {
    
        return self.av_volume;
    }

- (void) playMusicFromCurrentTime:(int) currentTimeSlider {
   
    if (self.avWebAudioOrVideoPlayerWithData == nil) {
        NSError* error;
        self.avWebAudioOrVideoPlayerWithData = [[AVAudioPlayer alloc] initWithData:self.audioData error:&error];
        
    }
    
    if (self.audioData== nil) {
        NSLog(@"DATA IS NIL");
    }
    else {
        NSLog(@"DATA IS NOT NIL");
    }
    
    NSTimeInterval a = (NSTimeInterval)currentTimeSlider;
    
    NSLog(@"%f", a);
    self.secondsInTimer = currentTimeSlider;
    [self.avWebAudioOrVideoPlayerWithData setCurrentTime:a];
    [self pause];
    [self play];
  
}

- (void) asynchronousDownloadToStringURL:(NSString* )stringURL inQueue:(NSOperationQueue *)queue withOperation:(NSOperation*) operation forData:(NSData*) audioData{
    
    if (queue == nil) {
        queue = [NSOperationQueue new];
    }
    
    [queue setQualityOfService:NSQualityOfServiceBackground];
    NSURL* url = [NSURL URLWithString:stringURL];
    if (operation == nil) {
        operation = [NSBlockOperation blockOperationWithBlock:^{
            
            
            if (self.audioData == nil) {

                    self.audioData = [NSData dataWithContentsOfURL:url];
                }
           
           
        }];

    }
    
 
    [queue addOperation:operation];
    [operation setQueuePriority:NSOperationQueuePriorityNormal];
    
    [operation setCompletionBlock:^{
        self.isDataLoading = YES;
        NSLog(@"DATA   LOADING   !!!!");
    }];
  
}


- (void) rewindAudioUrlStreamTo: (int) currentTimeSlider {
 
    CMTime cmTime = CMTimeMake(currentTimeSlider, 1);
    self.secondsInTimer = currentTimeSlider;
    [self.avWebAudioOrVideoPlayer seekToTime:cmTime];
    [self pause];
    [self play];
}

@end
