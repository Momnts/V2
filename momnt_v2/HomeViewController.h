//
//  HomeViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ServerCalls.h"
#import "SignUpViewController.h"

@interface HomeViewController : UIViewController <ServerCallsDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *CaptureButton;
@property (strong, nonatomic) IBOutlet UIButton *CalibrateButton;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)goToSignUp:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property NSString *email_str;
@property NSString *password_str;
@property NSString *path;

@end
