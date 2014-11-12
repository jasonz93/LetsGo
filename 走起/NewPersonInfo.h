//
//  NewPersonInfo.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/10/14.
//
//

#import <UIKit/UIKit.h>
#import "GetInfo.h"
#import "PersonInfoCell.h"
#import "LevelCell.h"
#import "MBProgressHUD.h"
#import "ASPopUpView.h"
#import "ASProgressPopUpView.h"
#import "ActivityIntroCell.h"
#import "ActivityTable.h"
#import "LevelCell.h"
@interface NewPersonInfo : UITableViewController<MBProgressHUDDelegate,UIActionSheetDelegate>{
    NSData *UserLogo;
    NSString *UserName;
    NSString *SchoolName;
    float UserPraise;
    NSMutableData *RevData;
    NSDictionary *DataDic;
    NSArray *MyADic;
    NSInteger Uid;
    NSString *MyToken;
    
    
    BOOL MyAC;
    BOOL PersonCellLoaded;
}
@property (strong, nonatomic) IBOutlet UITableView *InfoTable;

@end
