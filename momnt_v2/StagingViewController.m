//
//  StagingViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "StagingViewController.h"

@interface StagingViewController ()

@end

@implementation StagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(shareImgs:)];
    
    self.navigationItem.rightBarButtonItem = sendButton;
    self.client = [[ServerCalls alloc] init];
    self.client.delegate = self;
    self.tableView.allowsSelection = NO;
}

-(void) shareImgs:(id) sender{
    dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"about to send picture");
        NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
        NSMutableArray *lngArray = [[NSMutableArray alloc] init];
        NSMutableArray *latArray = [[NSMutableArray alloc] init];
        //NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *stageQueue = [[User currentUser] returnStageQueue];
        for (int i = 0; i < [[[User currentUser] returnStageQueue] count]; i++)
        {
            RCImage *image = stageQueue[i];
            imagesArray[i] = image.primaryImage;
            lngArray[i] = image.takenLng;
            latArray[i] = image.takenLat;
            //timeArray[i] = image.takenTime;
            dateArray[i] = image.takenDate;
        }
        
        [self.client shareImages:imagesArray withUserID:[[User currentUser] returnUserID] withUserName:[[User currentUser] returnUserName] withLat:lngArray withLng:latArray withDate:dateArray];
        dispatch_async( dispatch_get_main_queue(), ^{
            NSLog(@"sent picture asynchronously");
        });
    });
    
}

-(void)client:(ServerCalls *)serverCalls shareImagesSuccess:(NSMutableArray *)imagesID {
    

    
    NSMutableArray *stageQueue = [[User currentUser] returnStageQueue];
    NSMutableArray *metaData = [[NSMutableArray alloc] init];
    for (int i = 0; i < [imagesID count]; i++)
    {
        RCImage *image = stageQueue[i];
        NSMutableDictionary *metadataEntry = [[NSMutableDictionary alloc] init];
        [metadataEntry setValue:[imagesID objectAtIndex:i] forKey:@"photoId"];
        [metadataEntry setValue:[[User currentUser] returnUserID] forKey:@"username"];
        [metadataEntry setValue:image.takenLat forKey:@"lat"];
        [metadataEntry setValue:image.takenLng forKey:@"lng"];
        [metadataEntry setValue:image.takenDate forKey:@"date"];
        
        NSMutableDictionary* FriendIDMap = [[User currentUser] returnFriendsIDMap];
        NSMutableArray *recepients = [[NSMutableArray alloc] init];
        NSMutableArray *dwellers = [[NSMutableArray alloc] init];
        NSMutableArray *emailRecipients = [[NSMutableArray alloc] init];
        
        for (int j = 0; j<[image.recipients count]; j++)
        {
            Activations *activation = [image.recipients objectAtIndex:j];
            [recepients addObject:[FriendIDMap objectForKey:activation.username]];
            NSLog(@"in picture %d, image recepient is %@", i, activation.username);
        }
        
        if(image.recipients.count == 0)
            [metadataEntry setObject:@"" forKey:@"recepients"];
        else
            [metadataEntry setObject:recepients forKey:@"recepients"];
        
        
        for (int j = 0; j<[image.recognizedIDs count]; j++)
        {
            [dwellers addObject:[FriendIDMap objectForKey:image.recognizedIDs]];
            NSLog(@"in picture %d, face recognized is %@", i,[FriendIDMap objectForKey:image.recognizedIDs] );
        }
        
        if(dwellers.count == 0)
            [metadataEntry setObject:@"" forKey:@"dwellers"];
        else
            [metadataEntry setObject:dwellers forKey:@"dwellers"];
        
        for (int j = 0; j<[image.emailRecipients count]; j++)
        {
            UnsignedActivation *em = [image.emailRecipients objectAtIndex:j];
             NSLog(@"in picture %d, email is %@", i,em.email );
            [emailRecipients addObject:em.email];
            //NSLog(@"in picture %d, face recognized is %@", i,[FriendIDMap objectForKey:image.recognizedIDs] );
        }
        
        if(emailRecipients.count == 0)
            [metadataEntry setObject:@"" forKey:@"emailRecipients"];
        else
            [metadataEntry setObject:emailRecipients forKey:@"emailRecipients"];
        
        [metaData addObject:metadataEntry];
    }
    
    [self.client shareMetadata:metaData];
    
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

    NSUInteger count = [[[User currentUser] returnStageQueue] count];
    //NSLog(@"count is %lu", (unsigned long)count);
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ImgCell";
    ShareImgCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[ShareImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    long row = [indexPath row];
    //RCImage *currentObject = [self.imageArray objectAtIndex:row];
    
    RCImage *currentObject = [[[User currentUser] returnStageQueue] objectAtIndex:row];
    
    UIImageView *inputImage = [[UIImageView alloc] initWithImage:currentObject.primaryImage];
    [cell.mainView addSubview:inputImage];
    
    for (int i=0; i < currentObject.facesBoxes.count; i++ )
    {
        NSValue *rctFrame = [currentObject.facesBoxes objectAtIndex:i];
        faceButton *button = [faceButton buttonWithType:UIButtonTypeRoundedRect];
        //button.tag = [indexPath row];
        //button.imgNum = [indexPath row];
        //button.personNum = i;
        //button.currentCell = cell;
        //[button addTarget:self
        //           action:@selector(faceClicked:)
        // forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"setTitle %@", currentObject.recognizedIDs);
        [button setTitle:[currentObject.recognizedIDs objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = CGRectMake([rctFrame CGRectValue].origin.x, [rctFrame CGRectValue].origin.y-30, 100, 20);
        //button.layer.borderColor = [UIColor greenColor].CGColor;
        [button setBackgroundColor:[UIColor colorWithRed:34.0/255.0 green:192.0f/255.0 blue:100.0/255.0 alpha:1] ];
        button.layer.cornerRadius = 10;
        
        [cell.mainView insertSubview:button aboveSubview:cell.mainView];
        //[cell.mainView addSubview:button];
    }
    
    NSString *recipients =[[currentObject.recipients valueForKey:@"username"] componentsJoinedByString:@", "];
    cell.recipientsLabel.text = recipients;
    cell.recipientsLabel.textColor = [UIColor greenColor];
    cell.recipientsLabel.layer.cornerRadius = 10;
    cell.recipientsLabel.layer.borderWidth = 2;
    cell.recipientsLabel.layer.borderColor = [UIColor colorWithRed:34.0/255.0 green:192.0f/255.0 blue:100.0/255.0 alpha:1].CGColor;
    cell.recipientsLabel.backgroundColor = [UIColor colorWithRed:34.0f/255.0 green:192.0f/255.0 blue:100/255.0 alpha:1];
    [cell.recipientsLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}

- (void) faceClicked:(id) sender
{
    faceButton *button = (faceButton*) sender;
    //NSLog(@"picture clicked on is %ld", (long)button.imgNum);
    //NSLog(@"person clicked on is %ld", (long)button.personNum);
    
    RCImage* image = [self.imageArray objectAtIndex:button.imgNum];
    NSValue *rctFrame = [image.facesBoxes objectAtIndex:button.personNum];
    
    //NSIndexPath *path = [NSIndexPath indexPathForRow:button.imgNum inSection:0];
    //ShareImgCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:path];
    
    //FriendList *tableView = [[FriendList alloc] initWithFrame:CGRectMake(5,[rctFrame CGRectValue].origin.y+[rctFrame CGRectValue].size.height, image.primaryImage.size.width,150)];
    
    FriendList *tableView = [[FriendList alloc] initWithFrame:CGRectMake(5,[rctFrame CGRectValue].origin.y+[rctFrame CGRectValue].size.height, image.primaryImage.size.width,150) image:button.imgNum withFace:button.personNum];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = tableView;
    tableView.dataSource = tableView;
    //[tableView reloadData];

    //[cell.mainView addSubview:tableView];
    
    //[button.currentCell addSubview:tableView];
    [button.currentCell addSubview:tableView];
    //[button.currentCell bringSubviewToFront:tableView];
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 580;
}

-(void) client:(ServerCalls *) serverCalls savePhotoDataSuccess:(NSString*) success
{
    [self performSegueWithIdentifier:@"goHome" sender:nil];
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
