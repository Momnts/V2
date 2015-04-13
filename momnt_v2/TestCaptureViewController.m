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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.CaptureButton.layer.cornerRadius = 30;
    self.CaptureButton.layer.borderWidth = 5;
    self.CaptureButton.layer.borderColor = self.CaptureButton.currentTitleColor.CGColor;
    
    self.ReverseCameraButton.layer.cornerRadius = 30;
    self.ReverseCameraButton.layer.borderWidth = 5;
    self.ReverseCameraButton.layer.borderColor = [UIColor clearColor].CGColor;
    UIImage *backgroundImage = [UIImage imageNamed:@"rotate_camera.png"];
    [self.ReverseCameraButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    self.CaptureButton.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.imageView = nil;
    self.camera_side = @"back";
    [self initCapture:self.camera_side];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOff:(id)sender {
    
    //Getting Path
    
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
    
    //Updating Login Info
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: self.path];
    
    //here add elements to data file and write data to file
    int loggedIn= 0;
    
    [data setObject:[NSNumber numberWithInt:loggedIn] forKey:@"loggedIn"];
    
    [data writeToFile: self.path atomically:YES];
    
    [self performSegueWithIdentifier:@"backToLogin" sender:nil];

}

- (IBAction)reverseCamera:(id)sender {
    
    /*
    
    if([self.camera_side isEqualToString:@"front"])
    {
        self.camera_side = @"back";
    }
    else
    {
        self.camera_side = @"front";
        //NSLog(@"changing camera to front");
    }
    
    [self initCapture:self.camera_side];
    */
    
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
        NSLog(@"changing camera to back");
        captureInput = [AVCaptureDeviceInput
                                          deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]
                                          error:nil];
    }
    else
    {
        NSLog(@"changing camera to front");
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
    [self performSegueWithIdentifier:@"detectFaces" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"detectFaces"])
    {
        TestDetectViewController *TDVC = [segue destinationViewController];
        [TDVC setCapturedImage:self.capturedImage];
    }
}
@end
