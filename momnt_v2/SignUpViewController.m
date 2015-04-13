//
//  SignUpViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/11/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    //UIGraphicsBeginImageContext(self.view.frame.size);

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"suncity.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    
    
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suncity.jpg"]];
    //backgroundView = [[UIImageView alloc] init];
    //backgroundView.frame = self.view.bounds; //CGRectMake(0, 0, 300, 400);
    //[self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, (self.view.bounds.size.height/2))];                //setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))
    //backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    //[self.view addSubview:backgroundView];
    //[self.view sendSubviewToBack:backgroundView];
    //UIImage* backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    //self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    //self.username.placeholder = @"email";
    self.nameField.backgroundColor = [UIColor clearColor];
    self.nameField.textColor = [UIColor whiteColor];
    self.nameField.font = [UIFont boldSystemFontOfSize:15.0f];
    self.nameField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.layer.borderWidth = 2.0f;
    self.nameField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.returnKeyType = UIReturnKeyDone;
    self.nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameField.tag = 1;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameField.delegate = self;
    self.nameField.backgroundColor = [UIColor clearColor];
    
    //self.username.placeholder = @"email";
    self.numberField.backgroundColor = [UIColor clearColor];
    self.numberField.textColor = [UIColor whiteColor];
    self.numberField.font = [UIFont boldSystemFontOfSize:15.0f];
    self.numberField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    self.numberField.borderStyle = UITextBorderStyleRoundedRect;
    self.numberField.layer.borderWidth = 2.0f;
    self.numberField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.numberField.returnKeyType = UIReturnKeyDone;
    self.numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.numberField.tag = 2;
    self.numberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.numberField.delegate = self;
    self.numberField.backgroundColor = [UIColor clearColor];
    
    self.emailField.backgroundColor = [UIColor clearColor];
    self.emailField.textColor = [UIColor whiteColor];
    self.emailField.font = [UIFont boldSystemFontOfSize:15.0f];
    self.emailField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.layer.borderWidth = 2.0f;
    self.emailField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.returnKeyType = UIReturnKeyDone;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailField.tag = 3;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.delegate = self;
    self.emailField.backgroundColor = [UIColor clearColor];
    
    self.passwordField.backgroundColor = [UIColor clearColor];
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.font = [UIFont boldSystemFontOfSize:15.0f];
    self.passwordField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.layer.borderWidth = 2.0f;
    self.passwordField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.tag = 4;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.delegate = self;
    self.passwordField.backgroundColor = [UIColor clearColor];
    
    self.repasswordField.backgroundColor = [UIColor clearColor];
    self.repasswordField.textColor = [UIColor whiteColor];
    self.repasswordField.font = [UIFont boldSystemFontOfSize:15.0f];
    self.repasswordField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"re-type password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    self.repasswordField.borderStyle = UITextBorderStyleRoundedRect;
    self.repasswordField.layer.borderWidth = 2.0f;
    self.repasswordField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.repasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.repasswordField.returnKeyType = UIReturnKeyDone;
    self.repasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.repasswordField.tag = 5;
    self.repasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.repasswordField.delegate = self;
    self.repasswordField.backgroundColor = [UIColor clearColor];
    
    self.NextButton.layer.cornerRadius = 2;
    self.NextButton.layer.borderWidth = 2;
    self.NextButton.layer.borderColor = self.NextButton.currentTitleColor.CGColor;
    //self.CaptureButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)calibrateFace:(id)sender {
    
    self.name = self.nameField.text;
    self.number = self.numberField.text;
    self.email = self.emailField.text;
    self.password = self.passwordField.text;
    self.repassword = self.repasswordField.text;
    
    NSLog(@"password is %@ and repassword is %@", self.password, self.repassword);
    if(![self.password isEqualToString:self.repassword])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Password inputs do not match. Please input!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    else
    {
        [self performSegueWithIdentifier:@"calibrateFace" sender:nil];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        
        if ([[segue identifier] isEqualToString:@"calibrateFace"])
        {
            NSLog(@"number is %@", self.number);
            TrainCaptureViewController *TCVC = [segue destinationViewController];
            [TCVC setName:self.name];
            [TCVC setNumber:self.number];
            [TCVC setEmail:self.email];
            [TCVC setPassword:self.password];
        }
    
}
@end
