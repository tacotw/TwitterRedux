//
//  TwitterClient.h
//  Twitter
//
//  Created by Taco Chang on 2015/6/29.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)newWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweetWithId:(NSString *)retweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)userProfile:(NSDictionary *)params completion:(void (^)(User *user, NSError *error))completion;

@end
