//
//  LoginViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/10/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = [UIImage imageNamed:self.imageFile];
    //self.imageView.contentMode = UIViewContentModeScaleToFill;
    //self.imageView.clipsToBounds = YES;
    self.viewNo.text = self.titleText;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
