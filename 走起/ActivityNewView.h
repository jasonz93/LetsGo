//
//  ActivityNewView.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/10/14.
//
//

#import <UIKit/UIKit.h>

@interface ActivityNewView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *ActivityImg;
@property (weak, nonatomic) IBOutlet UILabel *AtitleL;
@property (weak, nonatomic) IBOutlet UILabel *AtimeL;
@property (weak, nonatomic) IBOutlet UILabel *AplaceL;
@property (weak, nonatomic) IBOutlet UILabel *ApeopleMaxL;
@property (weak, nonatomic) IBOutlet UILabel *ApeopleL;

-(void)initWithImg:(NSData*)img Title:(NSString*)title Time:(NSString*)Atime Place:(NSString*)place PeopleMax:(NSString*)PMax PeopleJioned:(NSString*)Pj;

@end
