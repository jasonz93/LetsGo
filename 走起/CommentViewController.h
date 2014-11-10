//
//  CommentViewController.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/6/14.
//
//

#import <UIKit/UIKit.h>
#import"CommentCell.h"
#import "GetInfo.h"
@interface CommentViewController : UITableViewController{
    NSMutableData *ResultData;
    NSArray *CommentList;
}

-(void)GetComment;
-(void)DealWithData;

@property (strong, nonatomic) IBOutlet UITableView *CommentTableView;
@property NSString *Aid;
@end
