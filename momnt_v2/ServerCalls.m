//
//  serverCalls.m
//  ahMyFace_v1
//
//  Created by Naren Sathiya on 3/25/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "ServerCalls.h"

@implementation ServerCalls

@synthesize delegate;

static NSString* const BaseURLString = @"https://obscure-caverns-1153.herokuapp.com/";

- (void) recognize_image: (UIImage*)face file_name: (NSString*)name index:(int)ind
{
    [KairosSDK initWithAppId:@"7d430ebb" appKey:@"876f51893026dd083968a95edf571824"];
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    [KairosSDK recognizeWithImage:face
                        threshold:@".6"
                      galleryName:@"gallery2"
                       maxResults:@"10"
                          success:^(NSDictionary *response) {
                              //NSLog(@"response is %@", response);
                              NSString *person = [[[[response objectForKey:@"images"] objectAtIndex:0] objectForKey:@"transaction"] objectForKey:@"subject"] ;
                              NSLog(@"person is %@", person);
                              [delegate client:self sendWithRecognizedNames:person index:ind];
                        } failure:^(NSDictionary *response) {
                              
                              NSLog(@"%@", response);
                              
                          }];
    
    /*
    __block BOOL *finishedBlock;
    finishedBlock = false;
    
    for (int i=0; i < faces.count; i++)
    {
        UIImage *localImage = [faces objectAtIndex:(NSInteger) i];
      
        finishedBlock = false;
        
        NSLog(@"picture width is %f", localImage.size.width);
        [KairosSDK recognizeWithImage:[faces objectAtIndex:0]
                            threshold:@".6"
                          galleryName:@"gallery1"
                           maxResults:@"10"
                              success:^(NSDictionary *response) {
                                  NSLog(@"response is %@", response);
                                  NSString *person = [[[[response objectForKey:@"images"] objectAtIndex:0] objectForKey:@"transaction"] objectForKey:@"subject"] ;
                                  NSLog(@"person is %@", person);
                                  [names addObject:person];
                                  finishedBlock = true;
                                if (i==(faces.count-1))
                                {
                                    NSLog(@"finished");
                                    [delegate client:self sendWithNames:names ];
                                }
                          } failure:^(NSDictionary *response) {
                              
                              NSLog(@"%@", response);
                              
                          }];
        while (finishedBlock == false)
        {
            //NSLog(@"doing nothing");
        }
    }
 */   
}

- (void) train_images: (NSMutableArray*)faces file_name: (NSString*)name person_id:(NSString*)pid
{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    __block BOOL *finishedBlock;
    finishedBlock = false;
    
    for (int i=0; i < faces.count; i++)
    {
        UIImage *localImage = [faces objectAtIndex:1];
    
        finishedBlock = false;
        
        NSLog(@"height is %f, width is %f", localImage.size.height, localImage.size.width);
        NSLog(@"pid is %@", pid);
        [KairosSDK enrollWithImage:localImage
                            subjectId:pid
                          galleryName:@"gallery2"
                              success:^(NSDictionary *response) {
                                  NSLog(@"response is %@", response);
                                  //NSString *person = [[[[response objectForKey:@"images"] objectAtIndex:0] objectForKey:@"transaction"] objectForKey:@"subject"] ;
                                  //NSLog(@"person is %@", person);
                                  //[names addObject:person];
                                  finishedBlock = true;
                                  if (i==(faces.count-1))
                                  {
                                      NSLog(@"finished");
                                      [delegate client:self sendWithNames:names ];
                                  }
                              } failure:^(NSDictionary *response) {
                                  NSLog(@"failed");
                                  
                                  NSLog(@"%@", response);
                                  
                              }];
        while (finishedBlock == false)
        {
            //NSLog(@"doing nothing");
        }
    }
    
}
 

- (void) train_image:(UIImage*)image file_name:(NSString*)name person_id:(NSString*)pid
{
    UIImage *localImage = image;
     NSLog(@"height is %f, width is %f", localImage.size.height, localImage.size.width);
    
    [KairosSDK enrollWithImage:localImage
                     subjectId:pid
                   galleryName:@"gallery2"
                       success:^(NSDictionary *response) {
                           
                           NSLog(@"%@", response);
                           [delegate client:self sendWithData:response ];
                           
                       } failure:^(NSDictionary *response) {
                           
                           NSLog(@"%@", response);
                           
                       }];
}

- (void) login: (NSString*) email withSecurity:(NSString*) password
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"email"] = email;
    params[@"password"] = password;
    
    NSLog(@" %@ is email and %@ is password in login", email, password);
    
    [manager POST:@"/login?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *json = (NSDictionary *)responseObject;
         NSLog(@"after json dictionary before arry");
         //NSArray *data = [json objectForKey:@"latestDeals"];
         [delegate client:self sendLoginSuccess:json ];//to:@"getLatestDeals"];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

- (void) signup: (NSString*) name withSecurity:(NSString*) password withEmail:(NSString*) email withNumber:(NSString*) number
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSLog(@"about to send to head servers. number is %@", number);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = name;
    params[@"password"] = password;
    params[@"email"] = email;
    params[@"phoneNumber"] = number;
    
    [manager POST:@"/signup?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *json = (NSDictionary *)responseObject;
         NSLog(@"after json dictionary before arry");
         //NSArray *data = [json objectForKey:@"latestDeals"];
         [delegate client:self sendLoginSuccess:json];//to:@"getLatestDeals"];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

- (void) signup_pic: (UIImage*) image withUserID:(NSString*) userID
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"key"] = userID;//[NSString stringWithFormat:@"%ld", (long)userID];
    
    params[@"key"] = @"1";//[NSString stringWithFormat:@"%ld", (long)userID];
    params[@"userName"] = @"love";
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    AFHTTPRequestOperation *op = [manager POST:@"/user/avatar?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        [delegate client:self sendLoginPicSuccess:(NSMutableArray*)responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    
}


- (void) signup_pics: (NSMutableArray*) images withUserID:(NSString*) userID withUserName:(NSString*) userName
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSLog(@"key inside signup_pics is %@", userID);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"key"] = userID;//[NSString stringWithFormat:@"%ld", (long)userID];
    //params[@"userName"] = @"love";
    
    NSString* fileName = [NSString stringWithFormat:@"%@/%@/", userName, userID];
    //uploadPhotos
    AFHTTPRequestOperation *op = [manager POST:@"/user/avatar?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        int i = 0;
        for(UIImage *eachImage in images)
        {
            NSData *imageData = UIImageJPEGRepresentation(eachImage,0.5);
            //[formData appendPartWithFileData:imageData name:@"avatar" fileName:[NSString stringWithFormat:@"file%d.jpg",i ] mimeType:@"image/jpeg"];
            [formData appendPartWithFileData:imageData name:@"avatar" fileName:fileName mimeType:@"image/jpeg"];
            
            i++;
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        [delegate client:self sendLoginPicSuccess:(NSMutableDictionary*)responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
}

/*
- (void) take_pics: (UIImage*) image withUserID:(NSString*) userID withUserName:(NSString*) userName withLat:(NSString*)lat withLng:(NSString*)lng
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    //NSLog(@"key inside signup_pics is %@", userID);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* fileName = [NSString stringWithFormat:@"%@/%@/%@/%@/.jpg", userName, userID, lat, lng];
    
    AFHTTPRequestOperation *op = [manager POST:@"/user/uploadPhoto?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            //[formData appendPartWithFileData:imageData name:@"avatar" fileName:[NSString stringWithFormat:@"file%d.jpg",i ] mimeType:@"image/jpeg"];
            [formData appendPartWithFileData:imageData name:@"avatar" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        [delegate client:self sendLoginPicSuccess:(NSMutableDictionary*)responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    
}
 */

- (void) shareImages: (NSMutableArray*) image withUserID:(NSString*) userID withUserName:(NSString*) userName withLat:(NSMutableArray*)lat withLng:(NSMutableArray*)lng withDate:(NSMutableArray*) date
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    //NSLog(@"key inside signup_pics is %@", userID);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    AFHTTPRequestOperation *op = [manager POST:@"/user/uploadPhoto?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        int i = 0;
        for(UIImage *eachImage in image)
        {
            NSData *imageData = UIImageJPEGRepresentation(eachImage,0.5);
            //NSLog(@" userName, userID, lat, lng, date, time is %@/%@/%@/%@/%@/%@.jpg", userName, userID, lat[i], lng[i], date[i], time[i]);
             NSString* fileName = [NSString stringWithFormat:@"%@/%@/%@/%@/%@.jpg", userName, userID, lat[i], lng[i], date[i]];
            [formData appendPartWithFileData:imageData name:@"avatar" fileName:fileName mimeType:@"image/jpeg"];
            
            i++;
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        NSDictionary *json = (NSDictionary *)responseObject;
        NSMutableArray *photoData = [json objectForKey:@"photos"];
        [delegate client:self shareImagesSuccess:(NSMutableDictionary*)photoData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    
}

//user/savePhotoData?photoId=1&userId=1&userId=2

- (void) shareMetadata: (NSMutableArray*) imageMetaData
{
    
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:imageMetaData forKey:@"photos"];
    //[params setValue:@"testUser" forKey:@"userId"];

    [manager POST:@"/user/savePhotoData?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *success = [responseObject objectForKey:@"sucess"];
        NSLog(@"JSON: %@", responseObject);
        [delegate client:self savePhotoDataSuccess:success];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


- (void) get_pics: (NSString*) userID withUserName:(NSString*) userName startIndex:(NSInteger)start endIndex:(NSInteger)end
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    //NSLog(@"key inside signup_pics is %@", userID);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //NSString* fileName = [NSString stringWithFormat:@"%@/%@/%@/%@/", userName, userID, lat, lng];
    params[@"key"] = userID;
    params[@"userName"] = userName;
    
    [manager GET:@"user/getPhotos?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         [delegate client:self sendWithData:responseObject ];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}
- (void) get_recepientPics: (NSString*) userID withUserName:(NSString*) userName startIndex:(NSInteger)start endIndex:(NSInteger)end
{
    NSLog(@"inside get_recepientPics");
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    //NSLog(@"key inside signup_pics is %@", userID);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //NSString* fileName = [NSString stringWithFormat:@"%@/%@/%@/%@/", userName, userID, lat, lng];
    params[@"key"] = userID;
    //params[@"userName"] = userName;
    
    [manager POST:@"user/getRecipientPhotos?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         [delegate client:self sendWithRecepientData:responseObject ];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}

- (void) get_imInPics: (NSString*) userID withUserName:(NSString*) userName startIndex:(NSInteger)start endIndex:(NSInteger)end
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    //NSLog(@"key inside signup_pics is %@", userID);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //NSString* fileName = [NSString stringWithFormat:@"%@/%@/%@/%@/", userName, userID, lat, lng];
    params[@"key"] = userID;
    //params[@"userName"] = userName;
    
    [manager GET:@"user/getNearPhotos?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         [delegate client:self sendWithImInData:responseObject ];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}

- (void) updateLocation: (NSString*) key withLat:(NSString*) lat withLng:(NSString*) lng
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = key;
    params[@"lat"] = lat;
    params[@"lng"] = lng;
    
    [manager POST:@"/user/updateLocation?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"in updateLocation JSON: %@", responseObject);
         NSDictionary *json = (NSDictionary *)responseObject;
         NSLog(@"after json dictionary before arry");
         //NSArray *data = [json objectForKey:@"latestDeals"];
         [delegate client:self sendUpdateLocationSuccess:json];//to:@"getLatestDeals"];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

-(void) addFriend: (NSString*) userName toUser:(NSString*) friendUser
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = userName;
    params[@"requested"] = friendUser;
    
    [manager POST:@"/user/addFriend?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *json = (NSDictionary *)responseObject;
         NSLog(@"after json dictionary before arry");
         //NSArray *data = [json objectForKey:@"latestDeals"];
         [delegate client:self sendFriendSuccess:json];//to:@"getLatestDeals"];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}

-(void) getFriends: (NSString*) userName
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = userName;
    
    [manager POST:@"/user/getFriends?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         NSMutableArray *json = (NSMutableArray *)responseObject;
         //NSLog(@"after json dictionary before arry");
         [delegate client:self getFriendSuccess:json];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}


@end

