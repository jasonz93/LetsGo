//
//  FirstViewController.m
//  zouqi
//
//  Created by 周瑞琦 on 10/31/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import "HotActivityViewController.h"

@interface HotActivityViewController ()

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshControl];
    [self GetMyAList];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}

-(NSInteger ) tableView:(UITableView *)tableView

  numberOfRowsInSection:(NSInteger )section

{
    return [self.AList count];
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
    NSDictionary *tmp =[self.AList objectAtIndex:[indexPath row]];
    [cell initwithTitle:[tmp objectForKey:@"activity_title"] Img:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tmp objectForKey:@"activity_logo"]]] BeginTime:[tmp objectForKey:@"activity_begin_time"] EndTime:[tmp objectForKey:@"activity_end_time"] Place:[tmp objectForKey:@"activity_place"]];
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *AactivityDetail=[storyBoard instantiateViewControllerWithIdentifier:@"ActivityDetail" ];
    AactivityDetail.hidesBottomBarWhenPushed=YES;
    AactivityDetail.Activity_Id=(NSInteger)[[self.AList objectAtIndex:[indexPath row]]objectForKey:@"activity_id"];
    [self.navigationController pushViewController:AactivityDetail animated:YES];
}



-(void) GetMyAList{
    self.RevData=[NSMutableData alloc];
    [[GetInfo alloc]initWithURL:@"http://1.r7test.sinaapp.com/activitylist.json" ResultData:self.RevData sender:self OnSuccess:@selector(ProcessData) OnError:nil];
}

-(void) ProcessData{
    if(self.refreshControl.refreshing)
    {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"👻下拉刷新"];
    }
    NSLog(@"Json Success received!!!");
    self.AList= [NSJSONSerialization JSONObjectWithData:self.RevData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",self.AList);
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

@end