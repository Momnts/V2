//
//  ActivateFriendsViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/15/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendFriendsTableController.h"
#import "TestCaptureViewController.h"
#import "User.h"
#import "SendFriendTableCell.h"
#import "ActivateButton.h"
//#import "Activations.h"
//#import "UnsignedActivation.h"

@class Activations;
@class UnsignedActivation;

@interface ActivateFriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *ListFriendsView;
@property (strong, nonatomic) IBOutlet UISwitch *activateFRButton;
@property (strong, nonatomic) IBOutlet UIButton *CameraButton;
@property (strong, nonatomic) IBOutlet UILabel *FRLabl;
@property (strong, nonatomic) IBOutlet UIButton *addNewContact;

- (IBAction)goBack:(id)sender;
- (IBAction)FRActivated:(id)sender;
- (IBAction)addingContact:(id)sender;



@property User *currentUser;
@property NSMutableArray *friendsList;
@property NSMutableArray *activeFriends;
@property NSMutableArray *activeEmails;

@end
