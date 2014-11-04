//
//  MyInfoViewController.m
//  zouqi
//
//  Created by 周瑞琦 on 10/31/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import "MyInfoViewController.h"
#import"ActivityDetailViewController.h"
#import "Common.h"
#import "GetInfo.h"
@interface MyInfoViewController ()

@end


@implementation MyInfoViewController

//变量声明区域
NSInteger cc=0;
//变量声明区域结束




- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"ActivityJoin";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil ) {
        cell=[[ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if([indexPath section]==0)
    {
    cell.textLabel.text=[[self.ActivityList_ing objectAtIndex:[indexPath row]]objectForKey:@"activity_title"];
    cell.detailTextLabel.text=[[self.ActivityList_ing objectAtIndex:[indexPath row]]objectForKey:@"activity_place"];//[ActivityJsonInfo objectForKey:@"title"];
    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.ActivityList_ing objectAtIndex:[indexPath row]]objectForKey:@"activity_pic"]]]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
    }
    else
    {
        cell.textLabel.text=[[self.ActivityList_ed objectAtIndex:[indexPath row]]objectForKey:@"activity_title"];
        cell.detailTextLabel.text=[[self.ActivityList_ed objectAtIndex:[indexPath row]]objectForKey:@"activity_place"];//[ActivityJsonInfo objectForKey:@"title"];
        cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.ActivityList_ed objectAtIndex:[indexPath row]]objectForKey:@"activity_pic"]]]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        return cell;
    }
}





-(NSInteger ) tableView:(UITableView *)tableView

  numberOfRowsInSection:(NSInteger )section

{
    NSLog(@"Get number of Section");
    switch(section)
    {
        case ActivityIng:
            NSLog(@"Section =1 count=%lu",(unsigned long)self.ActivityList_ing.count);
            //self.Activity_Info.frame.size.height=UITABleview;
            return self.ActivityList_ing.count;
            break;
        case ActivityEd:
            NSLog(@"Section =2 count=%lu",(unsigned long)[self.ActivityList_ed count]);
            return self.ActivityList_ed.count;
            break;
        default:
            NSLog(@"Section =%ld!!!what's wrong!!",(long)section);
            return 0;
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 2;//section从0开始，你大爷的
}//分段显示，应该是2吧


- (void)viewWillAppear:(BOOL)animated{
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *AactivityDetail=[storyBoard instantiateViewControllerWithIdentifier:@"ActivityDetail" ];
    AactivityDetail.hidesBottomBarWhenPushed=YES;
    if([indexPath section]==0)
    {
        AactivityDetail.Activity_Id=(NSInteger)[[self.ActivityList_ing objectAtIndex:[indexPath row]]objectForKey:@"activity_id"];
    }
    else
    {
        AactivityDetail.Activity_Id=(NSInteger)[[self.ActivityList_ed objectAtIndex:[indexPath row]]objectForKey:@"activity_id"];
    }
    [self.navigationController pushViewController:AactivityDetail animated:YES];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.Activity_Info.delegate=self;
    self.Activity_Info.dataSource=self;
    [self PostInfo];
   // self.Activity_Info.rowHeight=UITableViewAutomaticDimension;
   }



-(void)PostInfo{
    NSLog(@"Post information");
    self.ActivityList_ingData=[NSMutableData alloc];
    /*HTTPPost *PersonInfoPost=[[HTTPPost alloc]initWithArgs:@"http://www.douban.com/j/app/radio/people" postData:[PersonLinkParameter dataUsingEncoding:NSUTF8StringEncoding] resultData:self.ActivityList_ingData sender:self onSuccess:@selector(DealWithJsonData) onError:nil];
    [PersonInfoPost Run];*/
    [[GetInfo alloc]initWithURL:@"http://1.r7test.sinaapp.com/Person.json" ResultData:self.ActivityList_ingData sender:self OnSuccess:@selector(DealWithJsonData) OnError:nil];
    
}

-(void)showErrorMessage{
    UIAlertView *ErrorView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Get Json Data Error!" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"No", nil];
    [ErrorView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == ActivityIng) {
        return @"正在参与的活动";
    }
    else if(section==ActivityEd)
        return @"结束的活动";
    else
    {
        ////////出错
        return @"Error!!";
    }
}


-(void) DealWithJsonData{
    NSLog(@"Json Success received!!!");
    NSLog(@"%@",self.ActivityList_ingData);
    self.User_Name.text=[[NSJSONSerialization JSONObjectWithData:self.ActivityList_ingData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"student_name"];
    self.User_School.text=[[NSJSONSerialization JSONObjectWithData:self.ActivityList_ingData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"school_name"];
    //self.User_Icon.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.ActivityList_ing objectAtIndex:[indexPath row]]objectForKey:@"activity_pic"]]]];
    self.ActivityList_ing= [[NSJSONSerialization JSONObjectWithData:self.ActivityList_ingData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"Activity_ing"];
    NSLog(@"%@",self.ActivityList_ing);
    self.ActivityList_ed=[[NSJSONSerialization JSONObjectWithData:self.ActivityList_ingData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"Activity_ed"];
    [self.Activity_Info reloadData];
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
