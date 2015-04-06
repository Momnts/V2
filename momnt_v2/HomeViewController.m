//
//  HomeViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.CalibrateButton.layer.cornerRadius = 12;
    self.CalibrateButton.layer.borderWidth = 2;
    self.CalibrateButton.layer.borderColor = self.CalibrateButton.currentTitleColor.CGColor;
    //self.CalibrateButton.layer.backgroundColor = [UIColor lightTextColor].CGColor;
    self.CaptureButton.layer.cornerRadius = 12;
    self.CaptureButton.layer.borderWidth = 2;
    self.CaptureButton.layer.borderColor = self.CalibrateButton.currentTitleColor.CGColor;
    //self.CaptureButton.layer.backgroundColor = [UIColor lightTextColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goToCalibrate:(id)sender {
    [self performSegueWithIdentifier:@"calibrateNow" sender:nil];
}

- (IBAction)goToCapture:(id)sender {
    [self performSegueWithIdentifier:@"captureNow" sender:nil];
}
@end
