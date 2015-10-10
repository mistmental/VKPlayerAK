//
//  LoginViewController.m
//  VKPlayerAK
//
//  Created by mistmental on 17.09.15.
//  Copyright (c) 2015 mistmental. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerManager.h"
#import "MusicViewController.h"
#import "AccessToken.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (strong, nonatomic) MusicViewController* VC;


@end

@implementation LoginViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self createLoginView];


}

- (UIWebView*) createLoginView {
    
    UIWebView* loginView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    loginView.backgroundColor = [UIColor blackColor];
    self.loginView = loginView;
    
    NSString* stringOfLoginView = @"https://oauth.vk.com/authorize?client_id=5073488&display=page&redirect_uri=http://VKPlayerAK&scope=audio&response_type=token&v=5.37&revoke=1";
    NSURL* url=[NSURL URLWithString:stringOfLoginView];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:loginView];
    [loginView loadRequest:request];
    
     loginView.delegate = self;
    //[[ServerManager sharedManager] getAuthorezPage];
    return loginView;
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    
    NSLog(@"%@", [request URL]);
    
    
    if ([[[request URL] host] isEqualToString:@"vkplayerak"]) {
        
        
        NSString* query = [[request URL] description];
        NSArray* array = [query componentsSeparatedByString:@"#"];
        if ([array count] > 1) {
            query = [array lastObject];
            
        }
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        for (NSString* pair in pairs)
        {
            NSArray* pair1 = [pair componentsSeparatedByString:@"="];
            if ([pair1 count] == 2)
            {
                NSString* key = [pair1 firstObject];
                if ([key isEqualToString:@"access_token"])
                {
                  NSString* token = [pair1 lastObject];
                    
                    [AccessToken sharedToken].accessToken = token;
                    NSLog(@"!!!!!!!!! = %@", [AccessToken sharedToken].accessToken);
                    
                }
                else if ([key isEqualToString:@"expires_in"])
                {
                    NSTimeInterval interval = [[pair1 lastObject] doubleValue];

                }
                else if ([key isEqualToString:@"user_id"])
                {
                  NSString* userID = [pair1 lastObject];
                    [AccessToken sharedToken].userID = userID;
                    NSLog(@"%@", [AccessToken sharedToken].userID);
                }
            }
        }
        
        [self.presentTableViewDelegate presentMusicTableViewController];

    }
    
    NSLog(@"%@", [AccessToken sharedToken].userID);
    NSLog(@"%@", [AccessToken sharedToken].accessToken);
    
    return YES;
}


//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
//
//    [self createLoginView];
//}
@end
