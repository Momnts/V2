//
//  TrainCaptureViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "TrainCaptureViewController.h"

@interface TrainCaptureViewController ()

@end

@implementation TrainCaptureViewController

BOOL take_video;
int current_no;

- (void)viewDidLoad {
    [super viewDidLoad];

    take_video = false;
    current_no = 0;
    self.imagesArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.CalibrateButton.layer.cornerRadius = 30;
    self.CalibrateButton.layer.borderWidth = 5;
    self.CalibrateButton.layer.borderColor = self.CalibrateButton.currentTitleColor.CGColor;
    self.CalibrateButton.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.imageView = nil;
    self.progressView.progress = 0;
    
    [self initCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cap3dNow:(id)sender {
    
    if (!take_video)
    {
        take_video = true;
        self.CalibrateButton.layer.backgroundColor = [UIColor redColor].CGColor;
        self.calibrateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
    }
    else
    {
        take_video = false;
        self.CalibrateButton.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self performSegueWithIdentifier:@"SeeFaces" sender:nil];
    }
}

- (void)updateUI:(NSTimer *)timer
{
    static int count =0; count++;
    
    if (count <=500)
    {
        self.progressView.progress = (float)count/500.0f;
    } else
    {
        [self.calibrateTimer invalidate];
        self.calibrateTimer = nil;
        take_video = false;
        self.CalibrateButton.layer.backgroundColor = nil;
        [self prepareArrayForSegue];
        
    } 
}

-(void) prepareArrayForSegue
{
    int end = (int)self.imagesArray.count;
    int mid = floor(end/2);
    
    NSLog(@"end is %d", end-2);
    self.imagesArrayEdited = [[NSMutableArray alloc] init];
    [self.imagesArrayEdited addObject:[self.imagesArray objectAtIndex:2]];
     NSLog(@"start");
    [self.imagesArrayEdited addObject:[self.imagesArray objectAtIndex:mid]];
     NSLog(@"mid");
    [self.imagesArrayEdited addObject:[self.imagesArray objectAtIndex:(end-4)]];
     NSLog(@"end");
    
    [self performSegueWithIdentifier:@"SeeFaces" sender:nil];
}

- (IBAction)calibrateNow:(id)sender {
    [self performSegueWithIdentifier:@"TrainCaptured" sender:nil];
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

- (void)initCapture {
    
    AVCaptureDevice *captureDevice = [self frontFacingCameraIfAvailable];
    
    if([captureDevice isTorchModeSupported:AVCaptureTorchModeOn]) {
        [captureDevice lockForConfiguration:nil];
        //configure frame rate
        [captureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, 1)];
        [captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, 1)];
        [captureDevice unlockForConfiguration];
    }
    
    /*We setup the input*/
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                          deviceInputWithDevice:captureDevice
                                          error:nil];
    /*We setupt the output*/
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    /*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
     If you don't want this behaviour set the property to NO */
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    /*We specify a minimum duration for each frame (play with this settings to avoid having too many frames waiting
     in the queue because it can cause memory issues). It is similar to the inverse of the maximum framerate.
     In this example we set a min frame duration of 1/10 seconds so a maximum framerate of 10fps. We say that
     we are not able to process more than 10 frames per second.*/
    //captureOutput.minFrameDuration = CMTimeMake(1, 3);
    
    //captureDevice.activeVideoMaxFrameDuration = CMTimeMake(1,3);
    //captureDevice.activeVideoMinFrameDuration = CMTimeMake(1,3);
    
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
    self.imageView.frame = self.view.bounds; //CGRectMake(0, 0, 300, 400);
    //[self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, (self.view.bounds.size.height/2))];                //setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    
    /*We start the capture*/
    [self.captureSession startRunning];
    
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
        
        //Add to array if take_video is true
        
    self.capturedImage= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
        
        if (take_video == true)
        {
            current_no++;
        
            UIImage* pic_to_add = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
            
            [self.imagesArray addObject:pic_to_add];
            
            NSLog(@"taking video");
        }
        
        
        
        /*We relase the CGImageRef*/
        CGImageRelease(newImage);
        //self.imageView.image = image;
        
        [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:self.capturedImage waitUntilDone:YES];
        
        /*We unlock the  image buffer*/
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    }

}

- (void)viewDidUnload {
    self.imageView = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SeeFaces"])
    {
        NSLog(@"number is %@", self.number);
        TrainFaceViewController *TFVC = [segue destinationViewController];
        [TFVC setCapturedImage:self.capturedImage];
        [TFVC setImagesArray:self.imagesArrayEdited];
        [TFVC setEmail:self.email];
        [TFVC setName:self.name];
        [TFVC setNumber:self.number];
        [TFVC setPassword:self.password];
        [TFVC setUserID:self.userID];
    }
    if ([[segue identifier] isEqualToString:@"TrainCaptured"])
    {
        TrainSaveViewController *TSVC = [segue destinationViewController];
        [TSVC setCapturedImage:self.capturedImage];
    }
}


@end
