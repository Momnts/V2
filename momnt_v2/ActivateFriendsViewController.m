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
   
    NSLog(@"sendfriendcontroller view did load");
    self.ListFriendsView.dataSource = self;
    self.ListFriendsView.delegate = self;
    self.ListFriendsView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.ListFriendsView.allowsSelection = NO;
    
    self.currentUser = [User currentUser];
    self.friendsList = [[User currentUser] returnFriendsList];
    self.activeFriends = [[User currentUser] returnRecepients];
    
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.friendsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FriendCell";
    SendFriendTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[SendFriendTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    long row = [indexPath row];

    
    cell.friendName.text = [self.friendsList objectAtIndex:row];
    cell.friendName.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    Activations *recepient = [self.activeFriends objectAtIndex:row];
    
    ActivateButton  *activeButton = [ActivateButton buttonWithType:UIButtonTypeCustom];
    activeButton.tag = [indexPath row];
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
    /*
     UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20)
     radius:20
     startAngle:DEGREES_TO_RADIANS(0)
     endAngle:DEGREES_TO_RADIANS(recepient.currentAngle)
     clockwise:YES];
     
     [[UIColor redColor] setStroke];
     aPath.lineWidth = 5;
     [aPath stroke];
     
     
     CAShapeLayer *shapeLayer = [CAShapeLayer layer];
     shapeLayer.frame = activeButton.bounds;
     shapeLayer.path = aPath.CGPath;
     shapeLayer.fillColor = [UIColor clearColor].CGColor;
     shapeLayer.strokeColor = [UIColor blackColor].CGColor;
     shapeLayer.lineWidth = 4;
     
     [activeButton.layer addSublayer:shapeLayer];
     */
    recepient.Button = activeButton;
    
    if(!recepient.activated)
    {
        NSLog(@"%@ is deactivated", recepient.username);
        [recepient.Button deactivate];
    }
    else
    {
        NSLog(@"%@ is activated", recepient.username);
        [recepient.Button activate];
    }
    
    
    [cell addSubview:recepient.Button];
    return cell;
    
}

- (void) friendActivated:(id) sender
{
    ActivateButton *activeButton = (ActivateButton *) sender;
    Activations *activations = [self.activeFriends objectAtIndex:activeButton.tag];
    
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
