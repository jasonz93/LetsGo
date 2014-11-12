//
//  CreateActivityViewController.h
//  LetsGo
//
//  Created by Nicholas on 14/11/4.
//
//

#ifndef LetsGo_CreateActivityViewController_h
#define LetsGo_CreateActivityViewController_h

#import <UIKit/UIKit.h>
#import "Common.h"
#import "GetInfo.h"
#import "CreateActivityViewController.h"

@interface tblActOrgDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>


@property NSMutableArray *orgDataList;
@property NSMutableData *orgData;
@property UITableView *tblActOrg;
@property SEL onClicked;
@property clsOrg *selectOrg;
@property id sender;

-(id)initWithTableView:(UITableView *)tbl sender:(id)sender onClick:(SEL)onClick;

@end

@interface CreateActivityViewController : UIViewController
{
    
}

@property UITextField *txtActTitle;
@property UITextView *txtActContent;
@property UITextField *txtActPlace;
@property UITextField *txtActTime;
@property UITextField *txtActEnd;
@property UIDatePicker *dateActTime;
@property UIDatePicker *dateActEnd;
@property UITextField *txtActCap;
@property UITextField *txtActOrg;
@property UIImageView *imgActLogo;
@property UIImageView *imgActPic;
@property UIBarButtonItem *btnCommit;
@property UIButton *btnLocate;
@property UIButton *btnLogo;
@property UIButton *btnPic;
@property NSNumber *lat;
@property NSNumber *lon;
@property UITableView *tblActOrg;
@property NSMutableData *logoUrlData;
@property NSMutableData *picUrlData;
@property NSString *logoUrl;
@property NSString *picUrl;
@property UIImagePickerController *picPicker;
@property UIImagePickerController *logoPicker;
@property tblActOrgDelegate *tblActOrgDele;

@property IBOutlet UITableView *tblMain;

@end



#endif
