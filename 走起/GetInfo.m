//
//  GetInfo.m
//  zouqi
//
//  Created by 周瑞琦 on 11/4/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import "GetInfo.h"

@implementation GetInfo


-(void)initWithURL:(NSString*)GetURL ResultData:(NSMutableData*)data sender:(id)TheSender OnSuccess:(SEL)scss OnError:(SEL)err{
    NSUserDefaults *local=[NSUserDefaults standardUserDefaults];
    NSString *str=GetURL;
    NSString *token=[local stringForKey:@"user_token"];
    if (token) {
        str=[str stringByAppendingString:@"?user_token="];
        str=[str stringByAppendingString:token];
    }
    NSURL *url = [NSURL URLWithString:str];
    NSLog(@"%@",url);
    //self.request =[[NSURLRequest alloc]initWithURL:url];
    self.request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.TheConnection=[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:NO];
    /*if(self.TheConnection)
    {
        self.datas=[NSMutableData new];
    }*/
    self.ResultDic=data;
    self.OnSuccess=scss;
    self.OnError=err;
    self.Sender=TheSender;
    [self.TheConnection start];
}

#pragma mark -NSURLConnection
-(void) connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    [self.ResultDic appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
    //[self.Sender performSelector:self.OnError];
    [self DealError];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Receive complete");
    NSString *str=[[NSString alloc]initWithData:self.ResultDic encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    [self.Sender performSelector:self.OnSuccess];
}

-(void)DealError{
    NSLog(@"NetWork Error");
    UIViewController *controller=self.Sender;
    MBProgressHUD *ErrorView=[[MBProgressHUD alloc]initWithView:controller.view];
    ErrorView.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cry"]];
    ErrorView.mode=MBProgressHUDModeCustomView;
    ErrorView.delegate=self;
    ErrorView.labelText=@"网络不给力";
    [ErrorView show:YES];
    [controller.view addSubview:ErrorView];
    [ErrorView hide:YES afterDelay:2];
    
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

@end



@implementation PostInfo
-(void)initWithURL:(NSString *)URLstring HttpMethod:(NSString*)Method postData:(NSData *)data resultData:(NSMutableData *)resultData sender:(id)sender onSuccess:(SEL)onSuccess onError:(SEL)onError{
    NSURL *url = [NSURL URLWithString:URLstring];
    self.Prequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.Prequest setHTTPMethod:Method];
    [self.Prequest setHTTPBody:data];
    [self.Prequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    self.PResultDic = resultData;
    self.PTheConnection = [[NSURLConnection alloc]initWithRequest:self.Prequest delegate:self];
    self.POnSuccess = onSuccess;
    self.POnError = onError;
    self.PSender = sender;
    [self.PTheConnection start];
}



-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.PResultDic appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.PSender performSelector:self.POnSuccess];
}

-(void)conncetion:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
//    [self.PSender performSelector:self.POnError];
    [self DealError];
}

-(void)DealError{
    NSLog(@"NetWork Error");
    UIViewController *controller=self.PSender;
    MBProgressHUD *ErrorView=[[MBProgressHUD alloc]initWithView:controller.view];
    ErrorView.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cry"]];
    ErrorView.mode=MBProgressHUDModeCustomView;
    ErrorView.delegate=self;
    ErrorView.labelText=@"网络不给力";
    [ErrorView show:YES];
    [controller.view addSubview:ErrorView];
    [ErrorView hide:YES afterDelay:2];
    
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}


@end
