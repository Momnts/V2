//
//  AddFriendViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.inputFriend.backgroundColor = [UIColor clearColor];
    self.inputFriend.textColor = [UIColor blackColor];
    //self.inputFriend.font = [UIFont boldSystemFontOfSize:15.0f];
    self.inputFriend.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"Input Username to Add" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor] }];
    self.inputFriend.borderStyle = UITextBorderStyleRoundedRect;
    self.inputFriend.layer.borderWidth = 0.5f;
    self.inputFriend.layer.borderColor = [[UIColor blackColor] CGColor];
    self.inputFriend.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputFriend.returnKeyType = UIReturnKeyDone;
    self.inputFriend.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.inputFriend.tag = 1;
    self.inputFriend.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.inputFriend.delegate = self;
    self.inputFriend.backgroundColor = [UIColor clearColor];
    self.inputFriend.layer.cornerRadius = 10;
    
    self.inputEmail.backgroundColor = [UIColor clearColor];
    self.inputEmail.textColor = [UIColor blackColor];
    //self.inputEmail.font = [UIFont boldSystemFontOfSize:15.0f];
    self.inputEmail.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"Input Email to Add" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor] }];
    self.inputEmail.borderStyle = UITextBorderStyleRoundedRect;
    self.inputEmail.layer.borderWidth = 0.5f;
    self.inputEmail.layer.borderColor = [[UIColor blackColor] CGColor];
    self.inputEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputEmail.returnKeyType = UIReturnKeyDone;
    self.inputEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.inputEmail.tag = 2;
    self.inputEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.inputEmail.delegate = self;
    self.inputEmail.backgroundColor = [UIColor clearColor];
    self.inputEmail.layer.cornerRadius = 10;
    
    self.AddUserButon.layer.cornerRadius = 10;
    self.AddUserButon.layer.borderWidth = 2;
    self.AddUserButon.layer.borderColor = [UIColor colorWithRed:34.0/255.0 green:192.0f/255.0 blue:100.0/255.0 alpha:1].CGColor;
    self.AddUserButon.backgroundColor = [UIColor colorWithRed:34.0f/255.0 green:192.0f/255.0 blue:100/255.0 alpha:1];
    [self.AddUserButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.AddEmailButton.layer.cornerRadius = 10;
    self.AddEmailButton.layer.borderWidth = 2;
    self.AddEmailButton.layer.borderColor = [UIColor colorWithRed:34.0/255.0 green:192.0f/255.0 blue:100.0/255.0 alpha:1].CGColor;
    self.AddEmailButton.backgroundColor = [UIColor colorWithRed:34.0f/255.0 green:192.0f/255.0 blue:100/255.0 alpha:1];
    [self.AddEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.client = [[ServerCalls alloc] init];
    self.client.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {
        [textField resignFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)client:(ServerCalls *)serverCalls sendFriendSuccess:(NSDictionary *)responseObject {
    int success = [[responseObject objectForKey:@"success"] intValue];
    
    //NSString *userId = [responseObject objectForKey:@"userId"];
    //NSString *userName = [responseObject objectForKey:@"userName"];
    if(success == 1)
    {
        [[User currentUser] updateFriendsList];
         self.inputFriend.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"You have added a new friend"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(success == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Login In"
                                                        message:@"No User Found"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addFriend:(id)sender {
    
    if ([self.inputFriend.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No User Input"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"friend needing to be added is %@", self.inputFriend.text);
        [self.client addFriend:self.userName toUser:self.inputFriend.text];
    }
}
- (IBAction)addEmail:(id)sender {
    
    
    if ([self.inputEmail.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Email Input"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"friend needing to be added is %@", self.inputEmail.text);
         [[User currentUser] addEmailRecepient:self.inputEmail.text];
        self.inputEmail.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"You have added a new email"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
