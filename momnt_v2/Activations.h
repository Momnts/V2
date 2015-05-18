//
//  Activations.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/14/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "ActivateButton.h"
#import "User.h"
#import "SendFriendTableCell.h"

@interface Activations : NSObject

@property NSString *username;
@property BOOL activated;
@property NSTimer *activationTimer;
@property ActivateButton *Button;
@property float currentAngle;
@property float lastAngle;
@property UIBezierPath* aPath;
@property float currentTime;
@property float timerLimit;
-(void)activateWithTime:(int)tl;
- (BOOL)isEqual:(id)name;
-(void)deactivate;
-(void)stateActivated;


@end
