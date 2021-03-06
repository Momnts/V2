//
//  TestCaptureViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "TestCaptureViewController.h"

@interface TestCaptureViewController ()

@end

@implementation TestCaptureViewController

// return true if the device has a retina display, false otherwise
#define IS_RETINA_DISPLAY() [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f

// return the scale value based on device's display (2 retina, 1 other)
#define DISPLAY_SCALE IS_RETINA_DISPLAY() ? 2.0f : 1.0f

// if the device has a retina display return the real scaled pixel size, otherwise the same size will be returned
#define PIXEL_SIZE(size) IS_RETINA_DISPLAY() ? CGSizeMake(size.width/2.0f, size.height/2.0f) : size


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.CaptureButton.layer.cornerRadius = 40;
    self.CaptureButton.layer.borderWidth = 5;
    self.CaptureButton.layer.borderColor = self.CaptureButton.currentTitleColor.CGColor;
    self.CaptureButton.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    self.ReverseCameraButton.layer.cornerRadius = 30;
    self.ReverseCameraButton.layer.borderWidth = 5;
    self.ReverseCameraButton.layer.borderColor = [UIColor clearColor].CGColor;
    UIImage *backgroundImage = [UIImage imageNamed:@"appbar.refresh.png"];
    [self.ReverseCameraButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    //<div>Icon made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed under <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>
    self.LogOffButton.layer.cornerRadius = 30;
    self.LogOffButton.layer.borderWidth = 5;
    self.LogOffButton.layer.borderColor = [UIColor clearColor].CGColor;
    UIImage *backgroundImage_logOff = [UIImage imageNamed:@"appbar.power.png"];
    [self.LogOffButton setBackgroundImage:backgroundImage_logOff forState:UIControlStateNormal];
    
    //<div>Icon made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed under <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>
    self.SeeButton.layer.cornerRadius = 30;
    self.SeeButton.layer.borderWidth = 5;
    self.SeeButton.layer.borderColor = [UIColor clearColor].CGColor;
    UIImage *backgroundImage_seeImage = [UIImage imageNamed:@"appbar.image.multiple.png"];
    [self.SeeButton setBackgroundImage:backgroundImage_seeImage forState:UIControlStateNormal];
    
    self.AddFriendButton.layer.cornerRadius = 30;
    self.AddFriendButton.layer.borderWidth = 5;
    self.AddFriendButton.layer.borderColor = [UIColor clearColor].CGColor;
    UIImage *backgroundImage_addFriend = [UIImage imageNamed:@"appbar.user.add.png"];
    [self.AddFriendButton setBackgroundImage:backgroundImage_addFriend forState:UIControlStateNormal];
    
    self.StagingButton.layer.cornerRadius = 30;
    self.StagingButton.layer.borderWidth = 5;
    self.StagingButton.layer.borderColor = [UIColor clearColor].CGColor;
    UIImage *backgroundImage_staging = [UIImage imageNamed:@"appbar.rocket.rotated.45.png"];
    [self.StagingButton setBackgroundImage:backgroundImage_staging forState:UIControlStateNormal];
    
    self.chooseFriendsButton.layer.cornerRadius = 30;
    self.chooseFriendsButton.layer.borderWidth = 5;
    self.chooseFriendsButton.layer.borderColor = [UIColor clearColor].CGColor;
    [self.chooseFriendsButton setTitle:@"" forState:UIControlStateNormal];
    UIImage *backgroundImage_chooseFriends = [UIImage imageNamed:@"logo_transparent.png"];
    [self.chooseFriendsButton setBackgroundImage:backgroundImage_chooseFriends forState:UIControlStateNormal];
    
    self.imageView = nil;
    self.camera_side = @"back";
    self.imagesArray = [[NSMutableArray alloc] init];
    self.RCImagesArray = [[NSMutableArray alloc] init];
    self.namesArray = [[NSMutableArray alloc] init];
    [self initCapture:self.camera_side];
    
    //Getting Plist directory
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.path = [documentsDirectory stringByAppendingPathComponent:@"currentUser.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: self.path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"currentUser" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: self.path error:&error];
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    //Checking to see login by reading pList data
    NSMutableDictionary *savedProf = [[NSMutableDictionary alloc] initWithContentsOfFile: self.path];
    self.userId = [savedProf objectForKey:@"userId"];
    self.userName = [savedProf objectForKey:@"userName"];
    
    NSLog(@"USER ID IS %@", self.userId);
    
    //COMMENT THIS OUT
    [[Locater sharedLocater] initLocater:self.userId];
    [[Locater sharedLocater] startUpdating];
    
    self.client = [[ServerCalls alloc] init];
    self.client.delegate = self;
    [[User currentUser] initUser:self.userName initID:self.userId];
    [[User currentUser] activateFR];
    
    self.activeCamera = TRUE;
    //NSMutableDictionary *latAndLong = [[Locater sharedLocater] returnLatAndLong];
    //NSString *lat = [latAndLong objectForKey:@"lat"];
    //NSString *lng =[latAndLong objectForKey:@"lng"];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)]; // I do this because I'm in landscape mode
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOff:(id)sender {
    
    //Updating Logout Info
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: self.path];
    
    //here add elements to data file and write data to file
    int loggedIn= 0;
    
    [data setObject:[NSNumber numberWithInt:loggedIn] forKey:@"loggedIn"];
    [data setObject:@"0" forKey:@"userId"];
    [data setObject:@"" forKey:@"userName"];
    
    [data writeToFile: self.path atomically:YES];
    
    [self performSegueWithIdentifier:@"backToLogin" sender:nil];

}

- (IBAction)reverseCamera:(id)sender {
    
    //Change camera source
    if(_captureSession)
    {
        //Indicate that some changes will be made to the session
        [_captureSession beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [_captureSession.inputs objectAtIndex:0];
        [_captureSession removeInput:currentCameraInput];
        
        //Get new input
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        NSError *err = nil;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
        if(!newVideoInput || err)
        {
            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
        }
        else
        {
            [_captureSession addInput:newVideoInput];
        }
        
        //Commit all the configuration changes at once
        [_captureSession commitConfiguration];
    }
}

- (IBAction)seePictures:(id)sender {
    NSLog(@"about to see pictures");
    [self performSegueWithIdentifier:@"SeePictures" sender:nil];
    //[self.client get_pics:self.userId withUserName:self.userName startIndex:1 endIndex:10];
}

- (IBAction)chooseFriends:(id)sender {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition
                                                    forKey:kCATransition];
    ActivateFriendsViewController *AFVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivateFriendsView"];;
    [self.navigationController pushViewController:AFVC animated:NO];
    
    
     //[self performSegueWithIdentifier:@"activateFriends" sender:nil];
}

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

- (void)initCapture:(NSString*)camera_side {
    
    AVCaptureDeviceInput *captureInput;
    
    if([camera_side isEqualToString:@"back"])
    {
    /*We setup the input*/
        captureInput = [AVCaptureDeviceInput
                                          deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]
                                          error:nil];
    }
    else
    {
        captureInput = [AVCaptureDeviceInput
                        deviceInputWithDevice:[self frontFacingCameraIfAvailable]
                        error:nil];
    }
    
    //AVCaptureDevice *captureDevice = [self frontFacingCameraIfAvailable];
    
    /*
    if([captureDevice isTorchModeSupported:AVCaptureTorchModeOn]) {
        [captureDevice lockForConfiguration:nil];
        //configure frame rate
        [captureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, 1)];
        [captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, 1)];
        [captureDevice unlockForConfiguration];
    }
    */
    
    /*We setupt the output*/
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    /*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
     If you don't want this behaviour set the property to NO */
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    /*We specify a minimum duration for each frame (play with this settings to avoid having too many frames waiting
     in the queue because it can cause memory issues). It is similar to the inverse of the maximum framerate.
     In this example we set a min frame duration of 1/10 seconds so a maximum framerate of 10fps. We say that
     we are not able to process more than 10 frames per second.*/
    //captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    /*We create a serial queue to handle the processing of our frames*/
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    //dispatch_release(queue); ARC manages this for us
    // Set the video output to store frame in BGRA (It is supposed to be faster)
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    /*And we create a capture session*/
    self.captureSession = [[AVCaptureSession alloc] init];
    
    /*We add input and output*/
    
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    
    /*We use medium quality, ont the iPhone 4 this demo would be laging too much, the conversion in UIImage and CGImage demands too much ressources for a 720p resolution.*/
    [self.captureSession setSessionPreset:AVCaptureSessionPresetMedium];
    
    /*We add the imageView*/
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.view.bounds; //CGRectMake(0, 0, 400, 600); //
    //[self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, (self.view.bounds.size.height/2))];                //setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    
    /*We start the capture*/
    [self.captureSession startRunning];
    
}

-(AVCaptureDevice *)frontFacingCameraIfAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionFront)
        {
            captureDevice = device;
            break;
        }
    }
    
    if ( ! captureDevice)
    {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    /*We create an autorelease pool because as we are not in the main_queue our code is
     not executed in the main thread. So we have to create an autorelease pool for the thread we are in*/
    
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    //Modernized version of NSAutoreleasePool
    @autoreleasepool {
        
        
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        /*Lock the image buffer*/
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        /*Get information about the image*/
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        /*Create a CGImageRef from the CVImageBufferRef*/
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        
        /*We release some components*/
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        /*We display the result on the custom layer. All the display stuff must be done in the main thread because
         UIKit is no thread safe, and as we are not in the main thread (remember we didn't use the main_queue)
         we use performSelectorOnMainThread to call our CALayer and tell it to display the CGImage.*/
        //[self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: (__bridge id) newImage waitUntilDone:YES];
        
        /*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
         Same thing as for the CALayer we are not in the main thread so ...*/
        self.capturedImage= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
        
        /*We relase the CGImageRef*/
        CGImageRelease(newImage);
        //self.imageView.image = image;
        
        [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:self.capturedImage waitUntilDone:YES];
        
        /*We unlock the  image buffer*/
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    }
    //[pool drain];
}

- (void)viewDidUnload {
    self.imageView = nil;
}


- (IBAction)captureNow:(id)sender {
    //NSLog(@"UIImage before scaling is [width, height] is %f, %f", self.capturedImage.size.width, self.capturedImage.size.height);
    
    //UIImage *pic = [[UIImage alloc] initWithCGImage:self.capturedImage.CGImage scale:DISPLAY_SCALE orientation:UIImageOrientationRight];    // UIImageOrientationUp];
    
    //NSLog(@"UIImage after scaling is [width, height] is %f, %f", pic.size.width, pic.size.height);
    if(self.activeCamera)
    {
    dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:nil animations:^{
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                self.CaptureButton.layer.backgroundColor = [UIColor redColor].CGColor;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                self.CaptureButton.layer.backgroundColor = [UIColor clearColor].CGColor;
            }];
        } completion:nil];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            //NSLog(@"detected faces in image");
        });
    });
 
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
   [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    //NSString *currentTime = [dateFormatter stringFromDate:today];
    //[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *currentDate = [dateFormatter stringFromDate:today];
    
    currentDate = [currentDate stringByReplacingOccurrencesOfString:@"/"
                                         withString:@"-"];
    //currentTime = [currentTime stringByReplacingOccurrencesOfString:@"/"
                                                         //withString:@"-"];
    
    //UIImage *resizedImage = self.capturedImage;
    RCImage* capturedImage = [[RCImage alloc] init];
    capturedImage.primaryImage = self.capturedImage;
    NSMutableDictionary *latAndLong = [[Locater sharedLocater] returnLatAndLong];
    capturedImage.takenLat = [latAndLong objectForKey:@"lat"];
    capturedImage.takenLng = [latAndLong objectForKey:@"lng"];
    capturedImage.takenDate = currentDate;
    capturedImage.recipients = [[User currentUser] returnActiveRecepients];
    capturedImage.emailRecipients = [[User currentUser] returnActiveEmailRecepients];
    
    if(![[User currentUser] FRIsActivated])
    {
       self.currentImage = capturedImage;
        [self saveRCImage];
    }
    
    else{
        
        self.activeCamera = false;
        [self.spinner startAnimating];
        //self.CaptureButton.layer.backgroundColor = [UIColor redColor].CGColor;
        
    __block RCImage* detectedImage;
    
    dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //detectedImage = [self markFaces:resizedImage];
        detectedImage = [self markFaces:capturedImage];
        dispatch_async( dispatch_get_main_queue(), ^{
            //NSLog(@"detected faces in image");
        });
    });
    
    /*
    dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self.client take_pics:detectedImage.primaryImage withUserID:self.userId withUserName:self.userName withLat:detectedImage.takenLat withLng:detectedImage.takenLng];
        [self recognizeFaces];
        dispatch_async( dispatch_get_main_queue(), ^{
            NSLog(@"sent picture asynchronously");
        });
    });
    */
    
    NSLog(@"in recognize faces count is %lu", (unsigned long) detectedImage.faces.count);
    if (detectedImage.faces == nil || [detectedImage.faces count] == 0)
    {
        NSLog(@"array is empty");
        self.currentImage = detectedImage;
        [self saveRCImage];
    }
    else
    {
        self.currentImage = detectedImage;
        self.currentImage.recognizedIDs = [NSMutableArray arrayWithCapacity:[detectedImage.faces count]];
        
        //for (int i=0; i< detectedImage.faces.count; i++)
        //{
            [self.client recognize_image:detectedImage.primaryImage file_name:@"test.jpg" index:detectedImage.faces.count];
        //}
    }
    }

    }
    //detectedImage.recognizedIDs = self.namesArray;
    
    //[[[User currentUser] returnStageQueue] addObject:detectedImage];
    
    //[self.client take_pics:resizedImage withUserID:self.userId withUserName:self.userName withLat:lat withLng:lng];
    
    //[self.imagesArray addObject:detectedImage];
    //[self.RCImagesArray addObject:detectedImage];
}

-(void)client:(ServerCalls *)serverCalls sendWithRecognizedNames:(NSMutableArray *)name index:(int)ind {
    /*
    NSLog(@"inside sendWithRecognizedNames index is %d", ind);
    if(name == NULL)
        //[self.currentImage.recognizedIDs insertObject:@"" atIndex:ind];
        [self.currentImage.recognizedIDs addObject:@""];
    else
        [self.currentImage.recognizedIDs addObject:name];
        //[self.currentImage.recognizedIDs insertObject:name atIndex:ind];
    
    if(ind != (self.currentImage.faces.count-1))
    {
        NSLog(@"onto the next person");
        [self.client recognize_image:self.currentImage.faces[ind+1] file_name:@"test.jpg" index:ind+1];
    }
    else //(ind == (self.currentImage.recognizedIDs.count-1))
        [self saveRCImage];
     */
    NSArray* reversedNameArray = [[name reverseObjectEnumerator] allObjects];
    self.currentImage.recognizedIDs = reversedNameArray;
    [self saveRCImage];
}

-(void) saveRCImage
{
    NSLog(@"saving Image");
    [[[User currentUser] returnStageQueue] addObject:self.currentImage];
    self.activeCamera = TRUE;
    [self.spinner stopAnimating];
    //self.CaptureButton.layer.backgroundColor = [UIColor clearColor].CGColor;
}


- (UIImage *)imageByCroppingImage:(UIImage *)image withSize:(CGRect)bounds
{
    //CGRect cropRect = CGRectMake(bounds.origin.x-50, bounds.origin.y-50, bounds.size.width+100, bounds.size.height+100);
    CGRect cropRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);

    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIImage *cropped_rotated = [UIImage imageWithCGImage:cropped.CGImage
                                                   scale:1.0
                                             orientation:UIImageOrientationRight];
    
    return cropped_rotated;
}

- (UIImage *)imageWithRect:(UIImage *)image withSize:(CGRect)bounds
{

    // begin a graphics context of sufficient size
    UIGraphicsBeginImageContext(image.size);
    
    // draw original image into the context
    [image drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // set stroking color and draw circle
    [[UIColor greenColor] setStroke];
    
    // make circle rect 5 px from border
    CGRect circleRect = CGRectMake(bounds.origin.x, bounds.origin.y,
                                   bounds.size.width,
                                   bounds.size.height);
    
    // setting line
    CGContextSetLineWidth(ctx, 4.0);
    
    // draw rect
    CGContextStrokeRect(ctx, circleRect);
    
    // make image out of bitmap context
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // free the context
    UIGraphicsEndImageContext();
    
    return retImage;
}

-(RCImage*) markFaces:(RCImage *)facePicture
{
    int exifOrientation;
   
    switch (facePicture.primaryImage.imageOrientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }

    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.primaryImage.CGImage];
    // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image
                                          options:@{CIDetectorImageOrientation:[NSNumber numberWithInt:exifOrientation]}];
    //NSLog(@"Image [width, height] is %f, %f",facePicture.primaryImage.size.width, facePicture.primaryImage.size.height);
    //self.facesArray = [[NSMutableArray alloc] init];
    facePicture.faces = [[NSMutableArray alloc] init];
    facePicture.facesBoxes = [[NSMutableArray alloc] init];
    
    for(CIFaceFeature* faceFeature in features)
    {
        CGRect rectBound;
        CGFloat x, y, width, height;
        if(exifOrientation == 1)
        {
            x = faceFeature.bounds.origin.x;
            y = facePicture.primaryImage.size.height - faceFeature.bounds.origin.y;
            width = faceFeature.bounds.size.width;
            height = faceFeature.bounds.size.height;
            
            rectBound = CGRectMake(x, y, width, height);
        }
        else if(exifOrientation == 3)
        {
            x = facePicture.primaryImage.size.width - faceFeature.bounds.origin.x;
            y = faceFeature.bounds.origin.y;
            width = faceFeature.bounds.size.width;
            height = faceFeature.bounds.size.height;
            
            rectBound = CGRectMake(x, y, width, height);
        }
        else if(exifOrientation == 8)
        {
            x = facePicture.primaryImage.size.width - faceFeature.bounds.origin.y;
            y = facePicture.primaryImage.size.height - faceFeature.bounds.origin.x;
            width = faceFeature.bounds.size.width;
            height = faceFeature.bounds.size.height;
            
            rectBound = CGRectMake(x, y, width, height);
        }
        else if(exifOrientation == 6)
        {
            x = faceFeature.bounds.origin.y;
            y = faceFeature.bounds.origin.x;
            width = faceFeature.bounds.size.width;
            height = faceFeature.bounds.size.height;
            
            rectBound = CGRectMake(x, y, width, height);
        }
        else if(exifOrientation == 2)
        {
            x = facePicture.primaryImage.size.width - faceFeature.bounds.origin.x;
            y = facePicture.primaryImage.size.height - faceFeature.bounds.origin.y;
            width = faceFeature.bounds.size.width;
            height = faceFeature.bounds.size.height;
            
            rectBound = CGRectMake(x, y, width, height);
        }
        else if(exifOrientation == 4)
        {
            x = faceFeature.bounds.origin.x;
            y = faceFeature.bounds.origin.y;
            width = faceFeature.bounds.size.width;
            height = faceFeature.bounds.size.height;
            
            rectBound = CGRectMake(x, y, width, height);
        }
        else if(exifOrientation == 5)
        {
            x = facePicture.primaryImage.size.width - faceFeature.bounds.origin.y;
            y = faceFeature.bounds.origin.x;
            width = faceFeature.bounds.size.width;
            height = faceFeature.bounds.size.height;
            
            rectBound = CGRectMake(x, y, width, height);
        }
        else if(exifOrientation == 7)
        {
            x = faceFeature.bounds.origin.y;
            y = facePicture.primaryImage.size.height - faceFeature.bounds.origin.x;
            width = faceFeature.bounds.size.width;
            height = faceFeature.bounds.size.height;
            
            rectBound = CGRectMake(x, y, width, height);
        }
        
        
        //[self.facesArray addObject:[self imageByCroppingImage:facePicture.primaryImage withSize:faceFeature.bounds]];
      
        [facePicture.faces addObject:[self imageByCroppingImage:facePicture.primaryImage withSize:faceFeature.bounds]];
        [facePicture.facesBoxes addObject:[NSValue valueWithCGRect:rectBound]];
        //facePicture.primaryImage = [self imageWithRect:facePicture.primaryImage withSize:rectBound];
        
    }
    
    return facePicture;
}
- (void) recognizeFaces
{
    NSLog(@"in recognize faces count is %lu", (unsigned long) self.facesArray.count);
    
    
    
    if (self.facesArray == nil || [self.facesArray count] == 0) {
        NSLog(@"array is empty");
    }
    else
    {
        
        for (int i=0; i< self.facesArray.count; i++)
        {
            [self.client recognize_image:self.facesArray[i] file_name:@"test.jpg" index:i];
        }
    }
}

- (IBAction)addFriend:(id)sender {
     [self performSegueWithIdentifier:@"addFriend" sender:nil];
}

- (IBAction)shareNow:(id)sender {
    
    [self performSegueWithIdentifier:@"shareImages" sender:nil];
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void) client:(ServerCalls *) serverCalls sendLoginPicSuccess:(NSMutableDictionary*) responseObject
{
    //NSLog(@"object inside sendLoginSuccess is %@", [responseObject objectAtIndex:0]);
    //int success = [[responseObject objectForKey:@"success"] intValue];
    
    //NSDictionary *response = [responseObject objectAtIndex:0];
    
    NSString *success = [responseObject objectForKey:@"success"]; //:@"status"];
    if([success intValue] == 1)
    {
        NSLog(@"Just logged picture!");
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"detectFaces"])
    {
        /*
        TestDetectViewController *TDVC = [segue destinationViewController];
        [TDVC setCapturedImage:self.capturedImage];
        [TDVC setFaces:self.facesArray];
        */
        
        TestFacesTableViewController *TFTVC = [segue destinationViewController];
        [TFTVC setFaces:self.facesArray];
    }
    
    else if ([[segue identifier] isEqualToString:@"SeePictures"])
    {
        DisplayOptionsTableController *DOTC = [segue destinationViewController];
        //[APVC setImagesArray:self.imagesArray];
        //[APVC setImagesLocation:self.imagesLocation];
    }
    else if ([[segue identifier] isEqualToString:@"addFriend"])
    {
        AddFriendViewController *AFVC = [segue destinationViewController];
        [AFVC setUserName:self.userName];
    }
    else if ([[segue identifier] isEqualToString:@"shareImages"])
    {
        StagingViewController *SVC = [segue destinationViewController];
        [SVC setImageArray:self.RCImagesArray];
    }
}
@end
