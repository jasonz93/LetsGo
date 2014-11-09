//
//  MyOrgViewController.m
//  LetsGo
//
//  Created by Nicholas on 14/11/5.
//
//

#import <Foundation/Foundation.h>
#import "MyOrgViewController.h"
#import "OrgDetailViewController.h"

@interface MyOrgViewController()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation MyOrgViewController

NSMutableData *orgData,*rData;
NSMutableArray *orgDataList;
NSString *user;
NSString *token;
clsOrg *org;

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"退出";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row=[indexPath row];
    org=[orgDataList objectAtIndex:row];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:@"quit" forKey:@"action"];
    [dic setValue:org.orgID forKey:@"id"];
    NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    HTTPPost *post=[[HTTPPost alloc]initWithArgs:@"org" postData:json resultData:rData sender:self onSuccess:@selector(orgQuited) onError:@selector(networkErr)];
    [post Run];
    
}

-(void)orgQuited{
    if(rData.length>0){
        org.isJoined=NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"退出成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self refreshOrgs];
    }
}

-(void)refreshOrgs{
    orgData=[[NSMutableData alloc]init];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:user forKey:@"Username"];
    [dic setValue:token forKey:@"Token"];
    NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    HTTPPost *post=[[HTTPPost alloc]initWithArgs:@"http://localhost/myorg.php" postData:json resultData:orgData sender:self onSuccess:@selector(gotOrgs) onError:@selector(networkErr)];
    [post Run];
}

-(void)gotOrgs{
    if (orgData.length>0) {
        [orgDataList removeAllObjects];
        NSMutableDictionary *dic=[NSJSONSerialization JSONObjectWithData:orgData options:NSJSONReadingMutableLeaves error:nil];
        NSInteger count=[[dic objectForKey:@"Count"]integerValue];
        for (int i=0; i<count; i++) {
            [orgDataList addObject:[[clsOrg alloc]initWithData:[dic objectForKey:[NSString stringWithFormat:@"%d",i ]]]];
        }
        [self.tblOrgs reloadData];
    }
}

-(void)networkErr{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    OrgDetailViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"OrgDetailView"];
    NSUInteger row=[indexPath row];
    view.org=[orgDataList objectAtIndex:row];
    [self.navigationController pushViewController:view animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orgDataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSUInteger row=[indexPath row];
    clsOrg *org=[orgDataList objectAtIndex:row];
    NSURL *url=[NSURL URLWithString:org.logoUrl];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    cell.imageView.image=image;
    cell.textLabel.text=org.name;
    cell.detailTextLabel.text=org.content;
    return cell;
}

-(void)viewDidLoad{
    self.tblOrgs.dataSource=self;
    self.tblOrgs.delegate=self;
    orgDataList=[[NSMutableArray alloc]init];
    NSUserDefaults *local=[NSUserDefaults standardUserDefaults];
    user=[local objectForKey:@"Username"];
    token=[Common getToken];
    [self refreshOrgs];
    //self.tblOrgs.editing=NO;
}

@end