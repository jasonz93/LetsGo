//
//  FirstViewController.m
//  走起
//
//  Created by Nicholas on 14-10-30.
//  Copyright (c) 2014年 Nicholas. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()


@end

@implementation FirstViewController

@synthesize text;

-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce//手势方法
{
    [self.text resignFirstResponder];
}

-(IBAction)textFieldDidBeginEditing:(id)sender
{
    UITextField * textField = (UITextField *)sender;
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 225.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(IBAction)textFieldDidEndEditing:(id)sender
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self tapBackground];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在登录" delegate:self cancelButtonTitle: nil otherButtonTitles: nil];
    
    [myAlertView show];
}


@end
