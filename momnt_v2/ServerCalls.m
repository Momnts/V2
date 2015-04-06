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

- (void) recognize_image: (NSMutableArray*)faces file_name: (NSString*) name
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
 

- (void) train_image:(UIImage*)image file_name:(NSString*)name person_id:(NSString*)pid
{
    UIImage *localImage = image;
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

@end

