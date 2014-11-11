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
-(void) initWithImg:(NSData *)img Title:(NSString *)title Time:(NSString *)Atime Place:(NSString *)place PeopleMax:(NSString *)PMax PeopleJioned:(NSString *)Pj{
    self.ActivityImg.image=[UIImage imageWithData:img];
    self.AtitleL.text=title;
    self.AtimeL.text=Atime;
    self.AplaceL.text=place;
    self.ApeopleMaxL.text=[NSString stringWithFormat:@"人数限额：%@",PMax];
    self.ApeopleL.text=[NSString stringWithFormat:@"已参加：%@ 人",Pj];
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"page"]];
}


@end
