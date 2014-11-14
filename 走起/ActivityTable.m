//
//  ActivityTable.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/5/14.
//
//

#import "ActivityTable.h"

@interface ActivityTable ()

@end

@implementation ActivityTable

- (void)viewDidLoad {
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f];
    [self.navigationItem setTitle:@"活动详情"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self preinit];
    [super viewDidLoad];
    [self initRefreshControl];
    [self.refreshControl beginRefreshing];
    [self RefreshATable];
}

-(void)preinit{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    Mytoken=[defaults objectForKey:@"user_token"];
    NSLog(@"ActivityTable Get Aid=%@,UserToken %@",self.Aid,Mytoken);
    SendCommentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ContentTxT=[[UITextView alloc]initWithFrame:CGRectMake(0, 40.0f, [UIScreen mainScreen].applicationFrame.size.width, CGFLOAT_MAX)];
    ContentTxT.editable=NO;
    ContentTxT.scrollEnabled=NO;
    ContentTxT.textColor=[UIColor colorWithRed:96.0/255 green:125.0/255 blue:139.0/255 alpha:1.0f];
    
    ContentTitle=[[UILabel alloc]initWithFrame:CGRectMake(8.0f, 8.0f, 80.0f, 30.0f)];
    ContentTitle.font=[UIFont systemFontOfSize:18.0f];
    ContentTitle.text=@"活动详情";
    ContentTitle.textColor=[UIColor colorWithRed:96.0/255 green:125.0/255 blue:139.0/255 alpha:1.0f];
    ActivityPic=[[UIImageView alloc]initWithFrame:CGRectMake(8.0f,46.0f, [UIScreen mainScreen].applicationFrame.size.width-16, ([UIScreen mainScreen].applicationFrame.size.width-16)/2)];
}
-(void)CellPrepare{
    
    ContentTxT.text=[AData_Dic objectForKey:@"activity_content"];
    [ContentTxT sizeToFit];
    ContentTxT.frame=CGRectMake(ContentTxT.frame.origin.x, ContentTxT.frame.origin.y, [UIScreen mainScreen].applicationFrame.size.width, ContentTxT.frame.size.height);
    ContentH=ContentTxT.frame.size.height;
    
    ImgURL=[AData_Dic objectForKey:@"activity_logo"];
    TitleTxt=[AData_Dic objectForKey:@"activity_title"];
    OwnerTxt=[NSString stringWithFormat:@"发起者：%@",[AData_Dic objectForKey:@"owner_name"]];
    OrginizationTxt=[NSString stringWithFormat:@"活动所属群组：%@",[AData_Dic objectForKey:@"organization_name"]];
    PlaceTxt=[NSString stringWithFormat:@"活动地点：%@",[AData_Dic objectForKey:@"activity_place"]];
    TimeTxt=[AData_Dic objectForKey:@"activity_begin_time"];
    TimeEndTxt=[AData_Dic objectForKey:@"activity_end_time"];
    PeopleTxt=[NSString stringWithFormat:@"报名人数：%@   人数限额：%@",[AData_Dic objectForKey:@"activity_people_max"],[AData_Dic objectForKey:@"activity_people_number"]];
    PicURL=[AData_Dic objectForKey:@"activity_pic"];
    [SendCommentBtn setTitle:@"发表评论" forState:UIControlStateNormal];
    //ActivityPic.image=[UIImage imageWithData:PicURL];
    [Common loadPic:PicURL imageView:ActivityPic];
    SendCommentBtn.titleLabel.font=[UIFont systemFontOfSize: 13.0];
    SendCommentBtn.backgroundColor=[UIColor blackColor];
    [SendCommentBtn addTarget:self action:@selector(OpenSendCommentBtn) forControlEvents:UIControlEventTouchDown];
    Afinished=[[AData_Dic objectForKey:@"finished"]boolValue];
    ship_id=[AData_Dic objectForKey:@"ship_id"];
    if(ship_id==nil)
    {
        Ajioned=0;
    }
    else
    {
        Ajioned=1;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self GetActivityDetail];
    [self.ATableView reloadData];
}

-(void) initRefreshControl{
    UIRefreshControl *Rc=[[UIRefreshControl alloc]init];
    Rc.attributedTitle=[[NSAttributedString alloc]initWithString:@"👻下拉刷新"];
    [Rc addTarget:self action:@selector(RefreshATable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=Rc;
}

-(void) RefreshATable{
    if(self.refreshControl.refreshing){
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"😂加载中"];
        [self GetActivityDetail];
    }
}

-(void)GetActivityDetail{
    AData=[NSMutableData alloc];
    NSString *URLpre=[Common getUrlString:[NSString stringWithFormat:@"/activities/%@.json",self.Aid]];
    [[GetInfo alloc]initWithURL:URLpre ResultData:AData sender:self OnSuccess:@selector(ProcessData) OnError:@selector(DealError)];
}

-(void) ProcessData{
    NSLog(@"Get Activity Detail Data");
    if(self.refreshControl.refreshing)
    {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"👻下拉刷新"];
    }
    AData_Dic= [NSJSONSerialization JSONObjectWithData:AData options:NSJSONReadingMutableContainers error:nil];
    AComment=[AData_Dic objectForKey:@"comments"];
    [self CellPrepare];
    [self.ATableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
        return 4;
    else
    {
        if(AComment.count<10)
            return AComment.count;
        else
            return  AComment.count+1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section]==0)
    {
        switch([indexPath row])
        {
            case 0:{
                ImgAndTitleCellLoaded=NO;
                if(!ImgAndTitleCellLoaded){
                    NSLog(@"Conetent cell is nil,Creat Content Cell");
                    UINib *nib=[UINib nibWithNibName:@"ActivityImgTitleCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:@"AITC"];
                    ImgAndTitleCellLoaded=YES;
                }
                ActivityImgTitleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AITC"];
                if(cell==nil)
                {
                    cell=[[ActivityImgTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AITC"];
                }
                //cell.ActivityImg.image=[UIImage imageWithData:ImgURL];
                [Common loadPic:ImgURL imageView:cell.ActivityImg];
                cell.accessoryType=UITableViewCellAccessoryNone;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [cell initWithImg:ImgURL Title:TitleTxt Place:PlaceTxt Time:TimeTxt NewEndTime:TimeEndTxt Owner:OwnerTxt];
                return cell;
            }
                break;
            case 1:
            {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ContentT"];
                if(cell==nil)
                {
                    NSLog(@"Conetent Title cell is nil,Creat Content Title Cell");
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentT"];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [cell addSubview:ActivityPic];
                [cell addSubview:ContentTitle];
                return cell;
            }
            case 2:
            {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ContentCell"];
                if(cell==nil)
                {
                    NSLog(@"Conetent cell is nil,Creat Content Cell");
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentCell"];
                }
                [cell addSubview:ContentTxT];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 3:
            {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BtnCell"];
                if(cell==nil)
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BtnCell"];
                if(Afinished)
                {
                    ButtonStyle=0;
                    cell.textLabel.text=@"发表评论";
                }
                else
                {
                    if(Ajioned)
                    {
                        ButtonStyle=1;
                        cell.textLabel.text=@"离开";
                    }
                    else
                    {
                        ButtonStyle=2;
                        cell.textLabel.text=@"加入";
                    }
                }
                cell.textLabel.font=[UIFont systemFontOfSize:18.0f];
                cell.textLabel.textColor=[UIColor whiteColor];
                cell.textLabel.textAlignment=NSTextAlignmentCenter;
                cell.backgroundColor=[UIColor colorWithRed:38.0/255 green:166.0/255 blue:154.0/255 alpha:1.0];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            default:
            {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"aaaa"];
                if(cell==nil)
                {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aaaa"];
                }
                cell.textLabel.text=@"testtttt";
                //cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    else
    {
        if(AComment.count>=10 &&[indexPath row]==AComment.count)
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BtnCell"];
            if(cell==nil)
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BtnCell"];
            cell.textLabel.font=[UIFont systemFontOfSize:18.0f];
            cell.textLabel.textColor=[UIColor grayColor];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.text=@"查看更多";
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
        CommentCellLoaded=NO;
        if(!CommentCellLoaded){
            UINib *nib=[UINib nibWithNibName:@"CommentCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"CC"];
            CommentCellLoaded=YES;
        }
        CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CC"];
        if (cell==nil ) {
            cell=[[CommentCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CC"];
        }
        NSDictionary *tmp =[AComment objectAtIndex:[indexPath row]];
        cell.User_name.text=[tmp objectForKey:@"email"];
        cell.CommentContent.text=[tmp objectForKey:@"comment_content"];
        NSLog(@"User Comment Info is :%@",tmp);
        if([[AComment objectAtIndex:[indexPath row]] objectForKey:@"user_logo"])
        {
            [Common loadPic:[[AComment objectAtIndex:[indexPath row]]objectForKey:@"user_logo"] imageView:cell.UserLogo];

        }
        else
        {
            cell.UserLogo.image=[UIImage imageNamed:@"SnowPng"];
            // cell.UserLogo.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[AComment objectAtIndex:[indexPath row]]objectForKey:@"user_logo"]]]];
        }
            [cell.UserLogo .layer setMasksToBounds:YES];
            [cell.UserLogo.layer setCornerRadius:10];
            [cell.UserLogo.layer setBorderWidth:1];
            [cell.UserLogo.layer setBorderColor:[[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f]CGColor]];
            
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        return cell;
        }
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==0)
    {
        switch ([indexPath row]) {
            case 0://IMG TITLE
                return 154;
                break;
            case 1:
                return 46+ActivityPic.frame.size.height;
            case 2:
                return ContentH;
                break;
            default:
                return 40;
                break;
        }
    }
    else
    {
        if([indexPath row]==AComment.count)
        {
            return 40;
        }
        else
        {
            return 66;
        }
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0)
    {
        UIView *cell=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        return cell;
    }
    else
    {
        UIView *CTview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 15)];
        UILabel *CTL=[[UILabel alloc]initWithFrame:CGRectMake(8, 8, [UIScreen mainScreen].applicationFrame.size.width, 15)];
        CTL.text=[NSString stringWithFormat: @"评论 %lu",(unsigned long)AComment.count];
        CTL.font=[UIFont systemFontOfSize:13.0f];
        CTL.textColor=[UIColor colorWithRed:96.0/255 green:125.0/255 blue:139.0/255 alpha:1.0f];
        CTview.backgroundColor=[UIColor whiteColor];
        [CTview addSubview:CTL];
        return CTview;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==0)
    {
    if([indexPath row]==3)
    {
        switch(ButtonStyle)
        {
            case 0:
            {
                NSLog(@"Press SendComment Button");
                [self OpenSendCommentBtn];
            }
                break;
            case 1:
            {
                [self QuitActivity];
                NSLog(@"Press Quit Activity Button");
            }
                break;
            case 2:
            {
                [self JionActivity];
                NSLog(@"Press Jion Activity Button");
            }
                break;
            default:
                NSLog(@"Press Button Error!!");
        }
    }}
    else
    {
        if([indexPath row]==AComment.count)
        {
            [self OpenCommentDetail];
        }
    }
}


-(void)OpenCommentDetail{
    NSLog(@"ActivityTable:- Open CommentList View");
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentDetailView *CDetail=[storyBoard instantiateViewControllerWithIdentifier:@"CommentsDetailView" ];
    CDetail.hidesBottomBarWhenPushed=YES;
    CDetail.Aid=self.Aid;
    [self.navigationController pushViewController:CDetail animated:YES];
}

-(void)QuitActivity{
    //curl -X DELETE -H "Content-Type: application/json" -d '{"activity_id":1}' localhost:3000/activity_memberships.json?user_token=dB4EyczCNnaGayypEZXG
    
    //NSString *URLplist=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSString *URLpre=[Common getUrlString:[NSString stringWithFormat:@"/activity_memberships/%@.json?user_token=%@",ship_id,Mytoken]];
    NSLog(@"Request Quit Activity,the URL is %@",URLpre);
    // NSString *CompleteURL=[NSString stringWithFormat:@"%@/activity_memberships/%d.json?user_token=%@",URLpre,ship_id,Mytoken];
    [[PostInfo alloc]initWithURL:URLpre HttpMethod:@"DELETE" postData:nil resultData:PostReslut sender:self onSuccess:@selector(QuitSuccess) onError:nil];
}

-(void)JionActivity{
    //curl -X POST -H "Content-Type: application/json" -d  localhost:3000/activity_memberships.json?user_token=dB4EyczCNnaGayypEZXG
    NSString *URLpre=[Common getUrlString:[NSString stringWithFormat: @"/activity_memberships.json?user_token=%@",Mytoken]];
    NSData *JoinData=[[NSString stringWithFormat:@"{\"activity_id\":%ld}",(long)[self.Aid integerValue]] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Post URL:%@\nData%@",URLpre,[NSString stringWithFormat:@"{\"activity_id\":%ld}",(long)[self.Aid integerValue]]);
    PostReslut=[NSMutableData alloc];
    NSLog(@"Request Join Activity,the URL is %@",URLpre);
    [[PostInfo alloc]initWithURL:URLpre HttpMethod:@"POST" postData:JoinData resultData:PostReslut sender:self onSuccess:@selector(JionSuccess) onError:nil];
}

-(void)JionSuccess
{
    NSLog(@"%@",PostReslut);
    NSLog(@"Jion Activity Success,Receive: %@",[[NSString alloc]initWithData:PostReslut encoding:NSUTF8StringEncoding]);
    ButtonStyle=1;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    Ajioned=YES;
    ship_id=[[NSJSONSerialization JSONObjectWithData:PostReslut options:NSJSONReadingMutableContainers error:nil]objectForKey:@"ship_id" ];
    
    NSDictionary *test=[NSJSONSerialization JSONObjectWithData:PostReslut options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",test);
    NSLog(@"Get New ship id:%@",ship_id);
    cell.textLabel.text = @"离开";
}

-(void)QuitSuccess
{
    NSLog(@"Quit Success,Info:%@",[[NSString alloc]initWithData:PostReslut encoding:NSUTF8StringEncoding]);
    ButtonStyle=2;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    Ajioned=NO;
    
    cell.textLabel.text = @"加入";
}


-(void)OpenSendCommentBtn{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendCommentViewController *SendCommentVC=[storyBoard instantiateViewControllerWithIdentifier:@"SendCommentView" ];
    SendCommentVC.Aid=self.Aid;
    [self presentViewController:SendCommentVC animated:YES completion:^{
    }];
    
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
