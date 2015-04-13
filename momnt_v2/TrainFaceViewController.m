//
//  TrainFaceViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/7/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "TrainFaceViewController.h"

@interface TrainFaceViewController ()

@end

@implementation TrainFaceViewController

bool pic_sent;
bool info_sent;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = false;
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(sendEnroll:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.hidesBackButton = YES;
    pic_sent = false;
    info_sent = false;
    
    [KairosSDK initWithAppId:@"1bf095ad" appKey:@"64b5e29cf8484c0d25d61467b4da7558"];
}

-(void) sendEnroll:(id) sender{
    //NSLog(@"Sending Email (sendEmailFunction");
    
    ServerCalls *client = [[ServerCalls alloc] init];
    client.delegate = self;
    
    [client train_image:[self.imagesArray objectAtIndex:1] file_name:@"test.jpg" person_id:self.number];

    [client signup:self.name withSecurity:self.password withEmail:self.email withNumber:self.number];
    //[self performSegueWithIdentifier:@"saveProfile" sender:nil];
}

-(void)client:(ServerCalls *)ServerCalls sendWithData:(NSDictionary *)responseObject {
    NSLog(@"object is %@", [responseObject objectForKey:@"transaction"]);
    NSString *success = [[responseObject objectForKey:@"transaction"] objectForKey:@"success"];
    if([success caseInsensitiveCompare:@"success"] == NSOrderedSame )
    {
        pic_sent = true;
        [self successCalibration];
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

-(void) client:(ServerCalls *) serverCalls sendLoginSuccess:(NSDictionary*) responseObject
{
    NSLog(@"object inside sendLoginSuccess is %@", [responseObject objectForKey:@"success"]);
    int success = [[responseObject objectForKey:@"success"] intValue];
    if(success==1)
    {
        info_sent = true;
        [self successCalibration];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your profile has not been saved"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void) successCalibration
{
    if(pic_sent && info_sent)
    {
        
        //Getting Path
        
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
        
        //Updating Login Info
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: self.path];
        
        //here add elements to data file and write data to file
        int loggedIn= 1;
        
        [data setObject:[NSNumber numberWithInt:loggedIn] forKey:@"loggedIn"];
        
        [data writeToFile: self.path atomically:YES];
        
        
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome"
                                                    message:@"Your profile has been saved! Click OK to use Momnts."
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FaceViewCell";
    TrainFaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[TrainFaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    long row = [indexPath row];
    [cell.faceView setImage:[self.imagesArray objectAtIndex:row]];
    [cell setBackgroundColor:[UIColor blackColor]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"saveProfile"])
    {
        NSLog(@"number is %@", self.number);
        TrainSaveViewController *TSVC = [segue destinationViewController];
        [TSVC setCapturedImage:self.capturedImage];
        [TSVC setPassword:self.password];
        [TSVC setNumber:self.number];
        [TSVC setName:self.name];
        [TSVC setEmail:self.email];
        [TSVC setFaceArray:self.imagesArray];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
