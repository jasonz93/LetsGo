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
    NSUInteger row=[indexPath section];
    org=[orgDataList objectAtIndex:row];
    [Common quitOrg:org];
    [self refreshOrgs];
}

-(void)orgQuited{
    if(rData.length>0){
        org.isJoined=NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"退出成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self refreshOrgs];
    }
}
//http://localhost:3000/users/1/organizations.json
-(void)refreshOrgs{
    orgData=[[NSMutableData alloc]init];
    NSUserDefaults *local=[NSUserDefaults standardUserDefaults];
    NSString *url=[Common getUrlString:@"/users/"];
    url=[url stringByAppendingString:[[NSString alloc]initWithFormat:@"%ld",[[local objectForKey:@"user_id"]integerValue]]];
    url=[url stringByAppendingString:@"/organizations.json"];
    //NSString *url=[Common getUrlString:@"/organization_list.txt"];
    GetInfo *get=[[GetInfo alloc]init];
    [get initWithURL:url ResultData:orgData sender:self OnSuccess:@selector(gotOrgs) OnError:@selector(networkErr)];
}

-(void)pullRefresh{
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..."];
    [self refreshOrgs];
}

-(void)gotOrgs{
    if (orgData.length>0) {
        [orgDataList removeAllObjects];
        NSMutableArray *keys=[NSJSONSerialization JSONObjectWithData:orgData options:NSJSONReadingMutableLeaves error:nil];
        NSInteger count=keys.count;
        for (int i=0; i<count; i++) {
            [orgDataList addObject:[[clsOrg alloc]initWithData:[keys objectAtIndex:i]]];
        }
        [self.tblOrgs reloadData];
    }
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"下拉刷新"];
    
}

-(void)networkErr{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    OrgDetailViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"OrgDetailView"];
    NSUInteger row=[indexPath section];
    view.org=[orgDataList objectAtIndex:row];
    [self.navigationController pushViewController:view animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return orgDataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    NSUInteger row=[indexPath section];
    clsOrg *org=[orgDataList objectAtIndex:row];
    //NSURL *url=[NSURL URLWithString:org.logoUrl];
    //UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    //cell.imageView.image=image;
    [Common loadPic:org.logoUrl imageView:cell.imageView];
    cell.textLabel.text=org.name;
    NSLog(@"%@",org.name);
    cell.detailTextLabel.text=org.content;
    cell.layer.borderWidth=1;
    cell.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header=[[UIView alloc]init];
    header.backgroundColor=[UIColor clearColor];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)viewDidLoad{
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.tblOrgs.dataSource=self;
    self.tblOrgs.delegate=self;
    orgDataList=[[NSMutableArray alloc]init];
    NSUserDefaults *local=[NSUserDefaults standardUserDefaults];
    user=[local objectForKey:@"Username"];
    token=[Common getToken];
    self.tblOrgs.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self refreshOrgs];
    //[Common joinOrg:[[NSNumber alloc]initWithInt:4]];
    //[Common quitOrg:[[NSNumber alloc] initWithInt:1]];
    UIRefreshControl *rc=[[UIRefreshControl alloc]init];
    rc.attributedTitle=[[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=rc;
}

-(void)viewDidAppear:(BOOL)animated{
    [self pullRefresh];
}

@end