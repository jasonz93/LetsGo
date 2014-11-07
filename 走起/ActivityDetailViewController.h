//
//  ActivityDetailViewController.h
//  zouqi
//
//  Created by 周瑞琦 on 11/2/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"Common.h"
#import"ActivityTable.h"


@interface ActivityDetailViewController : UIViewController
{
    
}


@property (weak, nonatomic) IBOutlet UIView *ATableContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *JionButton;
@property NSInteger Activity_Id;
@property NSMutableData *ResultData;
@property NSString *PostData;


-(void)ReceiveSuccess;
@end
