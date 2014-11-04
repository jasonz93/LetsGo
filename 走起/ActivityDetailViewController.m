//
//  ActivityDetailViewController.m
//  zouqi
//
//  Created by 周瑞琦 on 11/2/14.
//  Copyright (c) 2014 Neuq. All rights reserved.
//

#import "ActivityDetailViewController.h"

@interface ActivityDetailViewController ()
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self Getinfo];
    // Do any additional setup after loading the view.
}


- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]==0)
    {
    
        if(!self.ImgCellLoaded){
            UINib *nib=[UINib nibWithNibName:@"ImgCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"ActivityImg"];
            self.ImgCellLoaded=YES;
        }
        ImgCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityImg"];
        if (cell==nil ) {
            cell=[[ ImgCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ActivityImg"];
        }
        cell.TopImg.image=[UIImage imageWithData:ActivityBigImgURL];
        //[cell SetActivityImage:ActivityBigImgURL];
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
    else if([indexPath row]==1)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityTitle"];
        if(cell==nil)
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityTitle"];
        cell.textLabel.text=ActivityTitle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
    else if([indexPath row]==2)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityOriginator"];
        if(cell==nil)
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityOriginator"];
        NSString *OriginatorName=@"Tomas Jackson";
        NSString *GroupName=@"North East University At Qinghuangdao";
        cell.textLabel.text= [NSString stringWithFormat:@"发起人 %@   所属群组  %@",OriginatorName,GroupName];//[[NSString alloc]initWithFormat:(@"发起人 %s   所属群组  %s",OriginatorName,GroupName)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
    else if([indexPath row]==3)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityTime"];
        if(cell==nil)
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityTime"];
        NSString *DateAndTime=@"2015-01-12 2:30 至 2015-01-13 2:30";
        cell.textLabel.text= [NSString stringWithFormat:@"活动时间 %@",DateAndTime];//[[NSString alloc]initWithFormat:(@"发起人 %s   所属群组  %s",OriginatorName,GroupName)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
    else if([indexPath row]==4)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityTime"];
        if(cell==nil)
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityTime"];
        NSString *DateAndTime=@"2015-01-12 2:30 至 2015-01-13 2:30";
        cell.textLabel.text= [NSString stringWithFormat:@"地点坐标 %@",DateAndTime];//[[NSString alloc]initWithFormat:(@"发起人 %s   所属群组  %s",OriginatorName,GroupName)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
    else if([indexPath row]==5)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityTime"];
        if(cell==nil)
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityTime"];
        NSString *DateAndTime=@"2015-01-12 2:30 至 2015-01-13 2:30";
        cell.textLabel.text= [NSString stringWithFormat:@"人数限额 %@",DateAndTime];//[[NSString alloc]initWithFormat:(@"发起人 %s   所属群组  %s",OriginatorName,GroupName)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityTime"];
    if(cell==nil)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityTime"];
    NSString *DateAndTime=@"test";
    cell.textLabel.text= [NSString stringWithFormat:@"活动详情 %@",DateAndTime];//[[NSString alloc]initWithFormat:(@"发起人 %s   所属群组  %s",OriginatorName,GroupName)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}



-(NSInteger ) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger )section{
    return 7;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch([indexPath row])
    {
        case 0:
            return 180;
            break;
        case 6:
            return 300;
            break;
        default:
            return 40;
    }
    return 1;
}


-(void)Getinfo
{
    self.ResultData=[NSMutableData alloc];
    [[GetInfo alloc]initWithURL:@"http://1.r7test.sinaapp.com/activity_1.json" ResultData:self.ResultData sender:self OnSuccess:@selector(ProcessData) OnError:nil];
}
- (void)ProcessData{
    
    ActivityBigImgURL=[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSJSONSerialization JSONObjectWithData:self.ResultData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"activity_pic"]]];
    ActivityTitle=[[NSJSONSerialization JSONObjectWithData:self.ResultData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"activity_title"];
    ActivityOriginatorName=[[NSJSONSerialization JSONObjectWithData:self.ResultData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"student_id"];
    ActivityOrganizationName=[[NSJSONSerialization JSONObjectWithData:self.ResultData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"organization_name"];
    [self.ActivityDetailView reloadData];
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
