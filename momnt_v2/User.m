//
//  User.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/7/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser;
NSMutableArray *FriendsList;
NSMutableDictionary *FriendsIDMap;
static ServerCalls *client;
NSString *username;
NSString *userID;
NSMutableArray *stageQueue;
NSMutableArray *recepients;
bool FRActivation;

+ (User*) currentUser
{
    if(currentUser == nil)
    {
        NSLog(@"about to make a new user");
        currentUser = [[User alloc] init];
    }
    return currentUser;
}

- (void) initUser:(NSString*)un initID:(NSString *)ID
{
    
    client = [[ServerCalls alloc] init];
    client.delegate = self;
    username = un;
    userID = ID;
    FriendsList = [[NSMutableArray alloc] init];
    stageQueue = [[NSMutableArray alloc]init]; //Save and retain from cache
    recepients = [[NSMutableArray alloc] init];
    FriendsIDMap = [[NSMutableDictionary alloc] init];
    
    //[FriendsList addObject:@"jake"];
    //[FriendsList addObject:@"libbet"];
    //[FriendsList addObject:@"tenei"];
    [client getFriends:username];
    
}

- (void) updateFriendsList
{
    [FriendsList removeAllObjects];
    [FriendsIDMap removeAllObjects];
    [client getFriends:username];
    
}

-(void) client:(ServerCalls *) serverCalls getFriendSuccess:(NSMutableArray *)responseObject
{
    
    for (int i =0; i < responseObject.count; i++)
    {
        NSLog(@"At index %d info is %@", i, [responseObject objectAtIndex:i]);
        NSDictionary *info = [responseObject objectAtIndex:i];
        NSString *name = [info objectForKey:@"userName"];
        NSString *userid = [info objectForKey:@"id"];
        Activations *activation = [[Activations alloc] init];
        activation.username = name;
        activation.activated = FALSE;
        
        NSLog(@"At index %d name is %@", i, name);
        [FriendsList addObject:name];
        [FriendsIDMap setValue:userid forKey:name];
        [recepients addObject:activation];
    }
    NSLog(@"Successfully made FriendsList! list count is %lu", (unsigned long)FriendsList.count);
}

- (NSMutableArray*) returnFriendsList
{
    //[client getFriends:username];
    
    NSLog(@"returning Friends List. List count is %lu", (unsigned long)FriendsList.count);
    return FriendsList;
}

- (NSMutableArray*) returnStageQueue
{
    return stageQueue;
}

- (NSString*) returnUserName
{
    return username;
}

- (NSString*) returnUserID
{
    return userID;
}

- (NSMutableArray*) returnRecepients
{
    return recepients;
}
- (NSMutableDictionary*) returnFriendsIDMap
{
    return FriendsIDMap;
}
- (NSMutableArray*) returnActiveRecepients
{
    NSMutableArray *recs = [[NSMutableArray alloc]init];
    for (int i=0; i < recepients.count; i++)
    {
        Activations* rec = recepients[i];
        if(rec.activated)
        {
            NSLog(@"Active");
           [recs addObject:rec];
        }
    }
    return recs;
}
- (NSInteger*) returnActiveRecepientsCount
{
    return (NSInteger*)[[self returnActiveRecepients] count];
}
- (void) activateFR
{
    FRActivation = 1;
    NSLog(@"FR is activated");
}
- (void) deactivateFR
{
    FRActivation = 0;
     NSLog(@"FR is deactivated");
}
- (BOOL) FRIsActivated
{
    return FRActivation;
}


@end
