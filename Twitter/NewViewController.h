//
//  NewViewController.h
//  Twitter
//
//  Created by Taco Chang on 2015/7/1.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class NewViewController;

@protocol NewViewControllerDelegate <NSObject>

- (void)NewViewController:(NewViewController *)NewViewController tweet:(Tweet *)tweet;

@end

@interface NewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UILabel *canEditingLengthLabel;

@property (nonatomic, weak) id<NewViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *replyTweet;

@end
