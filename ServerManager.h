//
//  ServerManager.h
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import "AFNetworking.h"
#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

- (void) getAuthorezPage;

- (void) getMusicWithCount: (NSInteger) count
                withOffset:(NSInteger) offset
                  ifSucces:(void(^)(NSArray* music)) succes
              andIfFailure: (void(^)(NSError* error)) fail;

- (void) searchMusicWithSearchText: (NSString*) searchText withCount:(int) count ifSucces:(void(^)(NSArray* searchMusic)) succes andIfFailure: (void(^)(NSError* error)) fail;

- (void) addMusicToPlaylist:(NSString*) audioID andOwnerID:(NSString*) ownerID ifSucces:(void(^)()) succes andIfFailure: (void(^)(NSError* error)) fail;
- (void) deleteMusicToPlaylist:(NSString*) audioID andOwnerID:(NSString*) ownerID ifSucces:(void(^)()) succes andIfFailure: (void(^)(NSError* error)) fail;

- (void) downloadMusicToCacheWithURLString:(NSString*) urlString toPathWithName:(NSString*) musicName;
@end
