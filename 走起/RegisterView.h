//
//  RegisterView.h
//  走起
//
//  Created by Nicholas on 14-11-1.
//  Copyright (c) 2014年 Nicholas. All rights reserved.
//

#ifndef ___RegisterView_h
#define ___RegisterView_h

#define _REG_SUCCESS_ 0
#define _REG_PERSON_EXIST_ 2
#define _REG_EMAIL_EXIST_ 1
#define _REG_PASWD_SHORT_ 3

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



@interface RegisterView : UIViewController{
    IBOutlet UITextField *txtPaswd;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtSid;
    IBOutlet UITextField *txtSpwd;
    IBOutlet UISearchBar *txtSchool;
    IBOutlet UITableView *schoolSearchView;

}

@property UITextField *txtPaswd;
@property IBOutlet UITextField *txtPaswdConfirm;
@property UITextField *txtEmail;
@property UITextField *txtSid;
@property UITextField *txtSpwd;
@property UISearchBar *txtSchool;
@property NSMutableData *registerData;
@property NSMutableData *locData;
@property (nonatomic, strong) CLLocationManager *locMgr;
@property UITableView *schoolSearchView;
@property NSMutableArray *dataList;
@property NSMutableData *searchData;
@property IBOutlet UIButton *btnReg;
@property UIImagePickerController *picker;
@property IBOutlet UIImageView *imgIcon;

//-(void)stest;


@end




#endif
