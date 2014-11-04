//
//  ImgCell.h
//  zouqi
//
//  Created by 周瑞琦 on 11/3/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *TopImg;
-(void)SetActivityImage:(NSData*)data;


@end
