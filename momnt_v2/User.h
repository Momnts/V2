//
//  User.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/7/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCalls.h"

@interface User : NSObject <ServerCallsDelegate>

+ (User*) currentUser;
- (NSMutableArray*) returnFriendsList;
- (void) initUser:(NSString*)un;


@end
