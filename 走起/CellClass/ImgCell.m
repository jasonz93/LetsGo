//
//  ImgCell.m
//  zouqi
//
//  Created by 周瑞琦 on 11/3/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import "ImgCell.h"

@implementation ImgCell

- (void)awakeFromNib {
    
        // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"SELECTED");
    // Configure the view for the selected state
}

-(void)SetActivityImage:(NSData*)data;
{
    if(data!=nil)
        
        self.TopImg.image=[UIImage imageWithData:data];
}


@end
