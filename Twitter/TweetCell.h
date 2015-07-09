//
//  TweetCell.h
//  Twitter
//
//  Created by Taco Chang on 2015/6/30.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)TweetCell:(TweetCell *)cell replyTweet:(Tweet *)tweet;
- (void)TweetCell:(TweetCell *)cell retweet:(Tweet *)tweet;
- (void)TweetCell:(TweetCell *)cell favoriteTweet:(Tweet *)tweet;
- (void)TweetCell:(TweetCell *)cell userProfile:(User *)user;

@end

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) id<TweetCellDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;

- (void)didLoad;

@end
