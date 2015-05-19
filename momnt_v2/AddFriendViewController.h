//
//  AddFriendViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCalls.h"
#import "User.h"

@interface AddFriendViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *AddUserButon;
@property (strong, nonatomic) IBOutlet UIButton *AddEmailButton;

@property (strong, nonatomic) IBOutlet UITextField *inputFriend;
- (IBAction)addFriend:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *inputEmail;
- (IBAction)addEmail:(id)sender;

@property ServerCalls *client;
@property NSString *userName;


@end
