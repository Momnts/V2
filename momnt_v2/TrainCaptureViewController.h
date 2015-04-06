//
//  TrainCaptureViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainSaveViewController.h"

@interface TrainCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_captureSession;
    UIImageView *_imageView;
}

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *capturedImage;

@property (strong, nonatomic) IBOutlet UIButton *CalibrateButton;

- (IBAction)calibrateNow:(id)sender;
- (void)initCapture;

@end
