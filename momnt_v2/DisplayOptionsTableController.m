//
//  DisplayOptionsTableController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/15/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "DisplayOptionsTableController.h"

@interface DisplayOptionsTableController ()

@end

@implementation DisplayOptionsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.allDisplayOptions = @[@"My Images", @"Photo Inbox", @"Photos I'm In"];
    [self.tableView reloadData];
    
    self.client = [[ServerCalls alloc] init];
    self.client.delegate = self;
    self.allImagesLocation = [[NSMutableArray alloc] init];
    self.user = [User currentUser];
    
    [self.client get_pics:[self.user returnUserID] withUserName:[self.user returnUserName] startIndex:1 endIndex:10];
    [self.client get_recepientPics:[self.user returnUserID] withUserName:[self.user returnUserName] startIndex:1 endIndex:10];
    //[self.client get_imInPics:[self.user returnUserID] withUserName:[self.user returnUserName] startIndex:1 endIndex:10];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) client:(ServerCalls *) serverCalls sendWithData:(NSDictionary *)responseObject
{
    //NSLog(@"object inside sendLoginSuccess is %@", [responseObject objectAtIndex:0]);
    //int success = [[responseObject objectForKey:@"success"] intValue];
    
    //NSDictionary *response = [responseObject objectAtIndex:0];
    
    NSString *success = [responseObject objectForKey:@"success"]; //:@"status"];
    self.allImagesLocation = [responseObject objectForKey:@"locationList"];
    if([success intValue] == 1)
    {
        NSLog(@"Just got my pictures!");
        [self.tableView reloadData];
        //[self performSegueWithIdentifier:@"SeePictures" sender:nil];
    }
}
-(void) client:(ServerCalls *) serverCalls sendWithRecepientData:(NSDictionary *)responseObject
{
    //NSLog(@"object inside sendLoginSuccess is %@", [responseObject objectAtIndex:0]);
    //int success = [[responseObject objectForKey:@"success"] intValue];
    
    //NSDictionary *response = [responseObject objectAtIndex:0];
    
    NSString *success = [responseObject objectForKey:@"success"]; //:@"status"];
    self.recepientsImagesLocation = [responseObject objectForKey:@"locationList"];
    if([success intValue] == 1)
    {
        NSLog(@"Just got recepients pictures!");
        [self.tableView reloadData];
        //[self performSegueWithIdentifier:@"SeePictures" sender:nil];
    }
}
-(void) client:(ServerCalls *) serverCalls sendWithImInData:(NSDictionary *)responseObject
{
    //NSLog(@"object inside sendLoginSuccess is %@", [responseObject objectAtIndex:0]);
    //int success = [[responseObject objectForKey:@"success"] intValue];
    
    //NSDictionary *response = [responseObject objectAtIndex:0];
    
    NSString *success = [responseObject objectForKey:@"success"]; //:@"status"];
    self.imInImagesLocation = [responseObject objectForKey:@"locationList"];
    if([success intValue] == 1)
    {
        NSLog(@"Just got Im in pictures!");
        [self.tableView reloadData];
        //[self performSegueWithIdentifier:@"SeePictures" sender:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// Return the number of rows in the section.
    return self.allDisplayOptions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCell" forIndexPath:indexPath];
    
    long row = [indexPath row];
    cell.textLabel.text = [self.allDisplayOptions objectAtIndex:row];
    
    UIButton  *receivedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    receivedButton.tag = [indexPath row];
    [receivedButton setTitle:@"" forState:UIControlStateNormal];
    [receivedButton addTarget:self
                     action:nil
           forControlEvents:UIControlEventTouchDown];
    receivedButton.frame = CGRectMake(350, 8, 20, 20);
    receivedButton.layer.cornerRadius = 10;
    receivedButton.layer.borderWidth = 2;
    receivedButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //[activeButton setBackgroundColor:[UIColor clearColor]];
    
    if(row == 0)
    {
        if(!self.allImagesLocation.count == 0)
        {
            [receivedButton setBackgroundColor:[UIColor greenColor]];
        }
        else
        {
            [receivedButton setBackgroundColor:[UIColor redColor]];
        }
    }
    else if(row == 1)
    {
        if(!self.recepientsImagesLocation.count == 0)
        {
            [receivedButton setBackgroundColor:[UIColor greenColor]];
        }
        else
        {
            [receivedButton setBackgroundColor:[UIColor redColor]];
        }
    }
    else if(row == 2)
    {
        if(!self.imInImagesLocation.count == 0)
        {
            [receivedButton setBackgroundColor:[UIColor greenColor]];
        }
        else
        {
            [receivedButton setBackgroundColor:[UIColor redColor]];
        }
    }
    
    
    [cell addSubview:receivedButton];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = [indexPath row];
    if(row == 0)
        self.passOverLocations = self.allImagesLocation;
    else if(row == 1)
        self.passOverLocations = self.recepientsImagesLocation;
    else if(row == 2)
        self.passOverLocations = self.imInImagesLocation;
    
    if(!self.passOverLocations.count == 0)
        [self performSegueWithIdentifier:@"MyImages" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"MyImages"])
    {
         AllPicsViewController *APVC = [segue destinationViewController];;
         NSLog(@"Inside displaycontroller image count is %lu", (unsigned long)self.passOverLocations.count);
        [APVC setImagesLocation:self.passOverLocations];
    }
    
}


@end
