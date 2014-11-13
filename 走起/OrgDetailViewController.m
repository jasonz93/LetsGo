//
//  OrgDetailViewController.m
//  LetsGo
//
//  Created by Nicholas on 14/11/6.
//
//

#import <Foundation/Foundation.h>
#import "OrgDetailViewController.h"
#import "MyOrgViewController.h"

@interface OrgDetailViewController()

@end

@implementation OrgDetailViewController

UIColor *defaultColor;
NSMutableData *rData;

-(IBAction)joinOrg:(id)sender{
    if (self.org.isJoined) {
        [Common quitOrg:self.org];
        self.org.isJoined=NO;
    }
    else{
        [Common joinOrg:self.org];
        self.org.isJoined=YES;
    }
    [self refreshBtn];
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
    }/*
    NSArray *views=self.navigationController.viewControllers;
    for (int i=0; i<views.count; i++) {
        if ([views[i] isKindOfClass:[MyOrgViewController class]]) {
            NSLog(@"got %@",views[i]);
            MyOrgViewController *my=views[i];
            [my refreshOrgs];
        }
    }*/
}

-(void)gotSchool{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.schoolData options:NSJSONReadingMutableLeaves error:nil];
    self.school=[[clsSchool alloc]initWithData:dic];
    self.txtSchoolName.text=self.school.name;
}

-(void)viewDidLoad{
    defaultColor=self.btnJoin.tintColor;
    self.txtOrgName.text=self.org.name;
    self.txtOrgContent.text=self.org.content;
    self.schoolData=[[NSMutableData alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@/schools/%ld.json",[Common getUrlString:@""],self.org.school_id];
    [[GetInfo alloc]initWithURL:url ResultData:self.schoolData sender:self OnSuccess:@selector(gotSchool) OnError:nil];
    //NSURL *url=[NSURL URLWithString:self.org.logoUrl];
    //UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    //self.imgOrgLogo.image=image;
    [Common loadPic:self.org.logoUrl imageView:self.imgOrgLogo];
    [self.imgOrgLogo.layer setMasksToBounds:YES];
    [self.imgOrgLogo.layer setCornerRadius:75];
    [self.btnJoin.layer setBorderWidth:1];
    [self.btnJoin.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [self refreshBtn];
}

@end