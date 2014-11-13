//
//  ActivityTable.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/5/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import"GetInfo.h"
#import "CommentCell.h"
//#import "ActivityPoint.h"
//#import "CommonVariable.h"
#import "MBProgressHUD.h"
//#import "Common.h"
#import "ActivityImgTitleCell.h"
//#import "TimeMapCell.h"
//#import "CommentTableCell.h"
#import "SendCommentViewController.h"

@interface ActivityTable : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,MBProgressHUDDelegate>
{
    NSMutableData *AData;
    NSDictionary *AData_Dic;
    NSArray *AComment;
    CLLocation *ActivityLocation;
    float ContentH;
    float ScreenH;
    BOOL Ajioned;
    BOOL Afinished;
    NSString *ImgURL;
    NSString *TitleTxt;
    NSString *OwnerTxt;
    NSString *OrginizationTxt;
    NSString *TimeTxt;
    NSString *PlaceTxt;
    NSString *PeopleTxt;
    UITextView *ContentTxT;
    UIButton *SendCommentBtn;
    UILabel *BtnL,*ContentTitle;
    BOOL ImgAndTitleCellLoaded;
    BOOL CommentTableCellLoaded;
    int ButtonStyle;
    NSError *Error;
    NSString *Mytoken;
    NSMutableData *PostReslut;
    BOOL CommentCellLoaded;
    NSNumber *ship_id;
    NSString *PicURL;
    UIImageView *ActivityPic;
}




@property (strong, nonatomic) IBOutlet UITableView *ATableView;
@property NSString *Aid;
@property CGSize ScreenSize;


//-(void)ReloadActivityData;
-(void) initRefreshControl;
-(void) RefreshATable;
-(void) GetActivityDetail;
@end
