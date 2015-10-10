//
//  CacheViewController.m
//  VKPlayerAK
//
//  Created by mistmental on 06.10.15.
//  Copyright © 2015 mistmental. All rights reserved.
//

#import "CacheViewController.h"
#import "ServerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface CacheViewController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) NSArray* arrayOfContentinCacheDirectly;

@property (strong, nonatomic) NSMutableArray* arrayOfCacheMusic;

@property (strong, nonatomic) NSString* epta;

@property (strong, nonatomic) AVAudioPlayer* player;

@end

@implementation CacheViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self createCacheTableView];
    
    self.epta = [self getDocumentsDirectory];
    NSLog(@"%@",self.epta);
    self.arrayOfContentinCacheDirectly = [[NSArray alloc]init];
    self.arrayOfCacheMusic = [[NSMutableArray alloc] init];
    NSError* error;
    self.arrayOfContentinCacheDirectly = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.epta error:&error];
    NSLog(@"%@",self.arrayOfContentinCacheDirectly);
    
    for (id object in self.arrayOfContentinCacheDirectly) {
        
            NSString* query = [object description];
       
        NSLog(@"%@", [object description]);
        if ([query hasSuffix:@".mp3"]) {
            [self.arrayOfCacheMusic addObject:object];
        }
        
    }
//
//    NSArray* array = [query componentsSeparatedByString:@"#"];
//    if ([array count] > 1) {
//        query = [array lastObject];
//        
//    }
    NSLog(@"CACHE = %@", self.arrayOfCacheMusic);
}

- (void) reloadDocumentsDirectoryAndCacheTableView {
    self.epta = [self getDocumentsDirectory];
    NSError* error;
    
    self.arrayOfContentinCacheDirectly = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.epta error:&error];
    NSLog(@"%@",self.arrayOfContentinCacheDirectly);
    [self.arrayOfCacheMusic removeAllObjects];
    for (id object in self.arrayOfContentinCacheDirectly) {
        
        NSString* query = [object description];
        
        NSLog(@"%@", [object description]);
        if ([query hasSuffix:@".mp3"]) {
            [self.arrayOfCacheMusic addObject:object];
        }
        
    }
}

- (void) createCacheTableView {
    
    if (self.cacheTableView == nil) {
        self.view.backgroundColor = [UIColor blackColor];
        
        if (self.cacheTableView == nil) {
            self.cacheTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - self.view.bounds.size.height/21 - 120)];
            
            [self.view addSubview:self.cacheTableView];
            
        }
        
        self.cacheTableView.dataSource = self;
        self.cacheTableView.delegate = self;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfCacheMusic count];
}

- (NSString *)getDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifire = @"identifire";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        //cell.title =[NSString stringWithFormat:[self.arrayOfCacheMusic objectAtIndex:indexPath.row]];
        cell.textLabel.text = [[self.arrayOfCacheMusic objectAtIndex:indexPath.row] description];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    

    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView = self.cacheTableView;
    
    NSLog(@"%@",self.epta);
    NSString* path = [NSString stringWithFormat:@"%@/%@",self.epta,[[self.arrayOfCacheMusic objectAtIndex:indexPath.row] description]];
    NSLog(@"%@",path);
   // NSString* path2=[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSLog(@"%@",url);
    NSError* error;
    NSData* data = [NSData dataWithContentsOfFile:path];
   self.player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    
    self.player.rate = 1;
   self.player.delegate = self;
    [self.player setVolume:1];

    
    if (error == nil) {
        NSLog(@"AVAudioPlayer start playing");
        [self.player play];
    } else {
        NSLog(@"%@", error);
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"I'm play");
}

@end
