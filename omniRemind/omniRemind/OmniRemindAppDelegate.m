//
//  OmniRemindAppDelegate.m
//  omniRemind
//
//  Created by Mira Chen on 10/21/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindAppDelegate.h"
#import <Parse/Parse.h>
#import "CourseDataFetcher.h"

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
    NSLog(@"In finish lunching,....");
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
    NSLog(@"sb");
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to reg");
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    NSLog(@"receive inside bg");
    NSLog(@"%@", userInfo);
    [self handlePush:userInfo];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"%i", buttonIndex);
    self.pushInfo = nil;
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
            info = [NSString stringWithFormat:@"Course: %@\nName: %@\nDue: %@\nDescription: %@\nUrl: %@",
                    push[COURSE_NAME_KEY2],
                    push[ASSIGNMENT_NAME_KEY],
                    push[ASSIGNMENT_DUE_DATE_KEY],
                    push[DETAIL_DESCRIPTION_KEY],
                    push[DETAIL_URL_KEY]];
        }
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:info delegate:self cancelButtonTitle:nil otherButtonTitles:@"yes", @"no", nil];
    [alertView show];
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
