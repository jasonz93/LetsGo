//
//  SearchOrgViewController.h
//  LetsGo
//
//  Created by Nicholas on 14/11/5.
//
//

#ifndef LetsGo_SearchOrgViewController_h
#define LetsGo_SearchOrgViewController_h

#import <UIKit/UIKit.h>
#import "Common.h"
#import "GetInfo.h"

@interface SearchOrgViewController : UIViewController

@property IBOutlet UITableView *tblOrgs;
@property IBOutlet UISearchBar *txtSearch;

@end

#endif
