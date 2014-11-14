//
//  ActivityIntroCell.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/4/14.
//
//

#import "ActivityIntroCell.h"

@implementation ActivityIntroCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)initwithTitle:(NSString*)NewTitle Img:(NSString*)NewImg BeginTime:(NSString*)TheBeginTime EndTime:(NSString*)TheEndTime Place:(NSString*)NewPlace{
    self.ActivityTitle.text=NewTitle;
    //self.ActivityImg.image=[UIImage imageWithData:NewImg];
    [Common loadPic:NewImg imageView:self.ActivityImg];
    self.ActivityPlaceLabel.text=NewPlace;
    self.ActivityBeginTimeLabel.text=TheBeginTime;
    [self.ActivityImg.layer setMasksToBounds:YES];
    [self.ActivityImg.layer setCornerRadius:10];
    [self.ActivityImg.layer setBorderWidth:1];
    [self.ActivityImg.layer setBorderColor:[[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f]CGColor]];
    
    //self.ActivityEndTimeLabel.text=TheEndTime;
}


@end
