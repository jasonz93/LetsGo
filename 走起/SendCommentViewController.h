//
//  SendCommentViewController.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/7/14.
//
//

#import <UIKit/UIKit.h>
#import "GetInfo.h"
#import "Common.h"
@interface SendCommentViewController : UIViewController
{
    NSString *SendCommentURL;
    NSMutableData *ResultData;
    BOOL keyboardVisible;
}
@property (weak, nonatomic) IBOutlet UIScrollView *Scroll;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SendButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CancelButton;
@property (weak, nonatomic) IBOutlet UITextView *CommentContentTxt;
@property NSString *Aid;
@end
