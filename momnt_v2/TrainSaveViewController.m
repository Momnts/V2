//
//  TrainSaveViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "TrainSaveViewController.h"

@interface TrainSaveViewController ()

@end

@implementation TrainSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    /*
    // Add button
    self.view.backgroundColor = [UIColor whiteColor];
    self.RememberButton.layer.cornerRadius = 12;
    self.RememberButton.layer.borderWidth = 2;
    self.RememberButton.layer.borderColor = self.RememberButton.currentTitleColor.CGColor;//[UIColor darkGrayColor].CGColor;
    //self.RememberButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    // Add text field
    self.PersonIdentifier.backgroundColor = [UIColor whiteColor];
    self.PersonIdentifier.textColor = [UIColor redColor];
    self.PersonIdentifier.font = [UIFont systemFontOfSize:14.0f];
    self.PersonIdentifier.borderStyle = UITextBorderStyleRoundedRect;
    self.PersonIdentifier.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.PersonIdentifier.returnKeyType = UIReturnKeyDone;
    self.PersonIdentifier.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.PersonIdentifier.tag = 1;
    self.PersonIdentifier.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.imageView = nil;
    
    [self loadImage];
     */
    
   [KairosSDK initWithAppId:@"1bf095ad" appKey:@"64b5e29cf8484c0d25d61467b4da7558"];
    
    ServerCalls *client = [[ServerCalls alloc] init];
    client.delegate = self;
    
    [client train_image:[self.faceArray objectAtIndex:1] file_name:@"test.jpg" person_id:self.number];
    //[client train_image:[self.faceArray objectAtIndex:1] file_name:@"test.jpg" person_id:self.number];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
*/
/*
- (void) loadImage
{

    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, 300, 400);
    [self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, (self.view.bounds.size.height/2)-30)];
    self.imageView.image = self.capturedImage;
    [self.view addSubview:self.imageView];
}

- (IBAction)rememberNow:(id)sender {
    
}
*/

-(void)client:(ServerCalls *)ServerCalls sendWithData:(NSDictionary *)responseObject {
    NSLog(@"object is %@", [responseObject objectForKey:@"transaction"]);
    NSString *success = [[responseObject objectForKey:@"transaction"] objectForKey:@"success"];
    if([success caseInsensitiveCompare:@"success"] == NSOrderedSame )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome"
                                                        message:@"Your profile has been saved! Click OK to use Momnts."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"One More Time..."
                                                        message:@"Face calibration failed."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex==0)
    {
        [self performSegueWithIdentifier:@"goHome" sender:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"goHome"])
    {
        HomeViewController *HC = [segue destinationViewController];
    }
}
@end
