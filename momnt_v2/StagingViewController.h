//
//  StagingViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareImgCell.h"
#import "RCImage.h"
#import "faceButton.h"
#import "FriendList.h"
#import "ServerCalls.h"
#import "Activations.h"
#import "UnsignedActivation.h"

@interface StagingViewController : UITableViewController

@property NSMutableArray *imageArray;
@property ServerCalls *client;

- (void) faceClicked:(id)sender;

@end
