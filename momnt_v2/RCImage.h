//
//  RCImage.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/3/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCImage : NSObject

@property UIImage *primaryImage;
@property NSMutableArray *faces;
@property NSMutableArray *facesBoxes;
@property NSString *takenLat;
@property NSString *takenLng;

@end
