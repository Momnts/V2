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
-(void) client:(ServerCalls *) serverCalls sendWithNames:(NSMutableArray*) names;

@end


@interface ServerCalls : NSObject

@property (nonatomic, assign)id delegate;
@property(strong, nonatomic) NSString *zipCode;

- (void) recognize_image: (NSMutableArray*)image file_name:(NSString*)name;
- (void) train_image: (UIImage*)image file_name:(NSString*)name person_id:(NSString*)pid;

@end
