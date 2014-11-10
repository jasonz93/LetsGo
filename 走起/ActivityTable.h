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
#import "ActivityPoint.h"

#define AImgIndex 0
#define ATitleIndex 1
#define AOwnerIndex 2
#define AOrginazationIndex 3
#define ATimeIndex 4
#define APlaceIndex 5
#define APeopleIndex 6
#define AContentIndex 7
#define ACommentTopIndex 8


@interface ActivityTable : UITableViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSMutableData *AData;
    NSDictionary *AData_Dic;
    NSArray *AComment;
    CLLocation *ActivityLocation;

}



@property (weak, nonatomic) IBOutlet UITableViewCell *ContentCell;
@property (weak, nonatomic) IBOutlet MKMapView *ActivityMap;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ActivityImg;
@property (weak, nonatomic) IBOutlet UILabel *ActivityOriginatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityOrganizationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTimeBeginLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTimeEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityPeopleLabel;
@property (weak, nonatomic) IBOutlet UITextView *ActivityContent;

@property (strong, nonatomic) IBOutlet UITableView *ATableView;
@property NSString *Aid;



-(void)ReloadActivityData;
-(void) initRefreshControl;
-(void) RefreshATable;
-(void) GetActivityDetail;
@end
