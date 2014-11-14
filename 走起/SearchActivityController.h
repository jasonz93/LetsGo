//
//  SearchActivityController.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/13/14.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
@interface SearchActivityController : UITableViewController{
    
    NSMutableArray *actlist;
    NSMutableData *searchdata;
    BOOL shouldTouch;
    BOOL cellloaded;
    NSArray *ADic;
}
@property (strong, nonatomic) IBOutlet UITableView *ATable;
@property (weak, nonatomic) IBOutlet UISearchBar *ASearch;

@end
