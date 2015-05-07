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

@interface StagingViewController : UITableViewController

@property NSMutableArray *imageArray;
- (void) faceClicked:(id)sender;

@end
