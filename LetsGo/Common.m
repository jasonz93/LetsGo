//
//  Common.m
//  走起
//
//  Created by Nicholas on 14-10-31.
//  Copyright (c) 2014年 Nicholas. All rights reserved.
//

#import "Common.h"

@implementation Common

+(NSString *)getToken{
    NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
    return (NSString *)[localData objectForKey:@"token"];
}

@end

@implementation HTTPPost

@synthesize receiveData;
@synthesize request;
@synthesize conn;
@synthesize onErr;
@synthesize onSucc;
@synthesize sender;

-(id)initWithArgs:(NSString *)URLstring postData:(NSData *)data resultData:(NSMutableData *)resultData sender:(id)sender onSuccess:(SEL)onSuccess onError:(SEL)onError{
    NSURL *url = [NSURL URLWithString:URLstring];
    self.request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    self.receiveData = resultData;
    self.conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.onSucc = onSuccess;
    self.onErr = onError;
    self.sender = sender;
    return self;
}

-(void)Run{
    [self.conn start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    //NSLog(@"%@", [res allHeaderFields]);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receiveData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *recvStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", recvStr);
    [sender performSelector:onSucc];
}

-(void)conncetion:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //NSLog(@"%@", [error localizedDescription]);
    [sender performSelector:onErr];
}


@end
