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
#import "NewViewController.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource, NewViewControllerDelegate, TweetCellDelegate, MenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
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
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self getHomeTimeline];
}

- (void)getHomeTimeline {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = [[NSMutableArray alloc] initWithArray:tweets];
        [self.tableView reloadData];
    }];
}

- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self getHomeTimeline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [User logout];
}

- (IBAction)onNew:(id)sender {
    [self presentViewController:[[NewViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.delegate movePanelToOriginalPosition];
}

- (IBAction)onDrag:(UIPanGestureRecognizer *)sender {
    [self.delegate movePanelRight];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    cell.tweet = [self.tweets objectAtIndex:indexPath.row];
    [cell didLoad];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - NewViewControllerDelegate

- (void)NewViewController:(NewViewController *)NewViewController tweet:(Tweet *)tweet {

}

#pragma mark - TweetCellDelegate

- (void)TweetCell:(TweetCell *)cell replyTweet:(Tweet *)tweet {
    NewViewController *vc = [[NewViewController alloc] init];
    vc.replyTweet = tweet;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)TweetCell:(TweetCell *)cell retweet:(Tweet *)tweet {
    [[TwitterClient sharedInstance] retweetWithId:tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [cell.retweetButton setImage:[UIImage imageNamed:@"retweetOnIcon"] forState:UIControlStateNormal];
        }
        else {
            NSLog(@"retweet Error: %@", error);
        }
    }];
}

- (void)TweetCell:(TweetCell *)cell favoriteTweet:(Tweet *)tweet {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tweet.idStr forKey:@"id"];
    [[TwitterClient sharedInstance] favoriteWithParams:params completion:^(Tweet *tweet, NSError *error) {
        
        if (error == nil) {
            [cell.favoriteButton setImage:[UIImage imageNamed:@"starOnIcon"] forState:UIControlStateNormal];
        }
        else {
            NSLog(@"favorite Error: %@", error);
        }
    }];
}

- (void)TweetCell:(TweetCell *)cell userProfile:(User *)user {
    ProfileViewController * profileVC = [[ProfileViewController alloc] init];
    profileVC.user = user;
    [self presentViewController:profileVC animated:YES completion:nil];
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
