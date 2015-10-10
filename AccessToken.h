//
//  AccessToken.h
//  VKPlayerAK
//
//  Created by mistmental on 18.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* userID;
@property (assign, nonatomic) NSTimeInterval* expiresIn;

+ (AccessToken*) sharedToken;

@end
