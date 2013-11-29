//
//  OmniRemindWebViewController.h
//  omniRemind
//
//  Created by WenXuan Cai on 11/26/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OmniRemindWebViewController : UIViewController
@property (strong, nonatomic) NSString *URL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
