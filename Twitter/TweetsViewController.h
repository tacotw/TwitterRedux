//
//  TweetsViewController.h
//  Twitter
//
//  Created by Taco Chang on 2015/6/30.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TweetsViewController;

@protocol TweetsViewControllerDelegate <NSObject>

- (void)movePanelRight;

- (void)movePanelToOriginalPosition;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, assign) id<TweetsViewControllerDelegate> delegate;

@end
