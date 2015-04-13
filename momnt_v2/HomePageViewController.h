//
//  HomePageViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/9/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface HomePageViewController : UIViewController

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;


@end
