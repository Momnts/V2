//
//  PicsCollectionViewCell.m
//  momnt_v2
//
//  Created by Naren Sathiya on 4/18/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "PicsCollectionViewCell.h"

@implementation PicsCollectionViewCell

/*
-(void) setPhoto:(UIImage *)photo {
    
    if(_photo != photo) {
        _photo = photo;
    }
    self.imageView.image = _photo;
}
*/


- (id)initWithFrame:(CGRect)frame
{
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.imageView];
    return self;
}

@end
