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



-(void)initWithImg:(NSData*)NewImg Title:(NSString*)NewTitle Place:(NSString*)Newplace Time:(NSString*)newtime Owner:(NSString*)newowner{
    NSLog(@"Load Activity Head Cell");
    self.ActivityImg.image=[UIImage imageWithData:NewImg];
    self.ActivityTitleLabel.text=NewTitle;
    self.ActivityOwnerL.text=newowner;
    self.ActivityTimeL.text=newtime;
    self.ActivityPlaceL.text=Newplace;
}
    // Configure the view for the selected state

@end
