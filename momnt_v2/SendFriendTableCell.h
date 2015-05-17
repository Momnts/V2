//
//  SendFriendTableCell.h
//  momnt_v2
//
//  Created by Naren Sathiya on 5/13/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendFriendTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *activateButton;
- (IBAction)activate:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *friendName;

@end
