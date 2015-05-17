//
//  SendFriendsTableController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/13/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "SendFriendsTableController.h"
#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)
@interface SendFriendsTableController ()

@end

@implementation SendFriendsTableController

- (void)viewDidLoad {
    //[super viewDidLoad];
    
    //Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"sendfriendcontroller view did load");
    self.dataSource = self;
    self.delegate = self;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.currentUser = [User currentUser];
    self.friendsList = [[User currentUser] returnFriendsList];
    self.activeFriends = [[User currentUser] returnRecepients];
    [self reloadData];
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
    
    cell.textLabel.text = [self.friendsList objectAtIndex:row];
    cell.textLabel.textColor = [UIColor whiteColor];
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
    activeButton.layer.borderColor = [UIColor whiteColor].CGColor;
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
    
    //NSValue *rctFrame = [image.facesBoxes objectAtIndex:button.personNum];
    
    //NSIndexPath *path = [NSIndexPath indexPathForRow:button.imgNum inSection:0];
    //ShareImgCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:path];
    
    //FriendList *tableView = [[FriendList alloc] initWithFrame:CGRectMake(5,[rctFrame CGRectValue].origin.y+[rctFrame CGRectValue].size.height, image.primaryImage.size.width,150)];
    
    
    //[self.tableView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
