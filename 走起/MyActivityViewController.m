//
//  SecondViewController.m
//  zouqi
//
//  Created by 周瑞琦 on 10/31/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import "MyActivityViewController.h"

@interface MyActivityViewController ()


@end

@implementation MyActivityViewController

- (void)viewDidLoad {
  /*  UIImage *selectedImage = [UIImage imageNamed:@"selected.png"];
    UIImage *unselectedImage = [UIImage imageNamed:@"unselected.png"];
    
    UITabBar *tabBar = tabBarViewController.tabBar;
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    [item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];*/
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    mytoken=[defaults objectForKey:@"user_token"];
    Uid=[[defaults objectForKey:@"user_id"]integerValue];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationItem setTitle:@"我参与的"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];    [super viewDidLoad];
    [self initRefreshControl];
    [self.refreshControl beginRefreshing];
    [self RefreshAList];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Hot Activity Get token %@,id %d",mytoken,Uid);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:96.0/255 green:125.0/255 blue:136.0/255 alpha:1]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"已报名活动";
    else
        return @"我参加过的活动";
    
}


-(NSInteger ) tableView:(UITableView *)tableView

  numberOfRowsInSection:(NSInteger )section

{
    if(section==0)
    {
        return AingDic.count;
    }
    else
    {
        return AedDic.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.CellInited){
        UINib *nib=[UINib nibWithNibName:@"ActivityIntroCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"AList"];
        self.CellInited=YES;
    }
    ActivityIntroCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AList"];
    if (cell==nil ) {
        cell=[[ ActivityIntroCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AList"];
    }
    NSDictionary *tmp;
    if([indexPath section]==0)
        tmp=[AingDic objectAtIndex:[indexPath row]];
    else
        tmp=[AedDic objectAtIndex:[indexPath row]];
    NSLog(@"%@",[tmp objectForKey:@"activity_end_time"]);
    [cell initwithTitle:[tmp objectForKey:@"activity_title"] Img:[tmp objectForKey:@"activity_logo"] BeginTime:[tmp objectForKey:@"activity_begin_time"] EndTime:[tmp objectForKey:@"activity_end_time"] Place:[tmp objectForKey:@"activity_place"]];
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityTable *AactivityDetail=[storyBoard instantiateViewControllerWithIdentifier:@"ActivityTableView" ];
    AactivityDetail.hidesBottomBarWhenPushed=YES;
    if([indexPath section]==0)
        AactivityDetail.Aid=[[AingDic objectAtIndex:[indexPath row]]objectForKey:@"activity_id"];
    else
        AactivityDetail.Aid=[[AedDic objectAtIndex:[indexPath row]]objectForKey:@"activity_id"];
    
    [self.navigationController pushViewController:AactivityDetail animated:YES];
}

-(void) GetMyAList{
    self.RevData=[NSMutableData alloc];
    NSString *URLplist=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSString *URLpre=[[[NSDictionary alloc]initWithContentsOfFile:URLplist] objectForKey:@"URLprefix"];
    NSLog(@"URL is %@",[NSString stringWithFormat:@"%@/users/%d/activities.json",URLpre,Uid] );
    [[GetInfo alloc]initWithURL:[NSString stringWithFormat:@"%@/users/%d/activities.json",URLpre,Uid] ResultData:self.RevData sender:self OnSuccess:@selector(ProcessData) OnError:@selector(DealError)];
}

-(void) ProcessData{
    NSLog(@"Json received success");
    if(self.refreshControl.refreshing)
    {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"👻下拉刷新"];
    }
    AingDic= [[NSJSONSerialization JSONObjectWithData:self.RevData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"activity_ing"];
    AedDic= [[NSJSONSerialization JSONObjectWithData:self.RevData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"activity_ed"];
    [self.ActivityList reloadData];
}

-(void) initRefreshControl{
    UIRefreshControl *Rc=[[UIRefreshControl alloc]init];
    Rc.attributedTitle=[[NSAttributedString alloc]initWithString:@"👻下拉刷新"];
    [Rc addTarget:self action:@selector(RefreshAList) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=Rc;
}

-(void) RefreshAList{
    if(self.refreshControl.refreshing){
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"😂加载中"];
        [self GetMyAList];
    }
}


-(void)DealError{
    NSLog(@"NetWork Error");
    MBProgressHUD *ErrorView=[[MBProgressHUD alloc]initWithView:self.view];
    ErrorView.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cry"]];
    ErrorView.mode=MBProgressHUDModeCustomView;
    ErrorView.delegate=self;
    [self.view addSubview:ErrorView];
    ErrorView.labelText=@"网络不给力";
    [ErrorView show:YES];
    [ErrorView hide:YES afterDelay:2];
    if(self.refreshControl.refreshing)
    {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"👻下拉刷新"];
    }
    
}
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}


@end
