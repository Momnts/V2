//
//  AllPicsViewController.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/18/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "AllPicsViewController.h"

@interface AllPicsViewController ()

@end

@implementation AllPicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationItem.hidesBackButton = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //self.client = [[ServerCalls alloc] init];
    //self.client.delegate = self;
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSString *searchTerm = self.searches[section];
    //return [self.searchResults[searchTerm] count];
    NSLog(@"image count is %lu", (unsigned long)self.imagesLocation.count);
    return self.imagesLocation.count;
}

// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1; // [self.searches count];
}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PicsCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    
    long row = [indexPath row];
    NSString *imageUrl = [self.imagesLocation objectAtIndex:row];
    
    
    NSURL *imageURL = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [cell.imageView setImageWithURL:imageURL];
    /*
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:imageURL options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Data has loaded successfully.");
    }
    UIImage* img = [[UIImage alloc] initWithData:data];
    CGSize sizeImg = img.size;
    NSLog(@"image url is %@", imageURL.description);
    NSLog(@"the size of the image is %f, %f", sizeImg.width, sizeImg.height);
    cell.imageView.image = img;
    */
    //cell.imageView.backgroundColor = [UIColor blackColor];
    //cell.imageView.image = self.imagesArray[indexPath.row];
    cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    return cell;
    
}


// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

/*
// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
      //return self.collectionView.frame.size;
    
    //UIImage *photo = self.imagesLocation[indexPath.row];
    
    // 2
    CGSize retval = CGSizeMake(90, 120);
    //retval.height += 50; retval.width += 50; return retval;
    return retval;
}
 */

// 3
/*
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
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
