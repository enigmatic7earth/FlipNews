//
//  BookmarksViewController.h
//  FlipNews
//
//  Created by NETBIZ on 14/02/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFlipViewController.h"
#import "Constants.h"

@interface BookmarksViewController : UIViewController <MPFlipViewControllerDelegate, MPFlipViewControllerDataSource>
{
    NSUserDefaults * appSettings;
    NSArray * bookmarksArray;
    NSString * dataFilePath;
    NSDictionary * displayDictionary;
    
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (strong, nonatomic) MPFlipViewController *flipViewController;
@property (weak, nonatomic) IBOutlet UIView *frame;
@property (weak, nonatomic) IBOutlet UIView *contentViewFrame;

@property BOOL bookmarksAvailable;
@property (strong, nonatomic) NSMutableArray *pageImage;
@property (strong, nonatomic) NSMutableArray *pageTitles;
@property (strong, nonatomic) NSMutableArray *pagePublishDate;
@property (strong, nonatomic) NSMutableArray *pageMoreLink;

@end
