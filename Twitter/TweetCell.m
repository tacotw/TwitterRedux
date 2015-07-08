//
//  TweetCell.m
//  Twitter
//
//  Created by Taco Chang on 2015/6/30.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "TweetCell.h"
#import "NewViewController.h"
#import <UIImageView+AFNetworking.h>

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)didLoad {
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.contentLabel.text = self.tweet.text;
    [self.retweetButton setImage:[UIImage imageNamed:(self.tweet.retweeted) ? @"retweetOnIcon" : @"retweetIcon"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:(self.tweet.favorited) ? @"starOnIcon" : @"starIcon"] forState:UIControlStateNormal];
    
    NSDate *now = [NSDate date];
    NSTimeInterval secondsBetween = [now timeIntervalSinceDate:self.tweet.createdAt];
    int numberOfHours = secondsBetween / 3600;
    if (numberOfHours < 24) {
        int numberOfMins = secondsBetween / 60;
        if (numberOfMins == 0) {
            self.createdAtLabel.text = [NSString stringWithFormat:@"%dm", (int)secondsBetween];
        }
        else if (numberOfMins < 60) {
            self.createdAtLabel.text = [NSString stringWithFormat:@"%dm", numberOfMins];
        }
        else {
            self.createdAtLabel.text = [NSString stringWithFormat:@"%dh", numberOfHours];
        }
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"y/m/d";
        self.createdAtLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReply:(id)sender {
    [self.delegate TweetCell:self replyTweet:self.tweet];
}

- (IBAction)onRetweet:(id)sender {
    [self.delegate TweetCell:self retweet:self.tweet];
}

- (IBAction)onFavorite:(id)sender {
    [self.delegate TweetCell:self favoriteTweet:self.tweet];
}

- (IBAction)onTapProfileImage:(UITapGestureRecognizer *)sender {
    [self.delegate TweetCell:self userProfile:self.tweet.user];
}

@end
