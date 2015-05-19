//
//  TestCaptureViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestDetectViewController.h"
#import "DisplayOptionsTableController.h"
#import "Locater.h"
#import "ServerCalls.h"
#import "RCImage.h"
#import "AddFriendViewController.h"
#import "StagingViewController.h"
#import "User.h"
#import "TestCaptureViewController.h"
#import "ActivateFriendsViewController.h"

@interface TestCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_captureSession;
    UIImageView *_imageView;
}

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (strong, nonatomic) IBOutlet UIButton *ReverseCameraButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *LogOffButton;
@property (strong, nonatomic) IBOutlet UIButton *SeeButton;
@property (nonatomic, strong) UIImage *capturedImage;
@property (strong, nonatomic) IBOutlet UIButton *CaptureButton;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *RCImagesArray;
@property (strong, nonatomic) NSMutableArray *facesArray;
@property (strong, nonatomic) NSMutableArray *imagesLocation;
@property (strong, nonatomic) NSMutableArray *namesArray;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) IBOutlet UIButton *chooseFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *AddFriendButton;
@property (strong, nonatomic) IBOutlet UIButton *StagingButton;
@property (strong, nonatomic) RCImage *currentImage;
@property UIActivityIndicatorView *spinner;

- (IBAction)logOff:(id)sender;
- (IBAction)reverseCamera:(id)sender;
- (IBAction)seePictures:(id)sender;
- (IBAction)chooseFriends:(id)sender;

@property NSString *path;
@property NSString *camera_side;
@property ServerCalls *client;
@property int activeCamera;

- (void) initCapture;
- (IBAction) captureNow:(id)sender;
- (RCImage*) markFaces:(RCImage *)facePicture;
- (IBAction) addFriend:(id)sender;
- (IBAction) shareNow:(id)sender;

@end
