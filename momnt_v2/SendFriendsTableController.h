//
//  SendFriendsTableController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/13/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "SendFriendTableCell.h"
#import "ActivateButton.h"
#import "Activations.h"

@interface SendFriendsTableController : UITableView <UITableViewDataSource, UITableViewDelegate>

@property User *currentUser;
@property NSMutableArray *friendsList;
@property NSMutableArray *activeFriends;

@end
