//
//  OmniRemindAppDelegate.m
//  omniRemind
//
//  Created by Mira Chen on 10/21/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindAppDelegate.h"
#import "CourseDataFetcher.h"
#import "OmniRemindWebViewController.h"
#import "OmniRemindDataManager.h"
#import <Parse/Parse.h>

@interface OmniRemindAppDelegate() <UIAlertViewDelegate>
@property (strong, nonatomic) NSDictionary *pushInfo;
@end

#define NOTIFICATION_TYPE_KEY @"nType"
#define COURSE_INFO_TYPE_KEY @"cType"
#define TYPE_COURSE @"course"
#define TYPE_ASSIGNMENT @"assignment"
#define COURSE_NAME_KEY2 @"course"
#define DETAIL_DESCRIPTION_KEY @"description"
#define DETAIL_URL_KEY @"url"

@implementation OmniRemindAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"lw8hrBQcOJEO6JVTSTmdXjrsSFZIXqF7YrWzet8r"
                  clientKey:@"A8KUM9TfOZA0zLmp4BnkYnT0mZT5lSSwZH33g92r"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    NSLog(@"launch options: %@", launchOptions);
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    [PFPush storeDeviceToken:deviceToken];
    [PFPush subscribeToChannelInBackground:@""];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to reg, probably because of running on the simulator instead of real phone");
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self handlePush:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Receive local notification %@", notification);
}

// Check if the push has been finished, used when the alert view returns.
- (void)checkPush {
    [self handlePush:self.pushInfo];
}

//NSDateFormatter *df = [[NSDateFormatter alloc] init];
//[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//NSDate *myDate = [df dateFromString: @"1992-12-30 23:59:59"];

- (void)handlePush:(NSDictionary *)push {
    self.pushInfo = push;
    NSString *title;
    NSString *info;
    if ([TYPE_COURSE isEqualToString:push[NOTIFICATION_TYPE_KEY]]) {
        if ([TYPE_ASSIGNMENT isEqualToString:push[COURSE_INFO_TYPE_KEY]]) {
            title = @"Assignment Notification";
            info = [NSString stringWithFormat:@"Course: %@\nName: %@\nDue: %@\nDescription: %@\nUrl: %@\n\nSave the assignment event to the calendar?",
                    push[COURSE_NAME_KEY2],
                    push[ASSIGNMENT_NAME_KEY],
                    push[ASSIGNMENT_DUE_DATE_KEY],
                    push[DETAIL_DESCRIPTION_KEY],
                    push[DETAIL_URL_KEY]];
        }
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:info delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", @"Assignment Page", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Yes. Add it.
        self.pushInfo = nil;
    } else if (buttonIndex == 1) {
        // No. :<
        self.pushInfo = nil;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        OmniRemindWebViewController *uvc = [storyboard instantiateViewControllerWithIdentifier:@"OmniRemindWebViewController"];
        uvc.URL = self.pushInfo[DETAIL_URL_KEY];
        [self.window.rootViewController presentViewController:uvc animated:NO completion:^{
            
        }];
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
