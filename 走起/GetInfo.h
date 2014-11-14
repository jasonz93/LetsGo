//
//  GetInfo.h
//  zouqi
//
//  Created by 周瑞琦 on 11/4/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface GetInfo : NSObject<NSURLConnectionDelegate,MBProgressHUDDelegate>
@property NSMutableData* ResultDic;
@property SEL OnSuccess;
@property SEL OnError;
@property id Sender;
@property NSURLRequest *request;
@property NSURLConnection *TheConnection;

-(void)initWithURL:(NSString*)GetURL ResultData:(NSMutableData*)data sender:(id)TheSender OnSuccess:(SEL)scss OnError:(SEL)err;
@end


@interface PostInfo : NSObject<NSURLConnectionDelegate,MBProgressHUDDelegate>
@property NSMutableData* PResultDic;
@property SEL POnSuccess;
@property SEL POnError;
@property id PSender;
@property NSMutableURLRequest *Prequest;
@property NSURLConnection *PTheConnection;

-(void)initWithURL:(NSString *)URLstring HttpMethod:(NSString*)Method postData:(NSData *)data resultData:(NSMutableData *)resultData sender:(id)sender onSuccess:(SEL)onSuccess onError:(SEL)onError;
@end