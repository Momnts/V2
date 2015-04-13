//
//  HomeViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //////////////////////////////////////////////////////////////////////////////////////////////
    
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
    
    int loggedIn;
    loggedIn = [[savedProf objectForKey:@"loggedIn"] intValue];
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    //If previously logged in, go to home page
    if (loggedIn == 1)
    {
         [self performSegueWithIdentifier:@"goHome" sender:nil];
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.navigationController setNavigationBarHidden:YES];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"momnts_signin.jpg"] drawInRect:self.view.bounds];
    UIImage* backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    //self.username.placeholder = @"email";
    self.username.backgroundColor = [UIColor clearColor];
    self.username.textColor = [UIColor whiteColor];
    self.username.font = [UIFont boldSystemFontOfSize:15.0f];
    self.username.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    self.username.borderStyle = UITextBorderStyleRoundedRect;
    self.username.layer.borderWidth = 2.0f;
    self.username.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.username.returnKeyType = UIReturnKeyDone;
    self.username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.username.tag = 1;
    self.username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.username.delegate = self;
    self.username.backgroundColor = [UIColor clearColor];
    
    //self.password.placeholder = @"password";
    self.password.backgroundColor = [UIColor clearColor];
    self.password.textColor = [UIColor whiteColor];
    self.password.font = [UIFont boldSystemFontOfSize:15.0f];
    self.password.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    self.password.borderStyle = UITextBorderStyleRoundedRect;
    self.password.layer.borderWidth = 2.0f;
    self.password.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.returnKeyType = UIReturnKeyDone;
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password.tag = 2;
    self.password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password.delegate = self;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    if (textField.tag == 1) {
        //UITextField *emailTextField = (UITextField *)[self.view viewWithTag:1];
        NSLog(@"email is %@", self.username.text);
        self.email_str = self.username.text;
        [self.view endEditing:YES];
    }
    if (textField.tag == 2) {
        //UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [@"0800 444 333" stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.password_str = [self.password.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.email_str = [self.username.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        ServerCalls *client = [[ServerCalls alloc] init];
        client.delegate = self;
        [self.view endEditing:YES];
        //[self performSegueWithIdentifier:@"goHome" sender:nil];
        NSLog(@"email is %@", self.email_str);
        NSLog(@"password is %@", self.password_str);
        
        
        [client login:self.email_str withSecurity:self.password_str];
    }
    
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)client:(ServerCalls *)serverCalls sendLoginSuccess:(NSDictionary *)responseObject {
    int success = [[responseObject objectForKey:@"success"] intValue];
    if(success == 1)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: self.path];
        
        //here add elements to data file and write data to file
        int loggedIn= 1;
        
        [data setObject:[NSNumber numberWithInt:loggedIn] forKey:@"loggedIn"];
        
        [data writeToFile: self.path atomically:YES];
        
        [self performSegueWithIdentifier:@"goHome" sender:nil];
    }

 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToSignUp:(id)sender {
    [self performSegueWithIdentifier:@"signUp" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"signUp"])
    {
        SignUpViewController *SUVC = [segue destinationViewController];
    }
}


@end
