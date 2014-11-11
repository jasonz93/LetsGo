//
//  ActivityImgTitleCell.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/8/14.
//
//

#import <UIKit/UIKit.h>

@interface ActivityImgTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ActivityImg;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTimeL;
@property (weak, nonatomic) IBOutlet UILabel *ActivityPlaceL;
@property (weak, nonatomic) IBOutlet UILabel *ActivityOwnerL;


-(void)initWithImg:(NSData*)NewImg Title:(NSString*)NewTitle Place:(NSString*)Newplace Time:(NSString*)newtime Owner:(NSString*)newowner;

@end
