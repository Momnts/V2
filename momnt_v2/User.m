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
static ServerCalls *client;
NSString *username;



+ (User*) currentUser
{
    if(currentUser == nil)
    {
        NSLog(@"about to make a new user");
        currentUser = [[User alloc] init];
    }
    return currentUser;
}

- (void) initUser:(NSString*)un
{
    
    client = [[ServerCalls alloc] init];
    client.delegate = self;
    username = un;
    FriendsList = [[NSMutableArray alloc] init];
    [client getFriends:username];
    
}

-(void) client:(ServerCalls *) serverCalls getFriendSuccess:(NSMutableArray *)responseObject
{
    
    for (int i =0; i < responseObject.count; i++)
    {
        NSLog(@"At index %d info is %@", i, [responseObject objectAtIndex:i]);
        NSDictionary *info = [responseObject objectAtIndex:i];
        NSString *name = [info objectForKey:@"userName"];
        NSLog(@"At index %d name is %@", i, name);
        [FriendsList addObject:name];
    }
    NSLog(@"Successfully made FriendsList! list count is %d", FriendsList.count);
}

- (NSMutableArray*) returnFriendsList
{
    //[client getFriends:username];
    
    NSLog(@"returning Friends List. List count is %lu", (unsigned long)FriendsList.count);
    return FriendsList;
}


@end
