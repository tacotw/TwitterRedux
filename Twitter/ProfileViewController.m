//
//  ProfileViewController.m
//  Twitter
//
//  Created by Taco Chang on 2015/7/8.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import <UIImageView+AFNetworking.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *followering;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.user == nil) {
        [[TwitterClient sharedInstance] userProfile:nil completion:^(User *user, NSError *error) {
        }];
        self.user = [User currentUser];
    }
    
    [self.bgImageView setImageWithURL:[NSURL URLWithString:self.user.bgImageUrl]];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.tweetsCount.text = [NSString stringWithFormat:@"%ld", self.user.tweetsCount];
    self.followingCount.text = [NSString stringWithFormat:@"%ld", self.user.followingCount];
    self.followering.text = [NSString stringWithFormat:@"%ld", self.user.followersCount];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
