//
//  ActivityDetailViewController.h
//  zouqi
//
//  Created by 周瑞琦 on 11/2/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"GetInfo.h"
#import "ImgCell.h"

#define ActvtImgCell 0
#define ActvtNameCell 1
#define ActvtOriginatorCell 2
#define ActvtTimeCell 3
#define ActvtAdressCell 4
#define ActvtPeopleCell 5
//#define ActvtDetailCell 6


@interface ActivityDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _reloading;
    //EGORefreshTableHeaderView *_refreshHeaderView;
    NSData *ActivityBigImgURL,*ActivityLogo;
    NSString *ActivityTitle,*ActivityOrganizationName,*ActivityOriginatorName,*ActivityContent,*ActivityPlace,*ActivityPlaceXYZ,*ActivityTime,*ActivityDuration,*ActivityPeopleMAX,*ActivityPeopleNumber;
}


@property NSInteger Activity_Id;
@property (weak, nonatomic) IBOutlet UITableView *ActivityDetailView;
@property BOOL ImgCellLoaded;
@property NSMutableData *ResultData;



/*- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;*/
- (void)ProcessData;


@end
