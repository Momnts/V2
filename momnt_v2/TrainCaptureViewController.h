//
//  TrainCaptureViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainSaveViewController.h"
#import "TrainFaceViewController.h"

@interface TrainCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_captureSession;
    UIImageView *_imageView;
}

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *capturedImage;
@property  (strong, nonatomic) NSMutableArray *imagesArray;
@property  (strong, nonatomic) NSMutableArray *imagesArrayEdited;
@property (strong, nonatomic) IBOutlet UIButton *ThreeDButton;
@property (strong, nonatomic) IBOutlet UIButton *CalibrateButton;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *calibrateTimer;

- (IBAction)cap3dNow:(id)sender;
- (IBAction)calibrateNow:(id)sender;
- (void)initCapture;

@property NSString *name;
@property NSString *number;
@property NSString *email;
@property NSString *password;
@property NSString *repassword;

@end
