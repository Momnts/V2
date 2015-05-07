//
//  FriendList.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/5/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendCell.h"
#import "User.h"
#import "ShareImgCell.h"

@interface FriendList : UITableView <UITableViewDelegate, UITableViewDataSource>

-(instancetype)initWithFrame:(CGRect)frame image:(NSInteger)intg withFace:(NSInteger)fintg;

@property NSArray *names;
@property NSInteger imageNo;
@property NSInteger faceNo;

@end
