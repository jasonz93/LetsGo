//
//  OrgActListViewController.m
//  LetsGo
//
//  Created by Nicholas on 14/11/14.
//
//

#import <Foundation/Foundation.h>
#import "OrgActListViewController.h"

@interface OrgActListViewController()
@end

@implementation OrgActListViewController

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row=[indexPath row];
    if(!self.CellInited){
        UINib *nib=[UINib nibWithNibName:@"ActivityIntroCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"AList"];
        self.CellInited=YES;
    }
    ActivityIntroCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AList"];
    if (cell==nil ) {
        cell=[[ ActivityIntroCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AList"];
    }
    clsAct *act=[self.actList objectAtIndex:row];
    NSLog(@"%@",act.act_pic);
    [cell initwithTitle:act.act_title Img:act.act_logo BeginTime:act.act_begin EndTime:act.act_end Place:act.act_place];
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row=[indexPath row];
    UIStoryboard *storyBoard=self.storyboard;
    ActivityTable *AactivityDetail=[storyBoard instantiateViewControllerWithIdentifier:@"ActivityTableView" ];
    clsAct *act=[self.actList objectAtIndex:row];
    AactivityDetail.hidesBottomBarWhenPushed=YES;
    AactivityDetail.Aid=act.act_id;
    [self.navigationController pushViewController:AactivityDetail animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.actList.count;
}

-(void)gotActList{
    NSMutableArray *json=[NSJSONSerialization JSONObjectWithData:self.actData options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *act in json) {
        [self.actList addObject:[[clsAct alloc]initWithData:act]];
    }
    [self.tableView reloadData];
}

-(void)viewDidLoad{
    self.CellInited=NO;
    self.actData=[[NSMutableData alloc]init];
    self.actList=[[NSMutableArray alloc]init];
    NSString *url;
    if (self.org!=nil){
        url=[NSString stringWithFormat:@"%@/organizations/%ld/activities.json",[Common getUrlString:@""],self.org.orgID];
    }else{
        url=[NSString stringWithFormat:@"%@/schools/%ld/personalactivities.json",[Common getUrlString:@""],self.school.schoolID];
    }
    [[GetInfo alloc]initWithURL:url ResultData:self.actData sender:self OnSuccess:@selector(gotActList) OnError:nil];
    
}

@end