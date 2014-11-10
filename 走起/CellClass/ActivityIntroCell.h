//
//  ActivityIntroCell.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/4/14.
//
//

#import <UIKit/UIKit.h>

@interface ActivityIntroCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ActivityImg;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTitle;
@property (weak, nonatomic) IBOutlet UILabel *ActivityEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityPlaceLabel;



-(void)initwithTitle:(NSString*)NewTitle Img:(NSData*)NewImg BeginTime:(NSString*)TheBeginTime EndTime:(NSString*)TheEndTime Place:(NSString*)NewPlace;
@end
