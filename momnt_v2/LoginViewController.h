//
//  LoginViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/10/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *viewNo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;


@end
