//
//  ActivityDetailViewController.m
//  zouqi
//
//  Created by 周瑞琦 on 11/2/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import "ActivityDetailViewController.h"

#define JionActivityURL @"http://www.douban.com/j/app/radio/people"

@interface ActivityDetailViewController ()
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"ADView Aid is %d",self.Activity_Id);
    [segue.destinationViewController setValue:[NSString stringWithFormat:@"%d",self.Activity_Id] forKey:@"Aid"];
}

- (IBAction)RequestJion:(id)sender {
    NSLog(JionActivityURL);
    HTTPPost *JionActivityRequest=[[HTTPPost alloc]initWithArgs:JionActivityURL postData:[self.PostData dataUsingEncoding:NSUTF8StringEncoding] resultData:self.ResultData sender:self onSuccess:@selector(ReceiveSuccess) onError:nil];
    [JionActivityRequest Run];
}

-(void)ReceiveSuccess{
    NSLog(@"Recevie Data");
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
