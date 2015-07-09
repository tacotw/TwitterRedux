//
//  MenuViewController.h
//  Twitter
//
//  Created by Taco Chang on 2015/7/7.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

- (void)showHomeTimeline;
- (void)showMentionsTimeline;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, assign) id<MenuViewControllerDelegate> delegate;

@end
