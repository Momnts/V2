//
//  FriendList.m
//  momnt_v2
//
//  Created by Naren Sathiya on 5/5/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "FriendList.h"


@implementation FriendList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame image:(NSInteger)intg withFace:(NSInteger)fintg
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //[self myInitialization];
        NSLog(@"making new array");
        self.names = [[NSMutableArray alloc] init];
        self.faceNo = fintg;
        self.imageNo = intg;
    }
    
    
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.names = [[User currentUser] returnFriendsList];
    return self.names.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImgCell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    long row = [indexPath row];
    
    self.names = [[User currentUser] returnFriendsList];
    cell.textLabel.text = [self.names objectAtIndex:row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell name is %@, image number is %ld and face number is %ld", cell.textLabel.text, (long)self.imageNo, (long)self.faceNo);
    //ShareImgCell *superCell = (ShareImgCell*)self.superview;
    //superCell
    self.hidden = YES;
    
}



@end
