//
//  ActivityNewView.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/10/14.
//
//

#import "ActivityNewView.h"

@implementation ActivityNewView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void) initWithImg:(NSString *)img Title:(NSString *)title Time:(NSString *)Atime TimeEnd:(NSString*)Timeend Place:(NSString *)place PeopleMax:(NSString *)PMax PeopleJioned:(NSString *)Pj{
    //self.ActivityImg.image=[UIImage imageWithData:img];
    [Common loadPic:img imageView:self.ActivityImg];
    self.AtitleL.text=title;
    self.AtimeL.text=[NSString stringWithFormat:@"于：%@",Atime];
    self.AtimeendL.text=[NSString stringWithFormat:@"至：%@",Timeend];
    self.AplaceL.text=place;
    self.ApeopleMaxL.text=[NSString stringWithFormat:@"人数限额：%@ ",PMax];
    self.ApeopleL.text=[NSString stringWithFormat:@"已参加：%@ 人",Pj];
    [self.ActivityImg.layer setMasksToBounds:YES];
    [self.ActivityImg.layer setCornerRadius:10];
    [self.ActivityImg.layer setBorderWidth:1];
    [self.ActivityImg.layer setBorderColor:[[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f]CGColor]];
    
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"121313213"]];
}


@end
