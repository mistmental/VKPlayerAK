//
//  ServerManager.m
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import "ServerManager.h"
#import "UserProperty.h"
#import "AccessToken.h"


@interface ServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

@end


@implementation ServerManager

+ (ServerManager*) sharedManager {
    
    static ServerManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            
            manager = [[ServerManager alloc] init];
        }
    });
   
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) getAuthorezPage {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://oauth.vk.com/authorize?client_id=5073488&display=page&redirect_uri=http://VKPlayerAK&scope=audio&response_type=token&v=5.37" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];


}

- (void) getMusicWithCount: (NSInteger) count
                withOffset:(NSInteger) offset
                  ifSucces:(void(^)(NSArray* music)) succes
              andIfFailure: (void(^)(NSError* error)) fail {
    
    
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [AccessToken sharedToken].userID, @"owner_id",
                            @(offset), @"offset",
                            @(count), @"count",
                            [AccessToken sharedToken].accessToken, @"access_token",
                            nil];
    [self.requestOperationManager GET:@"audio.get" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"%@", responseObject);
        NSDictionary* responseArray1 = [responseObject objectForKey:@"response"];

        NSMutableArray* music = [NSMutableArray array];
        
        for (NSDictionary* dict in responseArray1) {
            if ([dict isKindOfClass:NSNumber.class]) {
                NSLog(@"this is nubmer");
                continue;
            }
            UserProperty* user = [[UserProperty alloc] initWithMusicResponce:dict];
            [music addObject:user];
        }
        
        if (succes) {
            succes(music);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (fail) {
            fail(error);
        }
    }];
    
}

  


- (void) searchMusicWithSearchText:(NSString *)searchText
                                      withCount:(int) count
                                       ifSucces:(void(^)(NSArray* searchMusic)) succes
                                   andIfFailure: (void(^)(NSError* error)) fail  {
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [AccessToken sharedToken].userID, @"owner_id",
                            @(count), @"count",
                            searchText, @"q",
                            @(1), @"auto_complete",
                            @(0), @"performer_only",
                            @(1), @"search_own",
                            [AccessToken sharedToken].accessToken, @"access_token",
                            nil];
    [self.requestOperationManager GET:@"audio.search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"%@", responseObject);
        NSDictionary* responseArray = [responseObject objectForKey:@"response"];
        
        NSMutableArray* searchMusic = [NSMutableArray array];
        
        for (NSDictionary* dict in responseArray) {
            if ([dict isKindOfClass:NSNumber.class]) {
                NSLog(@"this is nubmer");
                continue;
            }
            UserProperty* user = [[UserProperty alloc] initWithMusicResponce:dict];
            [searchMusic addObject:user];
        }
        
        if (succes) {
            succes(searchMusic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (fail) {
            fail(error);
        }
    }];

    
}

- (void) addMusicToPlaylist:(NSString*) audioID andOwnerID:(NSString*) ownerID ifSucces:(void(^)()) succes andIfFailure: (void(^)(NSError* error)) fail {
    NSLog(@"%d", [audioID intValue]);
  //  NSInteger audio_ID = [audioID integerValue];
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @([ownerID integerValue]), @"owner_id",
                            @([audioID integerValue]), @"audio_id",
                            [AccessToken sharedToken].accessToken, @"access_token",
                            nil];
    [self.requestOperationManager POST:@"audio.add" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (succes) {
            NSLog(@"music added");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (fail) {
            fail(error);
        }
    }];

}

- (void) deleteMusicToPlaylist:(NSString*) audioID andOwnerID:(NSString*) ownerID ifSucces:(void(^)()) succes andIfFailure: (void(^)(NSError* error)) fail {

    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [AccessToken sharedToken].userID, @"owner_id",
                            @([audioID integerValue]), @"audio_id",
                            [AccessToken sharedToken].accessToken, @"access_token",
                            nil];
    [self.requestOperationManager POST:@"audio.delete" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (succes) {
            NSLog(@"music deleted");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (fail) {
            fail(error);
        }
    }];
    
}

- (void) downloadMusicToCacheWithURLString:(NSString*) urlString toPathWithName:(NSString*) musicName {

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains
                          (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:
                          musicName];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];

    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        
        //show here your downloading progress if needed
        
        
    }];
    
    [operation setCompletionBlock:^{
        
        NSLog(@"%@", cacheDir);
        NSLog(@"File successfully downloaded");
        NSLog(@"%@", filePath);
    }];
    
    [operation start];

}

@end
