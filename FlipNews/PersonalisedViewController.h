//
//  PersonalisedViewController.h
//  FlipNews
//
//  Created by NETBIZ on 13/06/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFlipViewController.h"
#import "Constants.h"

@interface PersonalisedViewController : UIViewController <MPFlipViewControllerDelegate, MPFlipViewControllerDataSource>
{
    NSUserDefaults * appSettings;
    NSArray * newsArray;
    NSString * dataFilePath;
    NSDictionary * displayDictionary;
    BOOL isInternetConnectionAvailable;
    
}

//--IBOutlets--//
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (strong, nonatomic) MPFlipViewController *flipViewController;
@property (weak, nonatomic) IBOutlet UIView *frame;
@property (weak, nonatomic) IBOutlet UIView *contentViewFrame;



//--Properties--//
@property BOOL newsAvailable;
@property (strong, nonatomic) NSMutableArray *pageImage;
@property (strong, nonatomic) NSMutableArray *pageTitles;
@property (strong, nonatomic) NSMutableArray *pagePublishDate;
@property (strong, nonatomic) NSMutableArray *pageMoreLink;

// 15-06-2017
@property (strong, nonatomic) NSMutableArray * selectedNewsCategories;
@property (strong, nonatomic) NSString * newsStringURL;
@property (strong, nonatomic) NSString * newsFileName;
@property (strong, nonatomic) NSMutableArray * personalisedNewsArray;

//--IBActions--//
- (IBAction)reloadNews:(UIBarButtonItem *)sender;

//--Methods--//
//-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
