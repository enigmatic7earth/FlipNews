//
//  PersonalisedContentViewController.h
//  FlipNews
//
//  Created by NETBIZ on 13/06/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
@import GoogleMobileAds;

@interface PersonalisedContentViewController : UIViewController <GADBannerViewDelegate>
{
    NSUserDefaults * appSettings;
    NSMutableArray * bookmarksArray;
}
// Properties

@property NSUInteger newsIndex;
@property (strong, nonatomic) NSString * newsArticleImage;
@property (strong, nonatomic) NSString * newsArticleHeading;
@property (strong, nonatomic) NSString * newsArticlePublishedDate;
@property (strong, nonatomic) NSString * newsArticleContent;
@property (strong, nonatomic) NSString * newsArticleMoreLink;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *newsImageView;
@property (strong, nonatomic) IBOutlet UILabel *newsHeadingLabel;
@property (strong, nonatomic) IBOutlet UILabel *newsPublishedDate;
@property (strong, nonatomic) IBOutlet UITextView *newsContentTextView;
@property (strong, nonatomic) IBOutlet GADBannerView *adBanner;


// IBActions

- (IBAction)readMoreOnWeb:(id)sender;
- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;
- (IBAction)saveAsBookmark:(id)sender;
- (IBAction)shareMore:(UIButton *)sender;
@end
