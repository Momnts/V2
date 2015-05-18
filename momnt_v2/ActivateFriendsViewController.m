//
//  ActivateFriendsViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/15/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "ActivateFriendsViewController.h"

@interface ActivateFriendsViewController ()

@end

@implementation ActivateFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"in controller of activate");
    
    //self.view.backgroundColor = [UIColor darkGrayColor];
    self.CameraButton.layer.cornerRadius = 10;
    self.CameraButton.layer.borderWidth = 2;
    self.CameraButton.layer.borderColor = [UIColor greenColor].CGColor;
    self.CameraButton.backgroundColor = [UIColor greenColor];
    
    //self.ListFriendsView = [[SendFriendsTableController alloc] init];
    //CGFloat topLayoutGuide = self.topLayoutGuide.length;
    //self.ListFriendsView.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0);
   
  
    self.ListFriendsView.dataSource = self;
    self.ListFriendsView.delegate = self;
    self.ListFriendsView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.ListFriendsView.allowsSelection = NO;
    
    self.currentUser = [User currentUser];
    self.friendsList = [[User currentUser] returnFriendsList];
    self.activeFriends = [[User currentUser] returnRecepients];
    self.activeEmails = [[User currentUser] returnEmailRecepients];
    NSLog(@"active emails is %lu", (unsigned long)[self.activeEmails count]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
     self.ListFriendsView.frame = self.view.frame;
    [self.ListFriendsView layoutSubviews];
    if([self.currentUser FRIsActivated])
    {
        [self.activateFRButton setOn:YES];
    }
    else
    {
        [self.activateFRButton setOn:NO];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)FRActivated:(id)sender
{
    if ([self.activateFRButton isOn]) {
        //[self.activateFRButton setOn:NO animated:YES];
        [self.currentUser activateFR];
    } else {
        //[self.activateFRButton setOn:YES animated:YES];
        [self.currentUser deactivateFR];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0)
        return [self.friendsList count];
    else
        return [self.activeEmails count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Friends";
    else
        return @"Emails";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FriendCell";
    SendFriendTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[SendFriendTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    long row = [indexPath row];
    long section = [indexPath section];
    Activations *recepient;
    
    if(section == 0)
    {
        cell.friendName.text = [self.friendsList objectAtIndex:row];
        cell.friendName.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
    
        recepient = [self.activeFriends objectAtIndex:row];
    }
    else
    {
        UnsignedActivation *email = [self.activeEmails objectAtIndex:row];
        cell.friendName.text = email.email;
        cell.friendName.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        recepient = email;
    }
    
    ActivateButton  *activeButton = [ActivateButton buttonWithType:UIButtonTypeCustom];
    activeButton.tag = [indexPath row];
    activeButton.section = [indexPath section];
    [activeButton setTitle:@"" forState:UIControlStateNormal];
    [activeButton addTarget:self
                     action:@selector(friendActivated:)
           forControlEvents:UIControlEventTouchDown];
    //[button setTitle:[currentObject.recognizedIDs objectAtIndex:i] forState:UIControlStateNormal];
    activeButton.frame = CGRectMake(300, 8, 40, 40);
    activeButton.layer.cornerRadius = 20;
    activeButton.layer.borderWidth = 2;
    activeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [activeButton setBackgroundColor:[UIColor clearColor]];

    
    recepient.Button = activeButton;
    
    if(!recepient.activated)
    {
        if ([recepient isMemberOfClass:[Activations class]])
            NSLog(@"%@ is deactivated", recepient.username);
        //else
            //NSLog(@"%@ is deactivated", (UnsignedActivation*)recepient.email);
        
        [recepient.Button deactivate];
    }
    else
    {
        //NSLog(@"%@ is activated", recepient.username);
        if ([recepient isMemberOfClass:[Activations class]])
            NSLog(@"%@ is activated", recepient.username);
        [recepient.Button activate];
    }
    
    
    [cell addSubview:recepient.Button];
    return cell;
    
}

- (void) friendActivated:(id) sender
{
    ActivateButton *activeButton = (ActivateButton *) sender;
    Activations *activations;
    if(activeButton.section == 0)
       activations = [self.activeFriends objectAtIndex:activeButton.tag];
    else
        activations = [self.activeEmails objectAtIndex:activeButton.tag];
    
    if(!activations.activated)
    {
        activations.activated = 1;
        [activations activateWithTime:10];
    }
    else
    {
        activations.activated = 0;
        [activations deactivate];
    }
    
    [self.ListFriendsView reloadData];
    
    //NSValue *rctFrame = [image.facesBoxes objectAtIndex:button.personNum];
    
    //NSIndexPath *path = [NSIndexPath indexPathForRow:button.imgNum inSection:0];
    //ShareImgCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:path];
    
    //FriendList *tableView = [[FriendList alloc] initWithFrame:CGRectMake(5,[rctFrame CGRectValue].origin.y+[rctFrame CGRectValue].size.height, image.primaryImage.size.width,150)];
    
    
    //[self.tableView reloadData];
}

- (IBAction)addingContact:(id)sender {
}
@end
