//
//  ActivityImgTitleCell.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/8/14.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
@interface ActivityImgTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ActivityImg;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTimeL;
@property (weak, nonatomic) IBOutlet UILabel *ActivityPlaceL;
@property (weak, nonatomic) IBOutlet UILabel *ActivityOwnerL;
@property (weak, nonatomic) IBOutlet UILabel *EndTime;


-(void)initWithImg:(NSString*)NewImg Title:(NSString*)NewTitle Place:(NSString*)Newplace Time:(NSString*)newtime   NewEndTime:(NSString*)NewEndtime Owner:(NSString*)newowner;

@end
