//
//  UserProperty.h
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProperty : NSObject


@property(strong, nonatomic) NSString* artist;
@property (strong, nonatomic) NSString* songName;
@property (strong, nonatomic) NSString* songURL;
@property (strong, nonatomic) NSString* duration;

@property (strong, nonatomic) NSString* audioID;
@property (strong, nonatomic) NSString* ownerID;


+ (UserProperty*) sharedUser;

- (id) initWithMusicResponce:(NSDictionary*) music;

- (id) initWithMusicSearchResponce:(NSDictionary*) music;



@end
