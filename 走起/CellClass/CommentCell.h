//
//  ImgCell.h
//  zouqi
//
//  Created by 周瑞琦 on 11/3/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UserLogo;
@property (weak, nonatomic) IBOutlet UILabel *CommentContent;
@property (weak, nonatomic) IBOutlet UILabel *User_name;


-(void) initWithComment:(NSString*)Comment ;
@end
