//
//  PersonalizeNewsViewController.m
//  FlipNews
//
//  Created by NETBIZ on 22/02/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import "PersonalizeNewsViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIView+Toast.h"
@interface PersonalizeNewsViewController ()

@end

@implementation PersonalizeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Personalize News";
    appSettings = [NSUserDefaults standardUserDefaults];
    _selectedCategoriesArray = [[NSMutableArray alloc] init];
    [self loadNewsSelectedCategories];
    [self showSelectedCategories];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectCategoryClicked:(UIButton *)sender
{
    UIButton * selectedButton = sender;
    NSString * selectedCategory = [[selectedButton titleLabel] text];
    NSLog(@"clicked: %@",selectedCategory);
//    if (CGColorEqualToColor([[sender backgroundColor] CGColor],(__bridge CGColorRef _Nullable)(appRedColor)))
    if (CGColorEqualToColor([[sender backgroundColor] CGColor],[appRedColor CGColor]))
    {
        [sender setBackgroundColor:appBlueColor];
        //remove category
        //[self loadNewsSelectedCategories];
        [_selectedCategoriesArray addObjectsFromArray:_selectedNewsCategories];
        NSLog(@"de-selected: %@",selectedCategory);
        [_selectedCategoriesArray removeObject:selectedCategory];
        NSLog(@"-selectedCategoriesArray:%@", _selectedCategoriesArray);
        //[appSettings setObject:_selectedCategoriesArray forKey:@"selectedNewsCategories"];
    
        NSArray * categories = [[NSOrderedSet orderedSetWithArray:_selectedCategoriesArray] array];
        NSLog(@"final categories:\n %@",categories);
        [appSettings setObject:categories forKey:@"selectedNewsCategories"];
        [appSettings synchronize];
    }
    else
    {
        [sender setBackgroundColor:appRedColor];
        //add category
        //[self loadNewsSelectedCategories];
        [_selectedCategoriesArray addObjectsFromArray:_selectedNewsCategories];
        NSLog(@"selected: %@",selectedCategory);
        [_selectedCategoriesArray addObject:selectedCategory];
        NSLog(@"+selectedCategoriesArray:%@", _selectedCategoriesArray);
        //[appSettings setObject:_selectedCategoriesArray forKey:@"selectedNewsCategories"];
        
        NSArray * categories = [[NSOrderedSet orderedSetWithArray:_selectedCategoriesArray] array];
        NSLog(@"final categories:\n %@",categories);
        [appSettings setObject:categories forKey:@"selectedNewsCategories"];
        [appSettings synchronize];
    }
//    [appSettings synchronize];

}

#pragma mark helper methods
-(void) loadNewsSelectedCategories
{
    _selectedNewsCategories = [[NSMutableArray alloc] init];
    _selectedNewsCategories = [appSettings objectForKey:@"selectedNewsCategories"];
    
}
-(void) showSelectedCategories
{
    for (NSString * newsCategory in _selectedNewsCategories)
    {
        if ([[[_artsButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_artsButton setBackgroundColor:appRedColor];
        }
        if ([[[_businessButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_businessButton setBackgroundColor:appRedColor];
        }
        if ([[[_companyButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_companyButton setBackgroundColor:appRedColor];
        }
        if ([[[_topButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_topButton setBackgroundColor:appRedColor];
        }
        if ([[[_healthButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_healthButton setBackgroundColor:appRedColor];
        }
        if ([[[_environmentButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_environmentButton setBackgroundColor:appRedColor];
        }
        if ([[[_entertainmentButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_entertainmentButton setBackgroundColor:appRedColor];
        }
        if ([[[_lifestyleButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_lifestyleButton setBackgroundColor:appRedColor];
        }
        if ([[[_mediaButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_mediaButton setBackgroundColor:appRedColor];
        }
        if ([[[_moneyButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_moneyButton setBackgroundColor:appRedColor];
        }
        if ([[[_trendingButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_trendingButton setBackgroundColor:appRedColor];
        }
        if ([[[_worldButton titleLabel] text] isEqualToString:newsCategory])
        {
            [_worldButton setBackgroundColor:appRedColor];
        }
    }
}
@end
