//
//  CommentDetailView.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/14/14.
//
//

#import <UIKit/UIKit.h>
#import "CommentCell.h"
#import "Common.h"
#import "GetInfo.h"
@interface CommentDetailView : UITableViewController
{
    BOOL CommentCellLoaded;
    NSArray *Clist;
    NSMutableData *RevData;
}
@property (strong, nonatomic) IBOutlet UITableView *CommentList;
@property NSString *Aid;
@end
