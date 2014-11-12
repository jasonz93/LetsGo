//
//  MyOrgViewController.h
//  LetsGo
//
//  Created by Nicholas on 14/11/5.
//
//

#ifndef LetsGo_MyOrgViewController_h
#define LetsGo_MyOrgViewController_h

#import <UIKit/UIKit.h>
#import "Common.h"
#import "GetInfo.h"

@interface MyOrgViewController : UITableViewController{
    IBOutlet UIBarButtonItem *btnJoinOrg;
}

@property IBOutlet UITableView *tblOrgs;

-(void)refreshOrgs;

@end

#endif
