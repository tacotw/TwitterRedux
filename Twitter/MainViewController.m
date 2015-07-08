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

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

#define CORNER_RADIUS 4

@interface MainViewController () <TweetsViewControllerDelegate>

@property (strong, nonatomic) TweetsViewController *tweetsVC;
@property (nonatomic, strong) MenuViewController *menuVC;
@property (nonatomic, assign) BOOL showingLeftPanel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView {
    self.tweetsVC = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
    self.tweetsVC.view.tag = CENTER_TAG;
    self.tweetsVC.delegate = self;
    [self.view addSubview:self.tweetsVC.view];
    [self addChildViewController:self.tweetsVC];
    [self.tweetsVC didMoveToParentViewController:self];
    
    //[self setupGestures];
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
        //self.menuVC.delegate = self.tweetsVC;
        
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

-(void)movePanelRight {
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tweetsVC.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    completion:^(BOOL finished) {
        if (finished) {
            self.tweetsVC.view.tag = 0;
        }
    }];
}

-(void)movePanelToOriginalPosition {
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tweetsVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    completion:^(BOOL finished) {
        if (finished) {
            //[self resetMainView];
        }
    }];
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
