//
//  Tweet.h
//  Twitter
//
//  Created by Taco Chang on 2015/6/30.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
