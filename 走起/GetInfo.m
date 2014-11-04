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
    NSURL *url=[NSURL URLWithString:GetURL];
    self.request =[[NSURLRequest alloc]initWithURL:url];
    self.TheConnection=[[NSURLConnection alloc]initWithRequest:self.request delegate:self];
    /*if(self.TheConnection)
    {
        self.datas=[NSMutableData new];
    }*/
    self.ResultDic=data;
    self.OnSuccess=scss;
    self.OnError=err;
    self.Sender=TheSender;
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
   /* self.ResultDic=[NSJSONSerialization JSONObjectWithData:self.datas options:NSJSONReadingAllowFragments error:nil];*/
    [self.Sender performSelector:self.OnSuccess];
}
@end
