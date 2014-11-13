//
//  PersonInfoCell.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/10/14.
//
//

#import "PersonInfoCell.h"

@implementation PersonInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)initWithUserLogo:(NSString*)Uimg UserName:(NSString*)Uname Schoolname:(NSString*)schoolname Praise:(NSNumber*)Praise{
    [Common loadPic:Uimg imageView:self.UserImg];
    [self.UserImg.layer setMasksToBounds:YES];
    [self.UserImg.layer setCornerRadius:10];
    [self.UserImg.layer setBorderWidth:1];
    [self.UserImg.layer setBorderColor:[[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f]CGColor]];
    self.UserNameL.text=Uname;
    self.SchoolNameL.text=schoolname;
    self.PraiseL.text=[NSString stringWithFormat:@"%d",Praise];
}

    // Configure the view for the selected state

@end
