//
//  NewHotActivityController.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/9/14.
//
//

#import <UIKit/UIKit.h>
#import "ActivityNewView.h"
#import "MBProgressHUD.h"
#import "GetInfo.h"
#import "ActivityTable.h"
//#import "ActivityDetailViewController.h"
#define RTopHeight 64
#define RtotalHeight 93
@interface NewHotActivityController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate,UIPageViewControllerDelegate,UIGestureRecognizerDelegate>
{
    BOOL pageControlUsed;
    NSArray *AList;
    NSMutableData*RevData;
    UIScrollView *ASV;
    UIPageControl *PGC;
    UITapGestureRecognizer* SingleTap;
    
    NSString *Mytoken;
}

-(void)PageValueChanged;
@end
