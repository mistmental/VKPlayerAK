//
//  MusicPlayerModel.h
//  VKPlayerAK
//
//  Created by mistmental on 30.09.15.
//  Copyright © 2015 mistmental. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicPlayerModel : NSObject

+ (MusicPlayerModel*) sharedManager;

- (void) playNextOrPreviousMusic:(int)object;


@end
