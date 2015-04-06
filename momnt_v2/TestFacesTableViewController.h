//
//  TestFacesTableViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestFacesTableViewCell.h"

@interface TestFacesTableViewController : UITableViewController <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *faces;
@property (strong, nonatomic) NSMutableArray *numbers;
@property (strong, nonatomic) UIImage *capturedImage;

@end
