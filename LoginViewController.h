//
//  LoginViewController.h
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProperty.h"

@protocol PresentMusicTableViewControllerDelegate;


@interface LoginViewController : UIViewController

@property (weak, nonatomic) id <PresentMusicTableViewControllerDelegate> presentTableViewDelegate;

@property (strong, nonatomic) UIWebView* loginView;

@end

@protocol PresentMusicTableViewControllerDelegate <NSObject>

- (void) presentMusicTableViewController;

@end