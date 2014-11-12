//
//  LoginView.m
//  走起
//
//  Created by Nicholas on 14-10-31.
//  Copyright (c) 2014年 Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginView.h"
#import "Common.h"

@interface LoginView ()<UITextFieldDelegate>
    

@end

@implementation LoginView

@synthesize txtPaswd;
@synthesize act;
@synthesize navtitle;
@synthesize loginData;


-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce//手势方法
{
    [self.txtEmail resignFirstResponder];
    [self.txtPaswd resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tapOnce];
    return YES;
}

//login:/users/sign_in
-(IBAction)Login:(id)sender{
    [self.act startAnimating];
    self.navtitle.title = @"请稍候...";
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.txtEmail.text forKey:@"email"];
    [dic setValue:self.txtPaswd.text forKey:@"password"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: nil];
    loginData = [NSMutableData alloc];
    NSString *url=[Common getUrlString:@"/users/sign_in"];
    HTTPPost *post = [[HTTPPost alloc]initWithArgs:url postData:data resultData:loginData sender:self onSuccess:@selector(loginFinished) onError:@selector(loginError)];
    [post Run];
}

-(void)loginFinished{
    [act stopAnimating];
    NSString *recvStr = [[NSString alloc]initWithData:self.loginData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", recvStr);
    
    if (self.loginData.length==0){
        navtitle.title = @"用户登录";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alert show];
    }
    else{
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.loginData options:NSJSONReadingMutableLeaves error: nil];
        NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
        [localData setObject:[json objectForKey:@"user_token"] forKey:@"user_token"];
        [localData setObject:self.txtEmail.text forKey:@"email"];
        [localData setInteger:[[json objectForKey:@"user_id"]integerValue] forKey:@"user_id"];
        [localData synchronize];
        [self performSegueWithIdentifier:@"logged" sender:nil];
    }
}

-(void)loginError{
    [act stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络连接。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    navtitle.title = @"用户登录";
}
//登出/uesrs/sign_out?user_token=...
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self tapBackground];
    self.txtEmail.delegate=self;
    self.txtPaswd.delegate=self;
    NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
    [localData removeObjectForKey:@"user_token"];
    NSString *token=[localData objectForKey:@"user_token"];
    if (token) {
        [self performSegueWithIdentifier:@"logged" sender:self];
    }
    [self.btnLogin.layer setMasksToBounds:YES];
    [self.btnLogin.layer setCornerRadius:8.0];
}

@end