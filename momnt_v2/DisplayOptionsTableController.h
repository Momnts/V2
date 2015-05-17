//
//  DisplayOptionsTableController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/15/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCalls.h"
#import "User.h"
#import "AllPicsViewController.h"

@interface DisplayOptionsTableController : UITableViewController <ServerCallsDelegate>

@property NSArray *allDisplayOptions;
@property ServerCalls *client;
@property User *user;
@property NSMutableArray *allImagesLocation;
@property NSMutableArray *recepientsImagesLocation;
@property NSMutableArray *imInImagesLocation;
@property NSMutableArray *passOverLocations;

@end
