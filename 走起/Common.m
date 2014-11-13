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
    return (NSString *)[localData objectForKey:@"user_token"];
}

+(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 H:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)durFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H小时m分"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)getUrlString:(NSString *)path{
    NSString *host=@"http://192.168.18.179:3000";
    NSString *url=[host stringByAppendingString:path];
    return url;
}

+(void)loadPic:(NSString *)urlString imageView:(UIImageView *)view{
    NSLog(@"pic Loading!URL is [%@]",urlString);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url=[NSURL URLWithString:urlString];
        NSData *data=[[NSData alloc]initWithContentsOfURL:url];
        if (data!=nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"pic Loaded!");
                view.image=[[UIImage alloc]initWithData:data];
            });
        }
    });
}

+(void)joinOrg:(clsOrg *)org{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:[NSNumber numberWithInteger:org.orgID] forKey:@"organization_id"];
    NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *url=[Common getUrlString:@"/organization_userships.json"];
    HTTPPost *post=[[HTTPPost alloc]initWithArgs:url postData:json resultData:[[NSMutableData alloc]init] sender:self onSuccess:nil onError:nil];
    [post Run];
}

+(void)quitOrg:(clsOrg *)org{
    NSString *str=[Common getUrlString:@"/organization_userships/"];
    NSUserDefaults *local=[NSUserDefaults standardUserDefaults];
    NSString *token=[local objectForKey:@"user_token"];
    str=[[NSString alloc]initWithFormat:@"%@%ld.json?user_token=%@",str,[org.ship_id integerValue],token];
    NSURL *url=[NSURL URLWithString:str];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"DELETE"];
    NSURLConnection *conn=[[NSURLConnection alloc]initWithRequest:request delegate:nil startImmediately:YES];
}

+(void)uploadPic:(UIImage *)pic picUrl:(NSMutableData *)picUrl sender:(id)sender onDone:(SEL)onDone{
    NSData *picData=UIImageJPEGRepresentation(pic, 1.0);
    NSString *picEncoded=[picData base64EncodedStringWithOptions:0];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:picEncoded forKey:@"picdata"];
    NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *url=[Common getUrlString:@"/pictures.json"];
    //NSString *url=@"http://localhost/upload.php";
    HTTPPost *post=[[HTTPPost alloc]initWithArgs:url postData:json resultData:picUrl sender:sender onSuccess:onDone onError:@selector(networkErr)];
    [post Run];
}

+(void)networkErr{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+(NSURL *)getUrlWithToken:(NSString *)path{
    NSString *token=[Common getToken];
    NSString *host=[Common getUrlString:@""];
    NSString *str=[[NSString alloc]initWithFormat:@"%@%@?user_token=%@",host,path,token];
    NSURL *url=[NSURL URLWithString:str];
    return url;
}

+(UIImage *)resizePic:(UIImage *)orig resizeTo:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [orig drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end

@implementation clsOrg

-(id)initWithData:(NSDictionary *)dic{
    //NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    self.orgID=[[dic objectForKey:@"id"]integerValue];
    self.name=[dic objectForKey:@"organization_name"];
    self.content=[dic objectForKey:@"organization_content"];
    self.logoUrl=[dic objectForKey:@"organization_logo"];
    //self.isJoined=[[dic objectForKey:@"isJoined"]boolValue];
    self.school_id=[[dic objectForKey:@"school_id"]integerValue];
    self.ship_id=[dic objectForKey:@"ship_id"];
    if (self.ship_id!=nil) {
        self.isJoined=YES;
    }
    else{
        self.isJoined=NO;
    }
    return self;
}

@end

@implementation clsSchool

-(id)initWithData:(NSDictionary *)dic{
    self.schoolID=[[dic objectForKey:@"id"]integerValue];
    self.name=[dic objectForKey:@"school_name"];
    return self;
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
    NSUserDefaults *local=[NSUserDefaults standardUserDefaults];
    NSString *str=URLstring;
    NSString *token=[local stringForKey:@"user_token"];
    if (token) {
        str=[str stringByAppendingString:@"?user_token="];
        str=[str stringByAppendingString:token];
    }
    NSURL *url = [NSURL URLWithString:str];
    self.request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSLog(@"%@",self.request.HTTPMethod);
    NSData *d=self.request.HTTPBody;
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *jsondata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsondata);
    self.receiveData = resultData;
    self.conn = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
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
    NSLog(@"%@", [res allHeaderFields]);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receiveData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *recvStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", recvStr);
    if (self.onSucc)
        [sender performSelector:onSucc];
}

-(void)conncetion:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    if(self.onErr)
        [sender performSelector:onErr];
}


@end
