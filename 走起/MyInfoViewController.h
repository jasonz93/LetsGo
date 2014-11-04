//
//  MyInfoViewController.h
//  zouqi
//
//  Created by 周瑞琦 on 10/31/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ActivityIng 0
#define ActivityEd 1
#ifndef PersonalInfoPostLink
#define PersonalInfoPostLink "http://www.douban.com/j/app/radio/people"
#endif


@interface MyInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
   

}
@property ( nonatomic, retain) NSArray *ActivityList_ing;
@property ( nonatomic, strong) NSMutableData *ActivityList_ingData;
@property ( nonatomic, copy) NSArray *ActivityList_ed;
@property ( nonatomic, retain) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *User_Name;
@property (weak, nonatomic) IBOutlet UILabel *User_School;
@property (weak, nonatomic) IBOutlet UIImageView *User_Icon;
@property (weak, nonatomic) IBOutlet UITableView *Activity_Info;
@property (weak, nonatomic) IBOutlet UIImageView *User_Good_Reputation;
@property (nonatomic) NSInteger *DealJsonOK;


-(void)showErrorMessage;
-(void)DealWithJsonData;

@end