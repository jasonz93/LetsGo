//
//  GroupCell.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/10/14.
//
//

#import <UIKit/UIKit.h>
#import "ASProgressPopUpView.h"
@interface LevelCell : UITableViewCell<ASProgressPopUpViewDataSource>{
    ASProgressPopUpView *LC;
    float myPraise;

}
-(void)initWithPraise:(float)Praise;
-(void)ShowPop;
//-(void)initWithGroupImg:(NSData*)Img Name:(NSString*)Name Intro:(NSString*)intro;
@end
