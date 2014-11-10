//
//  OrgDetailViewController.h
//  LetsGo
//
//  Created by Nicholas on 14/11/6.
//
//

#ifndef LetsGo_OrgDetailViewController_h
#define LetsGo_OrgDetailViewController_h

#import <UIKit/UIKit.h>
#import "Common.h"

@interface OrgDetailViewController : UIViewController

@property clsOrg *org;
@property IBOutlet UITextField *txtOrgName;
@property IBOutlet UITextView *txtOrgContent;
@property IBOutlet UIImageView *imgOrgLogo;
@property IBOutlet UIButton  *btnJoin;

@end

#endif
