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

- (void) recognize_image: (NSMutableArray*)faces file_name: (NSString*)name
{
    NSMutableArray *names = [[NSMutableArray alloc] init];

    __block BOOL *finishedBlock;
    finishedBlock = false;
    
    for (int i=0; i < faces.count; i++)
    {
        UIImage *localImage = [faces objectAtIndex:(NSInteger) i];
      
        finishedBlock = false;
        
        NSLog(@"i is %d", i);
        [KairosSDK recognizeWithImage:localImage
                            threshold:@".6"
                          galleryName:@"gallery2"
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

@end

