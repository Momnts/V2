//
//  TestCaptureViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestDetectViewController.h"


@interface TestCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_captureSession;
    UIImageView *_imageView;
}

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (strong, nonatomic) IBOutlet UIButton *ReverseCameraButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *capturedImage;
@property (strong, nonatomic) IBOutlet UIButton *CaptureButton;
- (IBAction)logOff:(id)sender;
- (IBAction)reverseCamera:(id)sender;

@property NSString *path;
@property NSString *camera_side;

- (void)initCapture;
- (IBAction)captureNow:(id)sender;

@end
