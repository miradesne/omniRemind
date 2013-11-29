//
//  OmniRemindWebViewController.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/26/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindWebViewController.h"
#import "OmniRemindAppDelegate.h"

@interface OmniRemindWebViewController () <UIWebViewDelegate>

@end

@implementation OmniRemindWebViewController

- (void)setURL:(NSString *)URL {
    _URL = URL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URL]];
    [self.webView loadRequest:request];

}

- (IBAction)back:(id)sender {
    OmniRemindAppDelegate *delegate = (OmniRemindAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
        [delegate checkPush];
    }];
}

@end
