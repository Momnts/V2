//
//  TrainSaveViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCalls.h"
#import "HomeViewController.h"

@interface TrainSaveViewController : UIViewController<ServerCallsDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) NSMutableArray *faceArray;
@property (strong, nonatomic) IBOutlet UITextField *PersonIdentifier;
@property (strong, nonatomic) IBOutlet UIButton *RememberButton;

- (void) loadImage;
- (IBAction)rememberNow:(id)sender;
@property NSString *name;
@property NSString *number;
@property NSString *email;
@property NSString *password;
@property NSString *repassword;

@end
