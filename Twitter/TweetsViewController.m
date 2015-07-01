//
//  TweetsViewController.m
//  Twitter
//
//  Created by Taco Chang on 2015/6/30.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        //self.tweets = [NSMutableArray array];
        self.tweets = [[NSMutableArray alloc] initWithArray:tweets];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [User logout];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    [cell.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    cell.nameLabel.text = tweet.user.name;
    cell.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cell.contentLabel.text = tweet.text;
    
    NSDate *now = [NSDate date];
    NSTimeInterval secondsBetween = [now timeIntervalSinceDate:tweet.createdAt];
    int numberOfHours = secondsBetween / 3600;
    if (numberOfHours < 24) {
        int numberOfMins = secondsBetween / 60;
        if (numberOfMins == 0) {
            cell.createdAtLabel.text = [NSString stringWithFormat:@"%dm", (int)secondsBetween];
        }
        else if (numberOfMins < 60) {
            cell.createdAtLabel.text = [NSString stringWithFormat:@"%dm", numberOfMins];
        }
        else {
            cell.createdAtLabel.text = [NSString stringWithFormat:@"%dh", numberOfHours];
        }
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"y/m/d";
        cell.createdAtLabel.text = [formatter stringFromDate:tweet.createdAt];
    }
    
    return cell;
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
