//
//  MenuViewController.m
//  Twitter
//
//  Created by Taco Chang on 2015/7/7.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "MenuViewController.h"
#import "User.h"
#import "MenuCell.h"
#import "ProfileViewController.h"
#import <UIImageView+AFNetworking.h>

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menus;
@property (nonatomic, strong) User *user;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.user = [User currentUser];
    self.menus = @[self.user.name, @"Home Timeline", @"Mentions Timeline"];
    
    self.menus = @[
                   @{@"title" : self.user.name,
                     @"image" : self.user.profileImageUrl},
                   @{@"title" : @"Home Timeline",
                     @"image" : @"homeIcon"},
                   @{@"title" : @"Mentions Timeline",
                     @"image" : @"atIcon"}
                  ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = self.user.name;
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    }
    else {
        cell.titleLabel.text = self.menus[indexPath.row][@"title"];
        cell.iconImageView.image = [UIImage imageNamed:self.menus[indexPath.row][@"image"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
            [self presentViewController:[[ProfileViewController alloc] init] animated:YES completion:nil];
            break;
        case 1:
            [self.delegate showHomeTimeline];
            break;
        case 2:
            [self.delegate showMentionsTimeline];
            break;
            
        default:
            break;
    }
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
