//
//  MainViewController.m
//  Twitter
//
//  Created by Taco Chang on 2015/7/7.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "MainViewController.h"
#import "TweetsViewController.h"
#import "MenuViewController.h"

#define HOME_TWEETS_TAG 1
#define MENTIONS_TWEETS_TAG 2
#define LEFT_PANEL_TAG 3

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

#define CORNER_RADIUS 4

@interface MainViewController () <TweetsViewControllerDelegate, MenuViewControllerDelegate>

@property (strong, nonatomic) TweetsViewController *tweetsVC;
@property (strong, nonatomic) TweetsViewController *homeTweetsVC;
@property (strong, nonatomic) TweetsViewController *mentionsTweetsVC;
@property (nonatomic, strong) MenuViewController *menuVC;
@property (nonatomic, assign) BOOL showingLeftPanel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
        self.tweetsVC = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
        self.tweetsVC.pageType = HOME_TWEETS_TAG;
        self.tweetsVC.view.tag = HOME_TWEETS_TAG;
        self.tweetsVC.delegate = self;
        [self.view addSubview:self.tweetsVC.view];
        [self addChildViewController:self.tweetsVC];
        [self.tweetsVC didMoveToParentViewController:self];
    //[self getVCByPageType:HOME_TWEETS_TAG];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [self.tweetsVC.view.layer setCornerRadius:CORNER_RADIUS];
        [self.tweetsVC.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.tweetsVC.view.layer setShadowOpacity:0.8];
        [self.tweetsVC.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    } else {
        [self.tweetsVC.view.layer setCornerRadius:0.0f];
        [self.tweetsVC.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

-(UIView *)getLeftView {
    // init view if it doesn't already exist
    if (self.menuVC == nil)
    {
        // this is where you define the view for the left panel
        self.menuVC = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        self.menuVC.view.tag = LEFT_PANEL_TAG;
        self.menuVC.delegate = self;
        
        [self.view addSubview:self.menuVC.view];
        
        [self addChildViewController:self.menuVC];
        [self.menuVC didMoveToParentViewController:self];
        
        self.menuVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    // setup view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.menuVC.view;
    return view;
}

-(TweetsViewController *)getVCByPageType:(NSInteger)pageType {
    if (pageType == HOME_TWEETS_TAG) {
        if (self.homeTweetsVC == nil) {
            self.homeTweetsVC = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
            self.homeTweetsVC.pageType = HOME_TWEETS_TAG;
            self.homeTweetsVC.view.tag = HOME_TWEETS_TAG;
            self.homeTweetsVC.delegate = self;
            [self.view addSubview:self.homeTweetsVC.view];
            [self addChildViewController:self.homeTweetsVC];
            [self.homeTweetsVC didMoveToParentViewController:self];
        }
        return self.homeTweetsVC;
    }
    else if (pageType == MENTIONS_TWEETS_TAG) {
        if (self.mentionsTweetsVC == nil) {
            self.mentionsTweetsVC = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
            self.mentionsTweetsVC.pageType = MENTIONS_TWEETS_TAG;
            self.mentionsTweetsVC.view.tag = MENTIONS_TWEETS_TAG;
            self.mentionsTweetsVC.delegate = self;
            
            [self.view addSubview:self.mentionsTweetsVC.view];
            [self addChildViewController:self.mentionsTweetsVC];
            [self.mentionsTweetsVC didMoveToParentViewController:self];
        }
        return self.mentionsTweetsVC;
    }
    
    return self.homeTweetsVC;
}

-(void)movePanelRight:(NSInteger)pageType {
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    self.tweetsVC.pageType = pageType;
//    TweetsViewController *tweetsVC = [self getVCByPageType:pageType];
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tweetsVC.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    completion:^(BOOL finished) {
        if (finished) {
            self.tweetsVC.view.tag = 0;
        }
    }];
}

-(void)movePanelToOriginalPosition:(NSInteger)pageType isReload:(BOOL)isReload {
    self.tweetsVC.pageType = pageType;
    if (isReload) {
        [self.tweetsVC reloadView];
    }
    //TweetsViewController *tweetsVC = [self getVCByPageType:pageType];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tweetsVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    completion:^(BOOL finished) {
        if (finished) {
            /*if (self.menuVC != nil) {
                [self.menuVC.view removeFromSuperview];
                self.menuVC = nil;
                tweetsVC.view.tag = 1;
                self.showingLeftPanel = NO;
            }*/
        }
    }];
}

#pragma mark - MenuViewControllerDelegate

- (void)showHomeTimeline {
    [self movePanelToOriginalPosition:HOME_TWEETS_TAG isReload:YES];
}

- (void)showMentionsTimeline {
    [self movePanelToOriginalPosition:MENTIONS_TWEETS_TAG isReload:YES];
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
