//
//  PersonalizeNewsViewController.h
//  FlipNews
//
//  Created by NETBIZ on 22/02/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface PersonalizeNewsViewController : UIViewController
{
    NSUserDefaults * appSettings;
}

@property (strong, nonatomic) NSArray * newsCategoriesArray;
@property (strong, nonatomic) NSMutableArray * selectedNewsCategories;
@property (strong, nonatomic) NSMutableArray * selectedCategoriesArray;
// -- IBOutlets --//
@property (strong, nonatomic) IBOutlet UIButton *artsButton;
@property (strong, nonatomic) IBOutlet UIButton *businessButton;

@property (strong, nonatomic) IBOutlet UIButton *companyButton;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
@property (strong, nonatomic) IBOutlet UIButton *healthButton;
@property (strong, nonatomic) IBOutlet UIButton *environmentButton;

@property (strong, nonatomic) IBOutlet UIButton *entertainmentButton;
@property (strong, nonatomic) IBOutlet UIButton *lifestyleButton;
@property (strong, nonatomic) IBOutlet UIButton *mediaButton;
@property (strong, nonatomic) IBOutlet UIButton *moneyButton;

@property (strong, nonatomic) IBOutlet UIButton *trendingButton;
@property (strong, nonatomic) IBOutlet UIButton *worldButton;

//-- + -- //

- (IBAction)selectCategoryClicked:(UIButton *)sender;

@end
