//
//  OrgActListViewController.h
//  LetsGo
//
//  Created by Nicholas on 14/11/14.
//
//

#ifndef LetsGo_OrgActListViewController_h
#define LetsGo_OrgActListViewController_h

#import <UIKit/UIKit.h>
#import "Common.h"
#import "GetInfo.h"
#import "ActivityIntroCell.h"
#import "ActivityTable.h"

@interface OrgActListViewController : UITableViewController

@property NSMutableData *actData;
@property NSMutableArray *actList;
@property BOOL CellInited;
@property clsOrg *org;
@property clsSchool *school;

@end

#endif
