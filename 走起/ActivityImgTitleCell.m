//
//  ActivityImgTitleCell.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/8/14.
//
//

#import "ActivityImgTitleCell.h"

@implementation ActivityImgTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



-(void)initWithImg:(NSString*)NewImg Title:(NSString*)NewTitle Place:(NSString*)Newplace Time:(NSString*)newtime NewEndTime:(NSString*)NewEndtime Owner:(NSString*)newowner{
    NSLog(@"Load Activity Head Cell");
   // self.ActivityImg.image=[UIImage imageWithData:NewImg];
    [Common loadPic:NewImg imageView:self.ActivityImg];
    self.ActivityTitleLabel.text=NewTitle;
    self.ActivityOwnerL.text=newowner;
    self.ActivityTimeL.text=[NSString stringWithFormat:@"于 %@" ,newtime];
    self.ActivityPlaceL.text=Newplace;
    self.EndTime.text=[NSString stringWithFormat:@"至 %@",NewEndtime];
    [self.ActivityImg.layer setMasksToBounds:YES];
    [self.ActivityImg.layer setCornerRadius:10];
    [self.ActivityImg.layer setBorderWidth:1];
    [self.ActivityImg.layer setBorderColor:[[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f]CGColor]];
    
}
    // Configure the view for the selected state

@end
