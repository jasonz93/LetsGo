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
    
-(void)initWithUserLogo:(NSData*)Uimg UserName:(NSString*)Uname Schoolname:(NSString*)schoolname Praise:(int)Praise{
    NSLog(@"IN!!");
    self.UserImg.image=[UIImage imageWithData:Uimg];
    self.UserNameL.text=Uname;
    self.SchoolNameL.text=schoolname;
    self.PraiseL.text=[NSString stringWithFormat:@"%d",Praise];
}

    // Configure the view for the selected state

@end
