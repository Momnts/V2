//
//  FaceDetectViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "TestDetectViewController.h"

@interface TestDetectViewController ()

@end

@implementation TestDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For API Auth. Find a better place to put this.
    [KairosSDK initWithAppId:@"1bf095ad" appKey:@"64b5e29cf8484c0d25d61467b4da7558"];
    
    // Load taken image
    [self loadImage];
    
    // Identify faces
    [self detectFaces];
}

- (void) loadImage
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, 300, 400);
    [self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, (self.view.bounds.size.height/2)-30)];
    self.imageView.image = self.capturedImage;
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) detectFaces
{
    [self performSelectorInBackground:@selector(markFaces:) withObject:self.capturedImage];
    [self.view addSubview:self.imageView];
}
-(void)markFaces:(UIImage *)facePicture
{
    int exifOrientation;
    NSLog(@"face orientation is %ld", facePicture.imageOrientation);
    switch (facePicture.imageOrientation) {
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

    CIImage* image = [CIImage imageWithCGImage:facePicture.CGImage];
    
    //NSLog(@"Inside markFaces size is %f, %f",self.imageView.image.size.width, self.imageView.image.size.height);
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    NSArray* features = [detector featuresInImage:image
                                          options:@{CIDetectorImageOrientation:[NSNumber numberWithInt:exifOrientation]}];
    
    CGFloat imgViewCoeff_width = self.imageView.bounds.size.width/self.capturedImage.size.width;
    CGFloat imgViewCoeff_height = self.imageView.bounds.size.height/self.capturedImage.size.height;
    NSLog(@"number of faces detected is %lu", (unsigned long)features.count);
    
    self.faces = [[NSMutableArray alloc] init];
    self.numbers = [[NSMutableArray alloc] init];
    
    for(CIFaceFeature* faceFeature in features)
    {
        CGRect face_bounds = CGRectMake(faceFeature.bounds.origin.y*imgViewCoeff_height, faceFeature.bounds.origin.x*imgViewCoeff_width, faceFeature.bounds.size.height*imgViewCoeff_height, faceFeature.bounds.size.width*imgViewCoeff_width);
        UIView* faceView = [[UIView alloc] initWithFrame:face_bounds];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        // add the new view to create a box around the face
        [self.imageView addSubview:faceView];
        
        CGRect biggerRectangle = CGRectInset(faceFeature.bounds, -10.0f, -10.0f);
        //CGImageRef imageRef = CGImageCreateWithImageInRect([facePicture CGImage], biggerRectangle);
        
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *returnImage =
        [UIImage imageWithCGImage:[context createCGImage:[CIImage imageWithCGImage:facePicture.CGImage] fromRect:biggerRectangle]
                            scale:1.0
                      orientation:UIImageOrientationRight];
        [self.faces addObject:returnImage];
    }
    
    [self recognizeFaces];
}


- (void) recognizeFaces
{
    ServerCalls *client = [[ServerCalls alloc] init];
    client.delegate = self;
    if (self.faces == nil || [self.faces count] == 0) {
        NSLog(@"array is empty");
        
    }
    
    //COMMENT IT OUT
    //[client recognize_image:self.faces file_name:@"test.jpg"];
}

-(void)client:(ServerCalls *)serverCalls sendWithNames:(NSMutableArray *)names {
    self.numbers = names;
    [self performSegueWithIdentifier:@"showFaces" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showFaces"])
    {
        TestFacesTableViewController *TFTVC = [segue destinationViewController];
        [TFTVC setFaces:self.faces];
        [TFTVC setNumbers:self.numbers];
        [TFTVC setCapturedImage:self.capturedImage];
    }
}



@end
