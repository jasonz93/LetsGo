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
    [self.Sender performSelector:self.OnError];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Receive complete");
    NSString *str=[[NSString alloc]initWithData:self.ResultDic encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    [self.Sender performSelector:self.OnSuccess];
}
@end
