//
//  GroupCell.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/10/14.
//
//

#import "LevelCell.h"

@implementation LevelCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)ShowPop{
    [LC showPopUpViewAnimated:YES];
}

-(void)initWithPraise:(float)Praise{
    LC=[[ASProgressPopUpView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width/2-150, 80,300, 30)];
    LC.dataSource=self;
    LC.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:26];
    LC.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    LC.popUpViewCornerRadius = 16.0;
    LC.progress=Praise/200;
    myPraise=Praise;
    [self addSubview:LC];
    NSLog(@"Creat Level Cell");
}


- (void)progress
{
    NSLog(@"Progrssss");
    //static BOOL ViewPopView=YES;
    float Lprogress = LC.progress;
    if (Lprogress < myPraise/200) {
        Lprogress+=0.04;
        [LC setProgress:Lprogress animated:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.05
                                         target:self
                                       selector:@selector(progress)
                                       userInfo:nil
                                        repeats:NO];
        
    }
}


- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    return @"➕";
}

/*
-(void)initWithGroupImg:(NSData*)Img Name:(NSString*)name Intro:(NSString*)intro{
    self.GroupImg.image=[UIImage imageWithData:Img];
    self.GroupIntroL.text=intro;
    self.GroupNameL.text=name;
}*/

    // Configure the view for the selected state

@end
