//
//  Constants.h
//  FlipNews
//
//  Created by NETBIZ on 09/02/17.
//  Copyright © 2017 NetBiz. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//--Google API constants--//
#define GoogleMobileAdsApplicationID @"ca-app-pub-9694038684188995~3370086864" // Replace this with the live one, once the app is live
#define GoogleAdUnitID @"ca-app-pub-9694038684188995/4653612860"; //Replace this with the live AdUnitID once the app is live.

//--Custom comstants--//
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//--Color constants--//
#define appBlueColor  [UIColor colorWithRed:(51.0/255.0) green:(74.0/255.0) blue:(93.0/255.0) alpha:(1.0)] // #334A5D

#define appRedColor  [UIColor colorWithRed:(255.0/255.0) green:(112.0/255.0) blue:(88.0/255.0) alpha:(1.0)] // #FF7058

#define appGreenColor [UIColor colorWithRed:(0.0) green:(187.0/255.0) blue:(63.0/255.0) alpha:(1.0)] // #00BB3F

#define appBackgroundColor [UIColor colorWithRed:(230.0/255.0) green:(230.0/255.0) blue:(230.0/255.0) alpha:(1.0)] //# E6E6E6




//--File Imports--//

//---------------//
#import "MBProgressHUD.h"
#import "XMLParser.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "mySWRViewController.h"

//--+--//

//--RSS Feeds--//
#define ArtsNewsFeed @"http://feeds.reuters.com/news/artsculture"
#define BusinessNewsFeed @"http://feeds.reuters.com/reuters/businessNews"
#define CompanyNewsFeed @"http://feeds.reuters.com/reuters/companyNews"
#define EntertainmentNewsFeed @"http://feeds.reuters.com/reuters/entertainment"
#define EnvironmentNewsFeed @"http://feeds.reuters.com/reuters/environment"
#define HealthNewsFeed @"http://feeds.reuters.com/reuters/healthNews"
#define LifestyleNewsFeed @"http://feeds.reuters.com/reuters/lifestyle"
#define MoneyNewsFeed @"http://feeds.reuters.com/news/wealth"
#define MostReadNewsFeed @"http://feeds.reuters.com/reuters/MostRead"
#define OddlyEnoughNewsFeed @"http://feeds.reuters.com/reuters/oddlyEnoughNews"
#define PeopleNewsFeed @"http://feeds.reuters.com/reuters/peopleNews"
#define PoliticsNewsFeed @"http://feeds.reuters.com/Reuters/PoliticsNews"
#define ScienceNewsFeed @"http://feeds.reuters.com/reuters/scienceNews"
#define SportsNewsFeed @"http://feeds.reuters.com/reuters/sportsNews"
#define TechnologyNewsFeed @"http://feeds.reuters.com/reuters/technologyNews"
#define TopNewsFeed @"http://feeds.reuters.com/reuters/topNews"
#define USNewsFeed @"http://feeds.reuters.com/Reuters/domesticNews"
#define WorldNewsFeed @"http://feeds.reuters.com/Reuters/worldNews"
//--+--//

//--Function Blocks--//


#define setTitleBarWhiteColor self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];


#endif /* Constants_h */
