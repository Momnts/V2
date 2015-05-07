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
    // Return the number of rows in the section.
    return self.imageArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ImgCell";
    ShareImgCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[ShareImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    long row = [indexPath row];
    RCImage *currentObject = [self.imageArray objectAtIndex:row];
    
    UIImageView *inputImage = [[UIImageView alloc] initWithImage:currentObject.primaryImage];
    [cell.mainView addSubview:inputImage];
    
    for (int i=0; i < currentObject.facesBoxes.count; i++ )
    {
        NSValue *rctFrame = [currentObject.facesBoxes objectAtIndex:i];
        faceButton *button = [faceButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = [indexPath row];
        button.imgNum = [indexPath row]; 
        button.personNum = i;
        button.currentCell = cell;
        [button addTarget:self
                   action:@selector(faceClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Identify" forState:UIControlStateNormal];
        button.frame = [rctFrame CGRectValue];
        //button.layer.borderColor = [UIColor greenColor].CGColor;
        [button setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.2f] ];
        
        [cell.mainView insertSubview:button aboveSubview:cell.mainView];
        //[cell.mainView addSubview:button];
    }
    
    //[inputImage setTransform:CGAffineTransformMakeScale(1, -1)];
    //[cell.imageView setTransform:CGAffineTransformMakeScale(1, -1)];
    
    //[cell.imageView setImage:currentObject.primaryImage];
    
    NSLog(@"image view [w,h] is %f and %f", cell.imageView.bounds.size.width, cell.imageView.bounds.size.height);
    
    return cell;
}

- (void) faceClicked:(id) sender
{
    faceButton *button = (faceButton*) sender;
    NSLog(@"picture clicked on is %ld", (long)button.imgNum);
    NSLog(@"person clicked on is %ld", (long)button.personNum);
    
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
