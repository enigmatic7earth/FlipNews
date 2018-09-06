//
//  AppDelegate.h
//  FlipNews
//
//  Created by NETBIZ on 13/02/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@import GoogleMobileAds; // Google Mobile Ads

#import "MainViewController.h"
#import "ArtsViewController.h"
#import "BusinessViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>
{
    UIViewController * viewController;
}
@property (strong, nonatomic) UIWindow *window;


@end

