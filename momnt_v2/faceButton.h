//
//  faceButton.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareImgCell.h"

@interface faceButton : UIButton

@property (nonatomic, assign) NSInteger imgNum;
@property (nonatomic, assign) NSInteger personNum;
@property (nonatomic, assign) ShareImgCell* currentCell;


//-(void)setImgNum:(NSInteger)imgNum;
//-(void)setPersonNum:(NSInteger)personNum;

@end
