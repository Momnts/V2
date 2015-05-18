//
//  Activations.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/14/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "Activations.h"


#define TIMER_STEP .1
#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@implementation Activations


-(void)activateWithTime:(int)tl
{
    self.activated = 1;
    self.currentTime = 0;
    self.timerLimit = tl;
    [self.Button activate];
    self.activated = TRUE;
    //NSLog(@"activeFriends count is %lu after adding", (unsigned long)[[User currentUser] returnActiveRecepientsCount]);
    self.activationTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_STEP target:self selector:@selector(updateTimerButton:) userInfo:nil repeats:YES];
}

-(void)stateActivated
{
    self.activated = 1;
    [self.Button activate];
}

-(void)deactivate
{
    [self.Button deactivate];
    self.activated = FALSE;
    [self.activationTimer invalidate];
    self.currentAngle = 0;
    [self.Button setNeedsDisplay];
    //NSLog(@"activeFriends count is %lu after subtracting", (unsigned long)[[User currentUser] returnActiveRecepientsCount]);
    
    //CHANGE FOR IOS6
    //[(UITableView*)st.superview.superview reloadData];
}

-(void)updateTimerButton:(NSTimer *)timer
{
    
    self.currentTime += TIMER_STEP;
    self.currentAngle = (self.currentTime/self.timerLimit) * 360;
    if(self.currentAngle >= 365)
    {[self deactivate];}
    else
    {
        /*
         self.aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20)
                                                       radius:15
                                                   startAngle:DEGREES_TO_RADIANS(0)
                                                     endAngle:DEGREES_TO_RADIANS(self.currentAngle)
                                                    clockwise:YES];
    */
         //self.Button.aPath = self.aPath;
       
         
        self.Button.currentAngle = self.currentAngle;
         [self.Button setNeedsDisplay];
     }
}

- (BOOL)isEqual:(id)object {
    
    if ([self.username isEqualToString:[object username]])
        return YES;
    return NO;
}



@end
