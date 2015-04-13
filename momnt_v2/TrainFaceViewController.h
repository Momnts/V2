//
//  TrainFaceViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/7/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainFaceTableViewCell.h"
#import "TrainSaveViewController.h"
#import "ServerCalls.h"


@interface TrainFaceViewController : UITableViewController <ServerCallsDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray* imagesArray;
@property (nonatomic, strong) UIImage* capturedImage;

@property NSString *name;
@property NSString *number;
@property NSString *email;
@property NSString *password;
@property NSString *repassword;
@property NSString *path;

@end
