//
//  OrgDetailViewController.m
//  LetsGo
//
//  Created by Nicholas on 14/11/6.
//
//

#import <Foundation/Foundation.h>
#import "OrgDetailViewController.h"

@interface OrgDetailViewController()

@end

@implementation OrgDetailViewController

UIColor *defaultColor;
NSMutableData *rData;

-(IBAction)joinOrg:(id)sender{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    SEL sel;
    if (self.org.isJoined) {
        sel=@selector(orgQuited);
        [dic setValue:@"quit" forKey:@"action"];
    }
    else{
        sel=@selector(orgJoined);
        [dic setValue:@"join" forKey:@"action"];
    }
    [dic setValue:[NSNumber numberWithUnsignedInteger:self.org.orgID] forKey:@"id"];
    NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    HTTPPost *post=[[HTTPPost alloc]initWithArgs:@"org" postData:json resultData:rData sender:self onSuccess:sel onError:@selector(networkErr)];
    [post Run];
}

-(void)orgJoined{
    if(rData.length>0){
        self.org.isJoined=YES;
        [self refreshBtn];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"加入成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)orgQuited{
    if(rData.length>0){
        self.org.isJoined=NO;
        [self refreshBtn];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"退出成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)networkErr{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)refreshBtn{
    if (self.org.isJoined) {
        [self.btnJoin setTitle:@"退出" forState:UIControlStateNormal];
        self.btnJoin.tintColor=[UIColor redColor];
    }
    else
    {
        [self.btnJoin setTitle:@"加入" forState:UIControlStateNormal];
        self.btnJoin.tintColor=defaultColor;
    }
}

-(void)viewDidLoad{
    defaultColor=self.btnJoin.tintColor;
    self.txtOrgName.text=self.org.name;
    self.txtOrgContent.text=self.org.content;
    NSURL *url=[NSURL URLWithString:self.org.logoUrl];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    self.imgOrgLogo.image=image;
    [self.imgOrgLogo.layer setMasksToBounds:YES];
    [self.imgOrgLogo.layer setCornerRadius:75];
    [self.btnJoin.layer setBorderWidth:1];
    [self.btnJoin.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [self refreshBtn];
}

@end