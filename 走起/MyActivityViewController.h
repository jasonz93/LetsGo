//
//  SecondViewController.h
//  zouqi
//
//  Created by 周瑞琦 on 10/31/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetInfo.h"
#import "ActivityIntroCell.h"
//#import "ActivityDetailViewController.h"
//#import "CommonVariable.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"
#import "ActivityTable.h"
@interface MyActivityViewController : UITableViewController<MBProgressHUDDelegate>{
    NSArray *AingDic,*AedDic;
    NSString *mytoken;
    NSInteger Uid;
}

@property NSMutableData *RevData;
@property BOOL CellInited;
@property (strong, nonatomic) IBOutlet UITableView *ActivityList;



-(void) ProcessData;
-(void) GetMyAList;
-(void) initRefreshControl;
@end

