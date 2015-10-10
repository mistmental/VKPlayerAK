//
//  UserProperty.m
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import "UserProperty.h"

@implementation UserProperty

+ (UserProperty*) sharedUser {
    
    static UserProperty* user;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (user == nil) {
            user = [[UserProperty alloc] init];
        }
    });
    
    return user;

}

- (id)initWithMusicResponce:(NSDictionary*) music
{
    self = [super init];
    if (self) {
        self.artist = [music objectForKey:@"artist"];
        self.songName = [music objectForKey:@"title"];
        self.songURL = [music objectForKey:@"url"];
        self.duration = [music objectForKey:@"duration"];
        self.audioID = [music objectForKey:@"aid"];
        self.ownerID = [music objectForKey:@"owner_id"];
        
    }
    return self;
}

- (id) initWithMusicSearchResponce:(NSDictionary *)music {
    self = [super init];
    if (self) {
        self.artist = [music objectForKey:@"artist"];
        self.songName = [music objectForKey:@"title"];
        self.songURL = [music objectForKey:@"url"];
        self.duration = [music objectForKey:@"duration"];
        self.audioID = [music objectForKey:@"aid"];
        self.ownerID = [music objectForKey:@"owner_id"];
    }
    return self;
}




@end
