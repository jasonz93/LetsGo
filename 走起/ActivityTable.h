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
#ifndef ATable
#define ATable

#define AImgIndex 0
#define ATitleIndex 1
#define AOwnerIndex 2
#define AOrginazationIndex 3
#define ATimeIndex 4
#define APlaceIndex 5
#define APeopleIndex 6
#define AContentIndex 7
#define ACommentTopIndex 8

#define AImgH 0//200
#define ATitleH 1//20
#define AOwnerH 2//15
#define AOrginazationH  3//15
#define ATimeH 4
#define APlaceH 5//173
#define APeopleH  6//15
#define AContentH   7
#define ACommentTitleH   8
#define ACommentH   9
#endif

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
    NSInteger ship_id;
    NSString *PicURL;
    UIImageView *ActivityPic;
    NSMutableData *JResult;
}




@property (strong, nonatomic) IBOutlet UITableView *ATableView;
@property NSString *Aid;
@property CGSize ScreenSize;


//-(void)ReloadActivityData;
-(void) initRefreshControl;
-(void) RefreshATable;
-(void) GetActivityDetail;
@end
