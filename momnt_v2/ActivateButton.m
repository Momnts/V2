//
//  ActivateButton.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/13/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "ActivateButton.h"

#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@implementation ActivateButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code

    if(self.activeState)
    {
        
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20)
                                                         radius:15
                                                     startAngle:DEGREES_TO_RADIANS(0)
                                                       endAngle:DEGREES_TO_RADIANS(self.currentAngle)
                                                      clockwise:YES];
      //NSLog(@"Inside Active state angle is %f",self.currentAngle);
    [[UIColor colorWithRed:195.0/255.0 green:37.0/255.0 blue:28.0/255.0 alpha:1] setStroke];
    aPath.lineWidth = 4;
    [aPath stroke];
    }
    else
    {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
        
}

 -(void) activate
 {
    self.activeState = TRUE;
    //[self setBackgroundColor:[UIColor greenColor]];
 }

-(void) deactivate
{
    self.activeState = FALSE;
    [self setBackgroundColor:[UIColor whiteColor]];
}

-(int) returnState
{
    return self.activeState;
}
@end
