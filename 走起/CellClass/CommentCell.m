//
//  ImgCell.m
//  zouqi
//
//  Created by 周瑞琦 on 11/3/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    
        // Initialization code
}

-(void) initWithComment:(NSString*)Comment
{
    self.CommentContent.text=Comment;
}
//我要重写你initWithFrame:<#(CGRect)#>
@end
