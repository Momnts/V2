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
    self.inputFriend.font = [UIFont boldSystemFontOfSize:15.0f];
    self.inputFriend.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"Input Friend's Username" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor] }];
    self.inputFriend.borderStyle = UITextBorderStyleRoundedRect;
    self.inputFriend.layer.borderWidth = 2.0f;
    self.inputFriend.layer.borderColor = [[UIColor blackColor] CGColor];
    self.inputFriend.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputFriend.returnKeyType = UIReturnKeyDone;
    self.inputFriend.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.inputFriend.tag = 1;
    self.inputFriend.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.inputFriend.delegate = self;
    self.inputFriend.backgroundColor = [UIColor clearColor];
    
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
        NSLog(@"friend needing to be added is %@", self.inputFriend.text);
        [self.client addFriend:self.userName toUser:self.inputFriend.text];
        
        [self.view endEditing:YES];
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
@end
