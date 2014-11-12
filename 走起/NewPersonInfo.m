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
   
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    Uid=[[defaults objectForKey:@"user_id"]integerValue];
    MyToken=[defaults objectForKey:@"user_token"];
    NSLog(@"PersonInfoView Get token %@,id %d",MyToken,Uid);
    //MyToken=@"46Ms7ERFe7dpzXCFKjyw";

    [self GetInfo];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
                [cell initwithTitle:[tmp objectForKey:@"acitivity_title"] Img:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tmp objectForKey:@"activity_pic"]]] BeginTime:[tmp objectForKey:@"activity_begin_time"] EndTime:[tmp objectForKey:@"activity_end_time"] Place:[tmp objectForKey:@"activity_place"]];
                cell.accessoryType=UITableViewCellAccessoryNone;
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
            cell.backgroundColor=[UIColor orangeColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==2)
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
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==[actionSheet destructiveButtonIndex])
        //这里捕捉“毁灭键”,其实该键的index是0，从上到下从0开始，称之为毁灭是因为是红的
    {
        NSLog(@"User Logout，没做完，需要联机，别忘了做完。。。");
        NSString *URLplist=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        NSString *URLpre=[[[NSDictionary alloc]initWithContentsOfFile:URLplist] objectForKey:@"URLprefix"];
        NSData *CommentData=[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding];
        [[PostInfo alloc]initWithURL:[NSString stringWithFormat:@"%@/users/sign_out?user_token=%@",URLpre,MyToken] HttpMethod:@"DELETE" postData:CommentData resultData:RevData sender:self onSuccess:@selector(ReceiveSuccess) onError:nil];
        ///////没做完，需要联机
    }
}

-(void) ReceiveSuccess{
    NSLog(@"Logout! %@",[[NSString alloc]initWithData:RevData encoding:NSUTF8StringEncoding]);
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user_token"];
    [defaults synchronize];
    //TRUE FLASE;
}
#pragma mark network

-(void) GetInfo{
    RevData=[NSMutableData alloc];
    NSString *URLplist=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSString *URLpre=[[[NSDictionary alloc]initWithContentsOfFile:URLplist] objectForKey:@"URLprefix"];
    [[GetInfo alloc]initWithURL:[NSString stringWithFormat:@"%@/users/1.json",URLpre] ResultData:RevData sender:self OnSuccess:@selector(ProcessData) OnError:@selector(DealError)];
}

-(void) ProcessData{
    DataDic=[NSJSONSerialization JSONObjectWithData:RevData options:NSJSONReadingMutableContainers error:nil];
    MyADic=[DataDic objectForKey:@"myactivity"];
    
    UserLogo=[NSData dataWithContentsOfURL:[NSURL URLWithString:[DataDic objectForKey:@"userlogo"]]];
    UserName=[DataDic objectForKey:@"email"];
    UserPraise=[[DataDic objectForKey:@"praise"] floatValue];
    SchoolName=[DataDic objectForKey:@"school_name"];
    NSLog(@"%@",DataDic);
    NSLog(@"%@,%f,%@",UserName,UserPraise,SchoolName);
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
            return 70;
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
