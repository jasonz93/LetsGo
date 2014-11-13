//
//  LoginView.h
//  走起
//
//  Created by Nicholas on 14-10-31.
//  Copyright (c) 2014年 Nicholas. All rights reserved.
//

#ifndef ___LoginView_h
#define ___LoginView_h

#import <UIKit/UIKit.h>

@interface LoginView : UIViewController{
    IBOutlet UITextField *txtPaswd;
    IBOutlet UIActivityIndicatorView *act;
    IBOutlet UINavigationItem *navtitle;
    
}
@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) UITextField *txtPaswd;
@property IBOutlet UIButton *btnLogin;
@property NSMutableData *loginData;
@property (retain) UIActivityIndicatorView *act;
@property (retain) UINavigationItem *navtitle;
@property IBOutlet UIButton *btnReg;

@end


#endif
