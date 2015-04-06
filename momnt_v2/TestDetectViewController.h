//
//  FaceDetectViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCalls.h"
#import "TestFacesTableViewController.h"

@interface TestDetectViewController : UIViewController<ServerCallsDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) NSMutableArray *faces;
@property (strong, nonatomic) NSMutableArray *numbers;

-(void) loadImage;
-(void) detectFaces;
-(void) recognizeFaces;


@end
