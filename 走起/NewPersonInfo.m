//
//  NewPersonInfo.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/10/14.
//
//

#import "NewPersonInfo.h"

@interface NewPersonInfo ()

@end

@implementation NewPersonInfo


- (void)viewDidLoad {
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f];
    [self.navigationItem setTitle:@"个人信息"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.InfoTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    Uid=[[defaults objectForKey:@"user_id"]integerValue];
    MyToken=[defaults objectForKey:@"user_token"];
    NSLog(@"PersonInfoView Get token %@,id %ld",MyToken,(long)Uid);
    //创建一个右边按钮
    /*UIBarButtonItem *AddActivity=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(OpenAddView)];
    [self.navigationItem setRightBarButtonItem:AddActivity];*/
    [self initRefreshControl];
    //[self.refreshControl beginRefreshing];
    [self GetInfo];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)OpenAddView{
   /* UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateActivityViewController *CreatVC=[storyBoard instantiateViewControllerWithIdentifier:@"creatactivityview" ];
    [self presentViewController:CreatVC animated:YES completion:^{
    }];*/
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateActivityViewController *CreatVC=[storyBoard instantiateViewControllerWithIdentifier:@"createactivityview" ];
    CreatVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:CreatVC animated:YES];

    
}

-(void) initRefreshControl{
    UIRefreshControl *Rc=[[UIRefreshControl alloc]init];
    Rc.attributedTitle=[[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [Rc addTarget:self action:@selector(RefreshAList) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=Rc;
}

-(void) RefreshAList{
    if(self.refreshControl.refreshing){
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中"];
        [self GetInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}// fixed font style. use custom view (UILabel) if you want something different



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return MyADic.count;
            break;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch([indexPath section])
    {
        case 0:
        {
                PersonCellLoaded=NO;
                    if(!PersonCellLoaded){
                        UINib *nib=[UINib nibWithNibName:@"PersonInfoCell" bundle:nil];
                        [tableView registerNib:nib forCellReuseIdentifier:@"PersonInfoCell"];
                        PersonCellLoaded=YES;
                    }
                    PersonInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PersonInfoCell"];
                    if(cell==nil)
                    {
                        cell=[[PersonInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonInfoCell"];
                    }
                    [cell initWithUserLogo:UserLogo UserName:UserName Schoolname:SchoolName Praise:UserPraise];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                    return cell;
        }
            break;
                 /*default:
                {
                    static BOOL MyLV=NO;
                    if(!MyLV){
                        UINib *nib=[UINib nibWithNibName:@"LevelCell" bundle:nil];
                        [tableView registerNib:nib forCellReuseIdentifier:@"MYLV"];
                        MyLV=YES;
                    }
                    LevelCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MYLV"];
                    if (cell==nil ) {
                        cell=[[ LevelCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MYLV"];
                    }
                    [cell initWithPraise:UserPraise];
                    [cell ShowPop];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                    return cell;
                }
                    break;*/
        case 1:
            {
                MyAC=NO;
                if(!MyAC){
                    UINib *nib=[UINib nibWithNibName:@"ActivityIntroCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:@"MYAC"];
                    MyAC=YES;
                }
                ActivityIntroCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MYAC"];
                if (cell==nil ) {
                    cell=[[ ActivityIntroCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MYAC"];
                }
                NSDictionary *tmp;
                tmp=[MyADic objectAtIndex:[indexPath row]];
                [cell initwithTitle:[tmp objectForKey:@"acitivity_title"] Img:[tmp objectForKey:@"activity_pic"] BeginTime:[tmp objectForKey:@"activity_begin_time"] EndTime:[tmp objectForKey:@"activity_end_time"] Place:[tmp objectForKey:@"activity_place"]];
                cell.accessoryType=UITableViewCellAccessoryNone;
                return cell;
            }
            break;
        case 2:
        {
            
            UITableViewCell *cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CanCell"];
            if(cell==nil)
            {
                cell=[[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CanCell"];
            }
            cell.textLabel.text=@"发起活动";
            cell.textLabel.font=[UIFont systemFontOfSize:18.0f];
            cell.textLabel.textColor=[UIColor whiteColor];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.backgroundColor=[UIColor orangeColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        default:
        {
            UITableViewCell *cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CanCell"];
            if(cell==nil)
            {
                cell=[[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CanCell"];
            }
            cell.textLabel.text=@"注销登录";
            cell.textLabel.font=[UIFont systemFontOfSize:18.0f];
            cell.textLabel.textColor=[UIColor whiteColor];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.backgroundColor=[UIColor redColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==3)
    {
        UIActionSheet *LogoutQ=[[UIActionSheet alloc]initWithTitle:@"确定注销登录？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销登录" otherButtonTitles:nil, nil];        //注销登录
         [LogoutQ showInView:self.view];
    }
    if([indexPath section]==1)
    {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityTable *AactivityDetail=[storyBoard instantiateViewControllerWithIdentifier:@"ActivityTableView" ];
        AactivityDetail.hidesBottomBarWhenPushed=YES;
        AactivityDetail.Aid=[[MyADic objectAtIndex:[indexPath row]]objectForKey:@"activity_id"];
        [self.navigationController pushViewController:AactivityDetail animated:YES];
    }
    if([indexPath section]==2)
    {
        [self OpenAddView];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==[actionSheet destructiveButtonIndex])
        //这里捕捉“毁灭键”,其实该键的index是0，从上到下从0开始，称之为毁灭是因为是红的
    {
        NSLog(@"User Logout");
        NSString *URLpre=[Common getUrlString:@"/users/sign_out"];
        NSData *CommentData=[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding];
        [[PostInfo alloc]initWithURL:URLpre HttpMethod:@"DELETE" postData:CommentData resultData:RevData sender:self onSuccess:@selector(ReceiveSuccess) onError:nil];
        }
}

-(void) ReceiveSuccess{
    NSLog(@"Logout! %@",[[NSString alloc]initWithData:RevData encoding:NSUTF8StringEncoding]);
    /*
    UIStoryboard *storyBoard=self.storyboard;
    LoginView *lv=[storyBoard instantiateViewControllerWithIdentifier:@"loginview" ];
    [self presentViewController:lv animated:YES completion:^{
    }];*/
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    //TRUE FLASE;
}
#pragma mark network

-(void) GetInfo{
    if(self.refreshControl.refreshing)
    {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"👻下拉刷新"];
    }
    RevData=[NSMutableData alloc];
    NSString *URLpre=[Common getUrlString:[NSString stringWithFormat:@"/users/%ld.json",(long)Uid]];
    NSLog(@"PersonInfoPage: Request URL is:%@",URLpre);
    [[GetInfo alloc]initWithURL:URLpre ResultData:RevData sender:self OnSuccess:@selector(ProcessData) OnError:@selector(DealError)];}

-(void) ProcessData{
    DataDic=[NSJSONSerialization JSONObjectWithData:RevData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"PersonInfoPage:-Data:%@",DataDic);
    
    MyADic=[DataDic objectForKey:@"myactivity"];
    
    UserLogo=[DataDic objectForKey:@"user_logo"];
    if([DataDic objectForKey:@"student_name"]==nil)
    {
        NSLog(@"名字为空，显示email!");
        UserName=[DataDic objectForKey:@"email"];
    }
    else
    {
        NSLog(@"有名字，显示名字");
        UserName=[DataDic objectForKey:@"student_name"];
    }
    UserPraise=[DataDic objectForKey:@"praise"];
    SchoolName=[DataDic objectForKey:@"school_name"];
    NSLog(@"%@",DataDic);
    NSLog(@"%@,%@,%@",UserName,UserPraise,SchoolName);
    [self.InfoTable reloadData];
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
}
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ([indexPath section]) {
        case 0:
        {
            return 85;
            break;
        }
            
        case 1:
        {
            return 106;
        }
        default:
        {
            return 40;
        }
            break;
    }
    return 200;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
