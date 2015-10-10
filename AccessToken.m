//
//  AccessToken.m
//  VKPlayerAK
//
//  Created by mistmental on 18.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import "AccessToken.h"

@implementation AccessToken

+ (AccessToken*) sharedToken {
    static AccessToken* token;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (token == nil) {
            token = [[AccessToken alloc] init];
        }
    });

    return token;

}

@end
