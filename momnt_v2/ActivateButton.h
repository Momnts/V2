//
//  ActivateButton.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/13/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivateButton : UIButton

@property float currentAngle;
@property UIBezierPath* aPath;
@property int activeState;
- (void) activate;
- (void) deactivate;
-(int) returnState;

@end
