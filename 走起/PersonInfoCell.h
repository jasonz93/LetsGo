//
//  PersonInfoCell.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/10/14.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
@interface PersonInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UserImg;
@property (weak, nonatomic) IBOutlet UILabel *UserNameL;
@property (weak, nonatomic) IBOutlet UILabel *SchoolNameL;
@property (weak, nonatomic) IBOutlet UILabel *PraiseL;


-(void)initWithUserLogo:(NSString*)Uimg UserName:(NSString*)Uname Schoolname:(NSString*)schoolname Praise:(NSNumber*)Praise;
@end
