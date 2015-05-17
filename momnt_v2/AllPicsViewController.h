//
//  AllPicsViewController.h
//  momnt_v2
//
//  Created by Naren Sathiya on 4/18/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicsCollectionViewCell.h"
#import "ServerCalls.h"
#import "UIKit+AFNetworking.h"

@interface AllPicsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
//@property (strong, nonatomic) NSArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *imagesLocation;


@property ServerCalls *client;

@end
