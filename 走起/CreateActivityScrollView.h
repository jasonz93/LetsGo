//
//  CreateActivityScrollView.h
//  LetsGo
//
//  Created by Nicholas on 14/11/5.
//
//

#ifndef LetsGo_CreateActivityScrollView_h
#define LetsGo_CreateActivityScrollView_h

#import <UIKit/UIKit.h>
#import "Common.h"

@interface CreateActivityScrollView : UIScrollView{
    
}

@property IBOutlet UITextField *txtActTitle;
@property IBOutlet UITextView *txtActContent;
@property IBOutlet UITextField *txtActPlace;
@property IBOutlet UITextField *txtActTime;
@property IBOutlet UITextField *txtActDur;
@property IBOutlet UITextField *txtActCap;
@property IBOutlet UITextField *txtActOrg;
@property IBOutlet UIImageView *imgActLogo;
@property IBOutlet UIImageView *imgActPic;
@property IBOutlet UIView *view;
@property IBOutlet UIViewController *controller;
@property IBOutlet UIBarButtonItem *btnCommit;


-(void)hideActTime;
-(void)initScrollView;

@end

#endif
