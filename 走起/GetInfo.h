//
//  GetInfo.h
//  zouqi
//
//  Created by 周瑞琦 on 11/4/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetInfo : NSObject<NSURLConnectionDelegate>
@property NSMutableData* ResultDic;
@property SEL OnSuccess;
@property SEL OnError;
@property id Sender;
@property NSURLRequest *request;
@property NSURLConnection *TheConnection;

-(void)initWithURL:(NSString*)GetURL ResultData:(NSMutableData*)data sender:(id)TheSender OnSuccess:(SEL)scss OnError:(SEL)err;
@end
