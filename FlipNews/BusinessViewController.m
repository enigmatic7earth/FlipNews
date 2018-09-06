//
//  BusinessViewController.m
//  FlipNews
//
//  Created by NETBIZ on 13/06/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import "BusinessViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BusinessContentViewController.h"


#define CONTENT_IDENTIFIER @"BusinessContentViewController"
#define FRAME_MARGIN	0 //60
#define PAGE_MIN        0

@interface BusinessViewController ()
@property (nonatomic, strong) NSArray *arrNewsData;
@property (nonatomic) Reachability *internetReachability;


-(void)performNewFetchedDataActionsWithDataArray:(NSArray *)dataArray;

@property (assign, nonatomic) int previousIndex;
@property (assign, nonatomic) int tentativeIndex;
@property (assign, nonatomic) BOOL observerAdded;

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = appBackgroundColor;
    setTitleBarWhiteColor;
    [self allocInits];
    [self initMenuBar];
    //--Set NSUserDefaults--//
    appSettings = [NSUserDefaults standardUserDefaults];
    [appSettings setValue:@"YES" forKey:@"IntroductionDone"];
    [appSettings setValue:@"Business" forKey:@"currentViewController"]; //_PS addition for checking which fetch method to call in Appdelegate
    [appSettings synchronize];
    //--+--//
    //--Load the file that saves news--//
    [self loadNews];
    if (_newsAvailable == YES)
    {
        
        [self setupFlipViewController];
    }
    else
    {
        [self showNoNewsMessage];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"FlipNews" message:@"No new news available." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    //--Reachability--
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    //--+--//
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
    if (index > [newsArray count]-1)
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
    newsArray = [[NSMutableArray alloc] init];
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
-(void) loadNews
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docDirectory = [paths objectAtIndex:0];
    NSString * newsFilePath = [NSString stringWithFormat:@"%@",[docDirectory stringByAppendingPathComponent:@"business"]]; // NewsFile
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:newsFilePath])
    {
        newsArray = [[NSMutableArray alloc] initWithContentsOfFile:newsFilePath];
        //NSLog(@"newsArray:\n%@", newsArray);
        
        
        for (int i = 0; i < [newsArray count]; i++) {
            NSDictionary * tempDict = [NSDictionary dictionaryWithDictionary:[newsArray objectAtIndex:i]];
            //NSLog(@"tempDict%d = %@",i,tempDict);
            
            /* Static data
             [_pageImage addObject:[tempDict valueForKey:@"articleImage"]];
             [_pageTitles addObject:[tempDict valueForKey:@"articleHeading"]];
             [_pagePublishDate addObject:[tempDict valueForKey:@"articlePublishDate"]];
             [_pageMoreLink addObject:[tempDict valueForKey:@"articleMoreLink"]];
             */
            
            [_pageTitles addObject:[tempDict valueForKey:@"title"]];
            [_pagePublishDate addObject:[tempDict valueForKey:@"pubDate"]];
            [_pageMoreLink addObject:[tempDict valueForKey:@"link"]];
        }
        _newsAvailable = YES;
    }
    else
    {
        _newsAvailable = NO;
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
- (BusinessContentViewController *)contentViewWithIndex:(int)index
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        
        //         return nil;
    }
    
    // Create a new view controller and pass suitable data.
    BusinessContentViewController *page = [storyboard instantiateViewControllerWithIdentifier:CONTENT_IDENTIFIER];
    page.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //page.newsArticleImage = [NSString stringWithFormat:@"%@",self.pageImage[index]]; //--Temp Commented
    page.newsArticleHeading = self.pageTitles[index];
    page.newsArticlePublishedDate = self.pagePublishDate[index];
    page.newsArticleMoreLink = self.pageMoreLink[index];
    page.newsIndex = index;
    //NSLog(@"%@\n%@\n%@\n%@",page.newsArticleImage,page.newsArticleHeading,page.newsArticlePublishedDate,page.newsArticleMoreLink);
    return page;
}

-(void) showNoNewsMessage
{
    UILabel * message = [[UILabel alloc] initWithFrame:self.view.frame];
    message.numberOfLines = 2;
    message.textColor = [UIColor darkGrayColor];
    message.textAlignment = NSTextAlignmentCenter;
    message.backgroundColor = appBackgroundColor;
    message.text = @"No news is currently available.\n Please try refershing again.";
    if (_newsAvailable == YES) {
        message.hidden = YES;
    }
    else
    {
        message.hidden = NO;
    }
    [self.view addSubview:message];
}
#pragma mark IBActions
- (IBAction)reloadNews:(UIBarButtonItem *)sender
{
    //Added  MBProcessHUD 31-05-2017_PS
    if (isInternetConnectionAvailable) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
            });
        });
        double delayInSeconds = 1.0;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self refreshData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Internet" message:@"Kindly check your internet connection!\n If it is off,please turn it on and try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //Opening settings app if iOS > = 8.0
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                //Open settings app
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];//
            };
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
#pragma mark Data Fetch methods

-(void)refreshData{
    
    XMLParser *xmlParser = [[XMLParser alloc] initWithXMLURLString:BusinessNewsFeed];
    [xmlParser startParsingWithCompletionHandler:^(BOOL success, NSArray *dataArray, NSError *error) {
        
        if (success) {
            [self performNewFetchedDataActionsWithDataArray:dataArray];
        }
        else{
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
}

-(void)performNewFetchedDataActionsWithDataArray:(NSArray *)dataArray{
    // 1. Initialize the arrNewsData array with the parsed data array.
    if (self.arrNewsData != nil) {
        self.arrNewsData = nil;
    }
    self.arrNewsData = [[NSArray alloc] initWithArray:dataArray];
    
    
    // 2. Write the file and reload the view.
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docDirectory = [paths objectAtIndex:0];
    NSString * newsFilePath = [NSString stringWithFormat:@"%@",[docDirectory stringByAppendingPathComponent:@"business"]]; // NewsFile
    
    if (![self.arrNewsData writeToFile:newsFilePath atomically:YES]) {
        _newsAvailable = NO;
        NSLog(@"Couldn't save data.");
    }
    else
    {
        _newsAvailable = YES;
        NSLog(@"Saved data.");
        [self viewDidLoad]; //--//
    }
}
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    XMLParser *xmlParser = [[XMLParser alloc] initWithXMLURLString:ArtsNewsFeed];
    [xmlParser startParsingWithCompletionHandler:^(BOOL success, NSArray *dataArray, NSError *error) {
        if (success) {
            NSDictionary *latestDataDict = [dataArray objectAtIndex:0];
            NSString *latestTitle = [latestDataDict objectForKey:@"title"];
            
            NSDictionary *existingDataDict = [self.arrNewsData objectAtIndex:0];
            NSString *existingTitle = [existingDataDict objectForKey:@"title"];
            
            if ([latestTitle isEqualToString:existingTitle]) {
                completionHandler(UIBackgroundFetchResultNoData);
                
                NSLog(@"No new data found.");
            }
            else{
                [self performNewFetchedDataActionsWithDataArray:dataArray];
                
                completionHandler(UIBackgroundFetchResultNewData);
                
                NSLog(@"New data was fetched.");
            }
        }
        else{
            completionHandler(UIBackgroundFetchResultFailed);
            
            NSLog(@"Failed to fetch new data.");
        }
    }];
}

#pragma mark Reachability
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == self.internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        NSString* statusString = @"";
        
        //
        UIAlertController * connectivityAlert = [UIAlertController alertControllerWithTitle:@"Connectivity" message:[NSString stringWithFormat:@"Status:%@",statusString] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [connectivityAlert addAction:ok];
        //
        
        switch (netStatus)
        {
            case NotReachable:        {
                statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
                /*
                 Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
                 */
                connectionRequired = NO;
                // alerts added _PS
                connectivityAlert.message = [NSString stringWithFormat:@"Status:%@",statusString];
                [self presentViewController:connectivityAlert animated:YES completion:nil];
                isInternetConnectionAvailable = NO;
                break;
            }
                
            case ReachableViaWWAN:        {
                statusString = NSLocalizedString(@"Reachable WWAN", @"");
                // alerts added _PS
                //                connectivityAlert.message = [NSString stringWithFormat:@"Status:%@",statusString];
                //                [self presentViewController:connectivityAlert animated:YES completion:nil];
                isInternetConnectionAvailable = YES;
                break;
            }
            case ReachableViaWiFi:        {
                statusString= NSLocalizedString(@"Reachable WiFi", @"");
                // alerts added _PS
                //                connectivityAlert.message = [NSString stringWithFormat:@"Status:%@",statusString];
                //                [self presentViewController:connectivityAlert animated:YES completion:nil];
                isInternetConnectionAvailable = YES;
                break;
            }
        }
        
        if (connectionRequired)
        {
            NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
            statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
            // alerts added _PS
            connectivityAlert.message = [NSString stringWithFormat:@"Status:%@",statusString];
            isInternetConnectionAvailable = NO;
            [self presentViewController:connectivityAlert animated:YES completion:nil];
        }
    }
    
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
