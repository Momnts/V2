//
//  ServerCalls.h
//
//  Created by Naren Sathiya on 3/25/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ServerCalls;

@protocol ServerCallsDelegate


@optional
-(void) client:(ServerCalls *) serverCalls sendWithData:(NSDictionary*) responseObject;
-(void) client:(ServerCalls *) serverCalls sendWithRecepientData:(NSDictionary*) responseObject;
-(void) client:(ServerCalls *) serverCalls sendWithImInData:(NSDictionary*) responseObject;
-(void) client:(ServerCalls *) serverCalls sendWithNames:(NSMutableArray*) names;
-(void) client:(ServerCalls *) serverCalls sendWithRecognizedNames:(NSMutableArray*) name index:(int)ind;
-(void) client:(ServerCalls *) serverCalls sendLoginSuccess:(NSDictionary*) responseObject;
-(void) client:(ServerCalls *) serverCalls sendFriendSuccess:(NSDictionary*) responseObject;
-(void) client:(ServerCalls *) serverCalls getFriendSuccess:(NSMutableArray *)responseObject;
-(void) client:(ServerCalls *) serverCalls sendLoginPicSuccess:(NSMutableDictionary*) responseObject;
-(void) client:(ServerCalls *) serverCalls shareImagesSuccess:(NSMutableDictionary*) responseObject;
-(void) client:(ServerCalls *) serverCalls savePhotoDataSuccess:(NSString*) success;
-(void) client:(ServerCalls *) serverCalls sendUpdateLocationSuccess:(NSDictionary*) responseObject;
@end


@interface ServerCalls : NSObject

@property (nonatomic, assign)id delegate;
@property(strong, nonatomic) NSString *zipCode;

- (void) recognize_image: (UIImage*)image file_name:(NSString*)name index:(int)ind;
- (void) train_image: (UIImage*)image file_name:(NSString*)name person_id:(NSString*)pid;
- (void) train_images: (NSMutableArray*)faces file_name: (NSString*)name person_id:(NSString*)pid;
- (void) login: (NSString*) email withSecurity:(NSString*) password;
- (void) signup: (NSString*) name withSecurity:(NSString*) password withEmail:(NSString*) email withNumber:(NSString*) number;
- (void) signup_pic: (UIImage*) image withUserID:(NSString*) userID;
- (void) signup_pics: (NSMutableArray*) images withUserID:(NSString*) userID withUserName:(NSString*) userName;
- (void) take_pics: (UIImage*) image withUserID:(NSString*) userID withUserName:(NSString*) userName withLat:(NSString*)lat withLng:(NSString*)lng;
- (void) shareImages: (NSMutableArray*) image withUserID:(NSString*) userID withUserName:(NSString*) userName withLat:(NSMutableArray*)lat withLng:(NSMutableArray*)lng withDate:(NSMutableArray*) date;
- (void) shareMetadata: (NSMutableArray*) imageMetaData;
- (void) get_pics: (NSString*) userID withUserName:(NSString*) userName startIndex:(NSInteger)start endIndex:(NSInteger)end;
- (void) get_recepientPics: (NSString*) userID withUserName:(NSString*) userName startIndex:(NSInteger)start endIndex:(NSInteger)end;
- (void) get_imInPics: (NSString*) userID withUserName:(NSString*) userName startIndex:(NSInteger)start endIndex:(NSInteger)end;
- (void) updateLocation: (NSString*) key withLat:(NSString*) lat withLng:(NSString*) lng;
- (void) addFriend: (NSString*) userName toUser:(NSString*) friendUser;
- (void) getFriends: (NSString*) userName;

@end
