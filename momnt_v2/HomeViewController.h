//
//  HomeViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *CaptureButton;
@property (strong, nonatomic) IBOutlet UIButton *CalibrateButton;
- (IBAction)goToCalibrate:(id)sender;
- (IBAction)goToCapture:(id)sender;

@end
