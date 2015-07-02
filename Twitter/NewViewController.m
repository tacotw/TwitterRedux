//
//  NewViewController.m
//  Twitter
//
//  Created by Taco Chang on 2015/7/1.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "NewViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>

NSUInteger const kCanEditingMaxLength = 140;

@interface NewViewController () <UITextViewDelegate>

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentText.delegate = self;
    
    User *user = [User currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenName;
    if (self.replyTweet != nil) {
        self.contentText.text = [NSString stringWithFormat:@"@%@ ", self.replyTweet.user.screenName];
    }
    [self.contentText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTweet:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.contentText.text forKey:@"status"];
    
    if (self.replyTweet != nil) {
        [params setObject:self.replyTweet.idStr forKey:@"in_reply_to_status_id"];
    }
    
    [[TwitterClient sharedInstance] newWithParams:params completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [self.delegate NewViewController:self tweet:tweet];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = self.contentText.text.length + text.length - range.length;
    return (newLength > kCanEditingMaxLength) ? NO : YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSUInteger canEditinglength = kCanEditingMaxLength - self.contentText.text.length;
    self.canEditingLengthLabel.text = [NSString stringWithFormat:@"%lu", canEditinglength];
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
