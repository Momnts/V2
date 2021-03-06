//
//  SignUpViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/11/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCaptureViewController.h"
#import "ServerCalls.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate, ServerCallsDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *numberField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *repasswordField;
@property (strong, nonatomic) IBOutlet UISwitch *youCool;
@property (strong, nonatomic) IBOutlet UIButton *NextButton;
@property (strong, nonatomic) ServerCalls *client;
- (IBAction)calibrateFace:(id)sender;

@property NSString *name;
@property NSString *number;
@property NSString *email;
@property NSString *password;
@property NSString *repassword;
@property NSString *userID;



@end
