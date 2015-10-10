//
//  CachPlayerViewController.m
//  VKPlayerAK
//
//  Created by mistmental on 10/10/15.
//  Copyright © 2015 mistmental. All rights reserved.
//

#import "CachePlayerViewController.h"
#import "MusicPlayerOptions.h"

@interface CachePlayerViewController ()  <UIPopoverControllerDelegate>

@property (strong, nonatomic) MusicPlayerOptions* VC;

@property (strong, nonatomic) UIImageView* imageViewOfMusic;
@property (strong, nonatomic) UILabel* musicArtistLabel;
@property (strong, nonatomic) UILabel* musicTitleLabel;

@property (strong, nonatomic) UIButton* playButton;
@property (strong, nonatomic) UIButton* nextButton;
@property (strong, nonatomic) UIButton* previousButton;
@property (strong, nonatomic) UIButton* repeatButton;
@property (strong, nonatomic) UIButton* addButton;
@property (strong, nonatomic) UIButton* deleteButton;
@property (strong, nonatomic) UIButton* saveButton;

@property (assign, nonatomic) int isPlayButtonEnable;
@property (assign, nonatomic) int isRepeatButtonEnable;

@property (strong, nonatomic) UIProgressView* progressViewOfMusicDuration;

@property (strong, nonatomic) UIButton *detailButton;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIView* popView;
@property (strong, nonatomic) UIViewController* nNewPopVC;




@end


@implementation CachePlayerViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    [MusicPlayerOptions sharedInstance].repeatsDelegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self updateLabelsAndButtons];
    
    
    
    self.isPlayButtonEnable = 0;
    self.isRepeatButtonEnable = 0;
    
    
}


- (void) createMusicPlayerButtons {
    NSMutableArray* buttonsArray;
    if (buttonsArray == nil) {
        buttonsArray = [[NSMutableArray alloc] initWithObjects:@"Previous", @"Play", @"Next",@"Repeat", nil];
    }
    if (self.nextButton == nil && self.playButton == nil && self.previousButton == nil && self.repeatButton == nil) {
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.nextButton.frame = CGRectMake(0, 0, self.view.bounds.size.width/6, self.view.bounds.size.height/32);
        self.nextButton.center = CGPointMake(self.view.bounds.size.width*4/5, self.view.bounds.size.height*4/5);
        
        [self.nextButton setTitle:[buttonsArray objectAtIndex:2] forState:UIControlStateNormal];
        
        [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.nextButton.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:self.view.bounds.size.height/32]];
        [self.nextButton addTarget:self action:@selector(nextMusic) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.nextButton];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.playButton.frame = CGRectMake(0, 0, self.view.bounds.size.width/6, self.view.bounds.size.height/32);
        self.playButton.center = CGPointMake(self.view.bounds.size.width*3/5, self.view.bounds.size.height*4/5);
        
        [self.playButton setTitle:[buttonsArray objectAtIndex:1] forState:UIControlStateNormal];
        [self.playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.playButton.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:self.view.bounds.size.height/32]];
        [self.playButton addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playButton];
        
        self.previousButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.previousButton.frame = CGRectMake(0, 0, self.view.bounds.size.width/6, self.view.bounds.size.height/32);
        self.previousButton.center = CGPointMake(self.view.bounds.size.width*2/5, self.view.bounds.size.height*4/5);
        
        [self.previousButton setTitle:[buttonsArray objectAtIndex:0] forState:UIControlStateNormal];
        [self.previousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.previousButton.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:self.view.bounds.size.height/32]];
        [self.previousButton addTarget:self action:@selector(previousMusic) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.previousButton];
        
        self.repeatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.repeatButton.frame = CGRectMake(0, 0, self.view.bounds.size.width/6, self.view.bounds.size.height/32);
        self.repeatButton.center = CGPointMake(self.view.bounds.size.width*1/5, self.view.bounds.size.height*4/5);
        
        [self.repeatButton setTitle:[buttonsArray objectAtIndex:3] forState:UIControlStateNormal];
        [self.repeatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.repeatButton.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:self.view.bounds.size.height/32]];
        [self.repeatButton addTarget:self action:@selector(repeatMusic) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.repeatButton];
        
        self.detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.detailButton.frame = CGRectMake(0, 0, self.view.bounds.size.width/6, self.view.bounds.size.height/32);
        self.detailButton.center = CGPointMake(self.view.bounds.size.width*2.5/5, self.view.bounds.size.height*2/5);
        
        [self.detailButton setTitle:[NSString stringWithFormat:@"..."] forState:UIControlStateNormal];
        [self.detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.detailButton.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:self.view.bounds.size.height/32]];
        [self.detailButton addTarget:self action:@selector(showPop) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.detailButton];
        
    }
    
}

- (void) createMusicPlayerLabels {
    
    if (self.musicArtistLabel == nil && self.musicTitleLabel == nil) {
        self.musicArtistLabel = [[UILabel alloc] init];
        self.musicArtistLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width/1.5, self.view.bounds.size.height/10);
        self.musicArtistLabel.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*3.5/5);
        [self.musicArtistLabel setFont:[UIFont fontWithName:@"Palatino" size:self.view.bounds.size.height/40]];
        self.musicArtistLabel.textColor = [UIColor blackColor];
        [self.musicArtistLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.musicTitleLabel = [[UILabel alloc] init];
        self.musicTitleLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width/1.5, self.view.bounds.size.height/10);
        self.musicTitleLabel.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*3/5);
        [self.musicTitleLabel setFont:[UIFont fontWithName:@"Palatino" size:self.view.bounds.size.height/45]];
        self.musicTitleLabel.textColor = [UIColor blackColor];
        [self.musicTitleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.view addSubview:self.musicArtistLabel];
        [self.view addSubview:self.musicTitleLabel];
    }
    self.musicArtistLabel.text = self.musicArtist;
    
    self.musicTitleLabel.text = self.musicTitle;
    NSLog(@"%@ %@",self.musicArtistLabel.text, self.musicTitleLabel.text);
    
}

- (void) updateLabelsAndButtons {
    
    [self.musicArtistLabel removeFromSuperview];
    [self.musicTitleLabel removeFromSuperview];
    
    [self.playButton removeFromSuperview];
    [self.previousButton removeFromSuperview];
    [self.nextButton removeFromSuperview];
    [self.repeatButton removeFromSuperview];
    
    
    self.playButton = nil;
    self.previousButton = nil;
    self.nextButton = nil;
    self.repeatButton = nil;
    
    [self.timeMusicSlider removeFromSuperview];
    [self.timeMusicSliderLabel removeFromSuperview];
    
    [self createMusicPlayerLabels];
    [self createMusicPlayerButtons];
    [self createMusicTimeSlider];
    
    
    self.isPlayButtonEnable = 0;
    self.isRepeatButtonEnable = 0;
    self.deleteButton.enabled = YES;
    self.addButton.enabled = YES;
    self.saveButton.enabled = YES;
    
    [self.view addSubview:self.musicArtistLabel];
    [self.view addSubview:self.musicTitleLabel];
    
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.previousButton];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.repeatButton];
    
    [self.view addSubview:self.timeMusicSlider];
    [self.view addSubview:self.timeMusicSliderLabel];
}

- (void) nextMusic {
    
    [MusicPlayerOptions sharedInstance].mode = avmode_play;
    [MusicPlayerOptions sharedInstance].audioData = nil;
    [MusicPlayerOptions sharedInstance].dataMode = avmode_webstream;
    [MusicPlayerOptions sharedInstance].isDataLoading = NO;
    
    [[MusicPlayerOptions sharedInstance].queue cancelAllOperations];
    [[MusicPlayerOptions sharedInstance].queue delete:[[MusicPlayerOptions sharedInstance].queue operations]];
    [[MusicPlayerOptions sharedInstance].downloadMusicOperation cancel];
    [MusicPlayerOptions sharedInstance].downloadMusicOperation = nil;
    
    
    if ([MusicPlayerOptions sharedInstance].repeatMode == avmode_repeat) {
        [MusicPlayerOptions sharedInstance].repeatMode = avmode_withoutrepeat;
        [self.repeatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    
    
    
    [self.musicDelegate playNextMusic];
    
    
}
- (void) previousMusic {
    
    [MusicPlayerOptions sharedInstance].mode = avmode_play;
    [MusicPlayerOptions sharedInstance].audioData = nil;
    [MusicPlayerOptions sharedInstance].dataMode = avmode_webstream;
    [MusicPlayerOptions sharedInstance].isDataLoading = NO;
    
    [[MusicPlayerOptions sharedInstance].queue cancelAllOperations];
    [[MusicPlayerOptions sharedInstance].queue delete:[[MusicPlayerOptions sharedInstance].queue operations]];
    [[MusicPlayerOptions sharedInstance].downloadMusicOperation cancel];
    [MusicPlayerOptions sharedInstance].downloadMusicOperation = nil;
    
    
    if ([MusicPlayerOptions sharedInstance].repeatMode == avmode_repeat) {
        [MusicPlayerOptions sharedInstance].repeatMode = avmode_withoutrepeat;
        [self.repeatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    [self.musicDelegate playPreviousMusic];
    
}
- (void) playMusic {
    
    if (self.isPlayButtonEnable % 2 == 0) {
        [MusicPlayerOptions sharedInstance].mode = avmode_pause;
        
        
        [[MusicPlayerOptions sharedInstance] pause];
        
        
        NSLog(@"pause");
        
    }
    if (self.isPlayButtonEnable % 2 == 1) {
        [MusicPlayerOptions sharedInstance].mode = avmode_play;
        
        
        [[MusicPlayerOptions sharedInstance] play];
        
        
        NSLog(@"play");
    }
    
    self.isPlayButtonEnable++;
    
}
- (void) repeatMusic {
    
    if (self.isRepeatButtonEnable % 2 == 0) {
        
        [MusicPlayerOptions sharedInstance].repeatMode = avmode_repeat;
        [MusicPlayerOptions sharedInstance].isThisRepeat = YES;
        [self.repeatButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        NSLog(@"repeat enable = YES");
    }
    if (self.isRepeatButtonEnable % 2 == 1) {
        
        [MusicPlayerOptions sharedInstance].repeatMode = avmode_withoutrepeat;
        [MusicPlayerOptions sharedInstance].isThisRepeat = NO;
        [self.repeatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSLog(@"repeat enable = NO");
    }
    
    self.isRepeatButtonEnable++;
    
}


- (void) playingMusicWithoutRepeats {
    [self nextMusic];
}

- (void) createMusicTimeSlider {
    
    
    if (self.timeMusicSlider == nil) {
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width/1.2, 20);
        self.timeMusicSlider = [[UISlider alloc] initWithFrame:frame];
        self.timeMusicSlider.center = CGPointMake(self.view.bounds.size.width/2 - 40, self.view.bounds.size.height*6.5/9);
    }
    if (self.timeMusicSliderLabel == nil) {
        self.timeMusicSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        self.timeMusicSliderLabel.center = CGPointMake(self.view.bounds.size.width*8/9, self.view.bounds.size.height*6.5/9);
    }
    
    
    [self.timeMusicSlider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
    [self.timeMusicSlider setBackgroundColor:[UIColor clearColor]];
    self.timeMusicSlider.minimumValue = 0.0;
    self.timeMusicSlider.maximumValue = [self.musicDuration intValue];
    
    NSLog(@"MAX TIMESLIDER DURATION: %d", [self.musicDuration intValue]);
    
    self.timeMusicSlider.continuous = YES;
    self.timeMusicSlider.value = 0;
    [self.view addSubview:self.timeMusicSlider];
    
    [self.timeMusicSliderLabel setFont:[UIFont fontWithName:@"Palatino" size:self.view.bounds.size.height/50]];
    self.timeMusicSliderLabel.textColor = [UIColor blackColor];
    [self.timeMusicSliderLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:self.timeMusicSliderLabel];
    
    int minutes = [self.musicDuration intValue] / 60;
    int seconds = [self.musicDuration intValue] - minutes*60;
    
    if (seconds < 10) {
        self.timeMusicSliderLabel.text = [NSString stringWithFormat:@"%d:0%d", minutes, seconds];
    }
    else {
        self.timeMusicSliderLabel.text = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
    }
    
    
    if (self.timerSlider == nil) {
        self.timerSlider = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerSliderAction) userInfo:nil repeats:YES];
    }
}


- (void) sliderAction {
    
    NSLog(@"%d", (int)self.timeMusicSlider.value);
    self.isPlayButtonEnable = 0;
    //self.timeMusicSlider.value = [MusicPlayerOptions sharedInstance].secondsInTimer;
    
    if ([MusicPlayerOptions sharedInstance].avWebAudioOrVideoPlayer) {
        if ([MusicPlayerOptions sharedInstance].dataMode == avmode_webstream) {
            [[MusicPlayerOptions sharedInstance] rewindAudioUrlStreamTo:(int)self.timeMusicSlider.value];
        }
        
    }
    if ([MusicPlayerOptions sharedInstance].dataMode == avmode_datastream) {
        [[MusicPlayerOptions sharedInstance] playMusicFromCurrentTime:(int)self.timeMusicSlider.value];
    }
    int time = [self.musicDuration intValue] - (int)self.timeMusicSlider.value;
    int minutes = time / 60;
    int seconds = time - minutes*60;
    if (seconds < 10) {
        self.timeMusicSliderLabel.text = [NSString stringWithFormat:@"%d:0%d", minutes, seconds];
    }
    else {
        self.timeMusicSliderLabel.text = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
    }
    [MusicPlayerOptions sharedInstance].mode = avmode_play;
    
}

- (void) timerSliderAction {
    
    
    
    if ([MusicPlayerOptions sharedInstance].mode == avmode_pause) {
        return;
    }
    else {
        
        self.timeMusicSlider.value = [MusicPlayerOptions sharedInstance].secondsInTimer;
        //  NSLog(@"%d", [MusicPlayerOptions sharedInstance].secondsInTimer);
        // self.timeMusicSlider.value++;
        int time = [self.musicDuration intValue] - (int)self.timeMusicSlider.value;
        int minutes = time / 60;
        int seconds = time - minutes*60;
        if (seconds < 10) {
            self.timeMusicSliderLabel.text = [NSString stringWithFormat:@"%d:0%d", minutes, seconds];
        }
        else {
            self.timeMusicSliderLabel.text = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
        }
    }
}

- (void) showPop {
    
    [self createPopover];
    
}

- (void) createPopover {
    
    if (self.popView == nil) {
        self.popView = [[UIView alloc] init];
        self.popView.frame = CGRectMake(0, 0, 300, 400);
        self.popover.backgroundColor = [UIColor redColor];
        
    }
    if (self.nNewPopVC == nil) {
        self.nNewPopVC = [[UIViewController alloc] init];
    }
    if (self.popover == nil) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:self.nNewPopVC];
    }
    
    self.nNewPopVC.view = self.popView;
    
    [self.popover setDelegate:self];
    [self.popover setPopoverContentSize:CGSizeMake(300, 400)];
    
    
    [self.popover presentPopoverFromRect:self.detailButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    

    
    
}




@end
