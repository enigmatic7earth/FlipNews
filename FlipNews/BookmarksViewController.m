//
//  BookmarksViewController.m
//  FlipNews
//
//  Created by NETBIZ on 14/02/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import "BookmarksViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BookmarksContentViewController.h"

#define CONTENT_IDENTIFIER @"BookmarksContentViewController"
#define FRAME_MARGIN	0 //60
#define PAGE_MIN        0

@interface BookmarksViewController ()

@property (assign, nonatomic) int previousIndex;
@property (assign, nonatomic) int tentativeIndex;
@property (assign, nonatomic) BOOL observerAdded;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",NSHomeDirectory());
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self allocInits];
    [self initMenuBar];
    //--Set NSUserDefaults--//
    appSettings = [NSUserDefaults standardUserDefaults];
    [appSettings setValue:@"YES" forKey:@"IntroductionDone"];
    [appSettings synchronize];
    //--+--//
    //--Load the file that saves bookmarks--//
    [self loadBookmarks];
    // Configure and setup FlipViewController
    if (_bookmarksAvailable == YES)
    {
        [self setupFlipViewController];
        //self.previousIndex = PAGE_MIN;
        [self addObserver];
    }
    else
    {
        [self showNoNewsMessage];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"FlipNews" message:@"You haven't bookmarked any article yet.Please bookmark articles." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadBookmarks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addObserver
{
    if (![self observerAdded])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flipViewControllerDidFinishAnimatingNotification:) name:MPFlipViewControllerDidFinishAnimatingNotification object:nil];
        [self setObserverAdded:YES];
    }
}

- (void)removeObserver
{
    if ([self observerAdded])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPFlipViewControllerDidFinishAnimatingNotification object:nil];
        [self setObserverAdded:NO];
    }
}
- (BookmarksContentViewController *)contentViewWithIndex:(int)index
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        
       //         return nil;
    }
    
    // Create a new view controller and pass suitable data.
    BookmarksContentViewController *page = [storyboard instantiateViewControllerWithIdentifier:CONTENT_IDENTIFIER];
    page.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //page.newsArticleImage = [NSString stringWithFormat:@"%@",self.pageImage[index]];
    page.newsArticleHeading = self.pageTitles[index];
    page.newsArticlePublishedDate = self.pagePublishDate[index];
    page.newsArticleMoreLink = self.pageMoreLink[index];
    page.newsIndex = index;
    
    return page;
}
#pragma mark - MPFlipViewControllerDelegate protocol

- (void)flipViewController:(MPFlipViewController *)flipViewController didFinishAnimating:(BOOL)finished previousViewController:(UIViewController *)previousViewController transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        self.previousIndex = self.tentativeIndex;
    }
}

- (MPFlipViewControllerOrientation)flipViewController:(MPFlipViewController *)flipViewController orientationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationIsPortrait(orientation)? MPFlipViewControllerOrientationVertical : MPFlipViewControllerOrientationHorizontal;
    else
        return MPFlipViewControllerOrientationHorizontal;
}

#pragma mark - MPFlipViewControllerDataSource protocol

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int index = self.previousIndex;
    index--;
    if (index < PAGE_MIN)
        return nil; // reached beginning, don't wrap
    self.tentativeIndex = index;
    return [self contentViewWithIndex:index];
}

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index = self.previousIndex;
    index++;
    if (index > [bookmarksArray count]-1)
        return nil; // reached end, don't wrap
    self.tentativeIndex = index;
    return [self contentViewWithIndex:index];
}

#pragma mark - Notifications

- (void)flipViewControllerDidFinishAnimatingNotification:(NSNotification *)notification
{
    NSLog(@"Notification received: %@", notification);
}

#pragma mark Helper-Custom methods
-(void) allocInits
{
    bookmarksArray = [[NSMutableArray alloc] init];
    _pageTitles = [[NSMutableArray alloc] init];
    _pagePublishDate = [[NSMutableArray alloc] init];
    _pageImage = [[NSMutableArray alloc] init];
    _pageMoreLink = [[NSMutableArray alloc] init];
}

-(void) initMenuBar
{
    mySWRViewController * revealViewController = (mySWRViewController *) self.revealViewController;
    
    if (revealViewController) {
        [_menuButton setTarget:self.revealViewController];
        [_menuButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}
-(void) loadBookmarks
{
    [self allocInits];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docDirectory = [paths objectAtIndex:0];
    NSString * bookmarksFilePath = [NSString stringWithFormat:@"%@",[docDirectory stringByAppendingPathComponent:@"bookmarks"]]; // BookmarksFile
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:bookmarksFilePath])
    {
        bookmarksArray = [[NSMutableArray alloc] initWithContentsOfFile:bookmarksFilePath];
        //NSLog(@"bookmarksArray:\n%@", bookmarksArray);
        
        
        for (int i = 0; i < [bookmarksArray count]; i++) {
            NSDictionary * tempDict = [NSDictionary dictionaryWithDictionary:[bookmarksArray objectAtIndex:i]];
            //NSLog(@"tempDict%d = %@",i,tempDict);
            //Static
            /*
            [_pageImage addObject:[tempDict valueForKey:@"articleImage"]];
            [_pageTitles addObject:[tempDict valueForKey:@"articleHeading"]];
            [_pagePublishDate addObject:[tempDict valueForKey:@"articlePublishDate"]];
            [_pageMoreLink addObject:[tempDict valueForKey:@"articleMoreLink"]];
             */
            //Live
            [_pageTitles addObject:[tempDict valueForKey:@"title"]];
            [_pagePublishDate addObject:[tempDict valueForKey:@"pubDate"]];
            [_pageMoreLink addObject:[tempDict valueForKey:@"link"]];
        }
        _bookmarksAvailable = YES;
    }
    else
    {
        _bookmarksAvailable = NO;
    }
    
}
-(void) setupFlipViewController
{
    self.flipViewController = [[MPFlipViewController alloc] initWithOrientation:[self flipViewController:nil orientationForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation]];
    self.flipViewController.delegate = self;
    self.flipViewController.dataSource = self;
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    BOOL hasFrame = self.frame != nil;
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        pageViewRect = CGRectInset(pageViewRect, 10 + (hasFrame? FRAME_MARGIN : 0), 10 + (hasFrame? FRAME_MARGIN : 0));
        self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    else
    {
        pageViewRect = CGRectMake((self.view.bounds.size.width - 600)/2, (self.view.bounds.size.height - 600)/2, 600, 600);
        self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    self.flipViewController.view.frame = pageViewRect;
    [self addChildViewController:self.flipViewController];
    [self.view addSubview:self.flipViewController.view];
    [self.flipViewController didMoveToParentViewController:self];
    
    [self.flipViewController setViewController:[self contentViewWithIndex:self.previousIndex] direction:MPFlipViewControllerDirectionForward animated:NO completion:nil];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.flipViewController.gestureRecognizers;
    self.previousIndex = PAGE_MIN;
}
-(void) showNoNewsMessage
{
    UILabel * message = [[UILabel alloc] initWithFrame:self.view.frame];
    message.numberOfLines = 2;
    message.textColor = [UIColor darkGrayColor];
    message.textAlignment = NSTextAlignmentCenter;
    message.backgroundColor = appBackgroundColor;
    message.text = @"No bookmarked articles found.\n Please bookmark articles.";
    if (_bookmarksAvailable == YES) {
        message.hidden = YES;
    }
    else
    {
        message.hidden = NO;
    }
    [self.view addSubview:message];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
