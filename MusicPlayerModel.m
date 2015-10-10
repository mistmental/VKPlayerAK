//
//  MusicPlayerModel.m
//  VKPlayerAK
//
//  Created by mistmental on 30.09.15.
//  Copyright © 2015 mistmental. All rights reserved.
//

#import "MusicPlayerModel.h"
#import "MusicViewController.h"

@interface MusicPlayerModel ()

@property (strong, nonatomic) MusicViewController* object;
@property (assign, nonatomic) int currentIndexPath;

@end


@implementation MusicPlayerModel

+ (MusicPlayerModel*) sharedManager {
    
    static MusicPlayerModel* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            
            manager = [[MusicPlayerModel alloc] init];
        }
    });
    
    return manager;
}

- (void) playNextOrPreviousMusic:(int)object {
    
    if (self.object == nil) {
        self.object = [[MusicViewController alloc] init];
    }
    
    
    if (self.object.currectIndexPath > object) {
        NSIndexPath* indexPath = [NSIndexPath indexPathWithIndex:self.object.currectIndexPath];
   //     [self.object tableView:self.object.wTableView didSelectRowAtIndexPath:indexPath.row];
    }
    if (self.object.currectIndexPath < object) {
        NSIndexPath* indexPath = [NSIndexPath indexPathWithIndex:self.object.currectIndexPath];
   //     [self.object tableView:self.object.wTableView didSelectRowAtIndexPath:indexPath.row];
    }
    
    
}

@end
