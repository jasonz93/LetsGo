//
//  Common.h
//  走起
//
//  Created by Nicholas on 14-10-31.
//  Copyright (c) 2014年 Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Common : NSObject

+(NSString *)getToken;
@end

@interface HTTPPost : NSObject

@property NSMutableData *receiveData;
@property NSMutableURLRequest *request;
@property NSURLConnection *conn;
@property SEL onSucc;
@property SEL onErr;
@property id sender;

-(id)initWithArgs:(NSString *)URLstring postData:(NSData *)data resultData:(NSMutableData *)resultData sender:(id)sender onSuccess:(SEL)onSuccess onError:(SEL)onError;
-(void)Run;

@end