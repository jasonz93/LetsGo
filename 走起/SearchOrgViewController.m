//
//  SearchOrgViewController.m
//  LetsGo
//
//  Created by Nicholas on 14/11/5.
//
//

#import <Foundation/Foundation.h>
#import "SearchOrgViewController.h"
#import "OrgDetailViewController.h"

@interface SearchOrgViewController()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation SearchOrgViewController

NSMutableArray *orgList;
NSMutableData *searchData;
BOOL shouldTouch;


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    OrgDetailViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"OrgDetailView"];
    NSUInteger row=[indexPath section];
    view.org=[orgList objectAtIndex:row];
    [self.navigationController pushViewController:view animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return orgList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    NSUInteger row=[indexPath section];
    clsOrg *org=[orgList objectAtIndex:row];
    NSURL *url=[NSURL URLWithString:org.logoUrl];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    cell.textLabel.text=org.name;
    cell.detailTextLabel.text=org.content;
    cell.imageView.image=image;
    cell.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    cell.layer.borderWidth=1;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header=[[UIView alloc]init];
    header.backgroundColor=[UIColor clearColor];
    return header;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length>0){
        searchData=[[NSMutableData alloc]init];
        HTTPPost *post=[[HTTPPost alloc]initWithArgs:@"http://localhost/organization_list.txt" postData:[searchBar.text dataUsingEncoding:NSUTF8StringEncoding] resultData:searchData sender:self onSuccess:@selector(searchDone) onError:@selector(networkErr)];
        [post Run];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    shouldTouch=YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return shouldTouch;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    shouldTouch=NO;
    
}

-(void)searchDone{
    [orgList removeAllObjects];
    NSArray *keys=[NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableLeaves error:nil];
    NSInteger count=keys.count;
    for (int i=0; i<count; i++) {
        [orgList addObject:[[clsOrg alloc]initWithData:[keys objectAtIndex:i]]];
    }
    [self.tblOrgs reloadData];
}

-(void)networkErr{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setDelegate:self];
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce//手势方法
{
    [self.txtSearch resignFirstResponder];
}

-(void)viewDidLoad{
    orgList=[[NSMutableArray alloc]init];
    self.tblOrgs.delegate=self;
    self.tblOrgs.dataSource=self;
    self.txtSearch.delegate=self;
    [self tapBackground];
    self.tblOrgs.sectionHeaderHeight=10;
    self.tblOrgs.rowHeight=150;
}

@end