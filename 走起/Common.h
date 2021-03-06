//
//  Common.h
//  走起
//
//  Created by Nicholas on 14-10-31.
//  Copyright (c) 2014年 Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface clsOrg : NSObject

@property NSInteger orgID;
@property NSString *name;
@property NSString *content;
@property NSString *logoUrl;
@property BOOL isJoined;
@property NSNumber *ship_id;
@property NSInteger school_id;
@property NSString *school_name;

-(id)initWithData:(NSDictionary *)dic;

@end

@interface clsAct : NSObject

@property NSString *act_title;
@property NSString *act_content;
@property NSString *act_logo;
@property NSString *act_pic;
@property NSString *act_id;
@property NSString *act_begin;
@property NSString *act_end;
@property NSString *act_place;

-(id)initWithData:(NSDictionary *)dic;

@end

@interface Common : NSObject<NSURLConnectionDelegate>

+(NSString *)getToken;
+(NSString *)stringFromDate:(NSDate *)date;
+(NSString *)durFromDate:(NSDate *)date;
+(NSString *)getUrlString:(NSString *)path;
+(void)uploadPic:(UIImage *)pic picUrl:(NSMutableData *)picUrl sender:(id)sender onDone:(SEL)onDone;
+(void)joinOrg:(clsOrg *)org;
+(void)quitOrg:(clsOrg *)org;
+(UIImage *)resizePic:(UIImage *)orig resizeTo:(CGSize)size;
+(void)loadPic:(NSString *)urlString imageView:(UIImageView *)view;

@end

@interface HTTPPost : NSObject<MBProgressHUDDelegate>

@property NSMutableData *receiveData;
@property NSMutableURLRequest *request;
@property NSURLConnection *conn;
@property SEL onSucc;
@property SEL onErr;
@property id sender;

-(id)initWithArgs:(NSString *)URLstring postData:(NSData *)data resultData:(NSMutableData *)resultData sender:(id)sender onSuccess:(SEL)onSuccess onError:(SEL)onError;
-(void)Run;

@end



@interface clsSchool : NSObject

@property NSInteger schoolID;
@property NSString *name;

-(id)initWithData:(NSDictionary *)dic;

@end