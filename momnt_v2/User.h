//
//  User.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/7/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCalls.h"
#import "Activations.h"
#import "UnsignedActivation.h"

@interface User : NSObject <ServerCallsDelegate>

+ (User*) currentUser;
- (NSMutableArray*) returnFriendsList;
- (NSMutableDictionary*) returnFriendsIDMap;
- (NSMutableArray*) returnStageQueue;
- (void) initUser:(NSString*)un initID:(NSString*)ID;
- (NSString*) returnUserName;
- (NSString*) returnUserID;
- (NSMutableArray*) returnActiveRecepients;
- (NSMutableArray*) returnRecepients;
- (NSInteger*) returnActiveRecepientsCount;
- (void) updateFriendsList;
- (void) activateFR;
- (void) deactivateFR;
- (BOOL) FRIsActivated;

- (NSMutableArray*) returnEmailRecepients;
- (NSMutableArray*) returnActiveEmailRecepients;
- (NSInteger*) returnActiveEmailRecepientsCount;
- (void) addEmailRecepient: (NSString*)email;
- (void) emptyEmailRecepient: (NSString*)email;




@end
