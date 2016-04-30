//
//  LoginController.m
//  SmallProject
//
//  Created by FangXin on 4/29/16.
//  Copyright © 2016 FangXin. All rights reserved.
//

#import "LoginController.h"
#import "APIManager.h"

@implementation LoginController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self authorize];
  [self.loginWebView setHidden:YES];
  [self.loginWebView.scrollView setScrollEnabled:NO];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)authorize
{
  NSString *urlString = @"https://api.instagram.com/oauth/authorize/?client_id=649a0fe5cb0a42d8aaef019e2646f85c&redirect_uri=http://www.google.com&response_type=token&scope=likes+comments";
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  [self.loginWebView loadRequest:urlRequest];
  
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  
  if ([request.URL.absoluteString rangeOfString:@"#access_token="].location != NSNotFound)
  {
    NSString * urlWithToken = request.URL.absoluteString;
    int charLocation = [urlWithToken rangeOfString:@"#access_token="].location;
    NSString* urlToken = [urlWithToken substringFromIndex:charLocation+14];
    APIManager *tempManager = [APIManager sharedInstance];
    [tempManager buildUpBaseURL:urlToken];
    [self dismissViewControllerAnimated:YES completion:^{
      [self.mainVC loadingData];
    }];
  }
  
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self.loginWebView setHidden:NO];
}

@end
