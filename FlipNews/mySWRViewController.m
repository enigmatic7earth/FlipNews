//
//  mySWRViewController.m
//  FlipNews
//
//  Created by NETBIZ on 14/02/17.
//  Copyright © 2017 Netbiz.in. All rights reserved.
//

#import "mySWRViewController.h"

@interface mySWRViewController ()

@end

@implementation mySWRViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self customizeSlideOutMenu];
}

-(void) customizeSlideOutMenu{
    // INITIAL APPEARANCE: Configure the initial position of the menu and content views
    self.frontViewPosition = FrontViewPositionLeft; // FrontViewPositionLeft (only content), FrontViewPositionRight(menu and content), FrontViewPositionRightMost(only menu), see others at library documentation...
    self.rearViewRevealWidth = 260.0f; // how much of the menu is shown (default 260.0) //150.0
    
    // TOGGLING OVERDRAW: Configure the overdraw appearance of the content view while dragging it
    self.rearViewRevealOverdraw = 0.0f; // how much of an overdraw can occur when dragging further than 'rearViewRevealWidth' (default 60.0)
    self.bounceBackOnOverdraw = NO; // If YES the controller will bounce to the Left position when dragging further than 'rearViewRevealWidth' (default YES)
    
    // TOGGLING MENU DISPLACEMENT: how much displacement is applied to the menu when animating or dragging the content
    self.rearViewRevealDisplacement = 60.0f; // (default 40.0)
    
    // TOGGLING ANIMATION: Configure the animation while the menu gets hidden
    self.toggleAnimationType = SWRevealToggleAnimationTypeSpring; // Animation type (SWRevealToggleAnimationTypeEaseOut or SWRevealToggleAnimationTypeSpring)
    self.toggleAnimationDuration = 1.0f; // Duration for the revealToggle animation (default 0.25)
    self.springDampingRatio = 1.0f; // damping ratio if SWRevealToggleAnimationTypeSpring (default 1.0)
    
    // SHADOW: Configure the shadow that appears between the menu and content views
    self.frontViewShadowRadius = 10.0f; // radius of the front view's shadow (default 2.5)
    self.frontViewShadowOffset = CGSizeMake(0.0f, 2.5f); // radius of the front view's shadow offset (default {0.0f,2.5f})
    self.frontViewShadowOpacity = 0.8f; // front view's shadow opacity (default 1.0)
    self.frontViewShadowColor = [UIColor darkGrayColor]; // front view's shadow color (default blackColor)
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

@end
