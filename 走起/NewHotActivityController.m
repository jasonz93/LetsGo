//
//  NewHotActivityController.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/9/14.
//
//

#import "NewHotActivityController.h"
#import "LoginView.h"
@interface NewHotActivityController ()

@end

@implementation NewHotActivityController

- (void)viewDidLoad {
    MicroLen=10.0f;
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f]];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    Mytoken=[defaults objectForKey:@"user_token"];
    NSLog(@"Hot Activity Get token %@",Mytoken);
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f];
    [self.navigationItem setTitle:@"热门活动"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self preinit];
    [self GetMyAList];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)preinit{
    
    SingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpenDetailView)];
    SingleTap.delegate=self;
    SingleTap.cancelsTouchesInView=NO;
    
    ASV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, RTopHeight, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height-RtotalHeight)];
    ASV.showsHorizontalScrollIndicator = NO;
    ASV.showsVerticalScrollIndicator = NO;
    ASV.userInteractionEnabled = YES;
    ASV.pagingEnabled = YES;
    ASV.scrollsToTop = NO;
    ASV.delegate = self;
    [ASV addGestureRecognizer:SingleTap];
    ASV.backgroundColor=[UIColor colorWithRed:227.0/255 green:232.0/255 blue:234.0/255 alpha:1.0f];
    [self.view addSubview:ASV];
    PGC=[[UIPageControl alloc] initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width/2-100, [UIScreen mainScreen].applicationFrame.size.height-RTopHeight+10, 200, 36)];
    PGC.currentPage = 0;
    PGC.userInteractionEnabled = YES;
    PGC.alpha = 1.0;
    //SendCommentBtn addTarget:self action:@selector(OpenSendCommentBtn) forControlEvents:UIControlEventTouchDown];
  //  [PGC addTarget:self action:@selector(PageValueChanged) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:PGC];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)OpenDetailView{
    NSLog(@"Open Activity Detail View");
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityTable *AactivityDetail=[storyBoard instantiateViewControllerWithIdentifier:@"ActivityTableView" ];
    AactivityDetail.hidesBottomBarWhenPushed=YES;
    AactivityDetail.Aid=[[AList objectAtIndex:PGC.currentPage]objectForKey:@"activity_id"];
    [self.navigationController pushViewController:AactivityDetail animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViews {
    int pageNum = fabs(scrollViews.contentOffset.x / scrollViews.frame.size.width);
    PGC.currentPage=pageNum;
    NSLog(@"Trun to page= %d Set the Control page= %d",pageNum,PGC.currentPage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -Newwork
-(void) GetMyAList{
    RevData=[NSMutableData alloc];
    NSString *URLpre=[Common getUrlString:@"/activities.json"];
    [[GetInfo alloc]initWithURL:URLpre  ResultData:RevData sender:self OnSuccess:@selector(ProcessData) OnError:@selector(DealError)];
}

-(void) ProcessData{
    AList= [NSJSONSerialization JSONObjectWithData:RevData options:NSJSONReadingMutableContainers error:nil];
   /* NSDictionary *Errdic=(NSDictionary*)AList;
     NSLog(@"Alist:%@",Errdic);
    if([Errdic objectForKey:@"error"]!=nil)
    {
       NSLog(@"判断到登陆失效，即将跳转到登陆界面");
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginView *lv=[storyBoard instantiateViewControllerWithIdentifier:@"loginview" ];
        [self presentViewController:lv animated:YES completion:^{
        }];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"user_token"];
        [defaults synchronize];
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginView *regview=[storyBoard instantiateViewControllerWithIdentifier:@"loginview" ];
        regview.hidesBottomBarWhenPushed=YES;
        [self.navigationController addChildViewController:regview];

    }
    else
    {*/
    ASV.contentSize=CGSizeMake([UIScreen mainScreen].applicationFrame.size.width*AList.count, ASV.frame.size.height);
    PGC.numberOfPages = AList.count;
    NSLog(@"Page Control Display %d dots",PGC.numberOfPages);
    [self initActivityView];
}

-(void) initActivityView{
    for(int itr=0;itr<AList.count;itr++)
    {
        ActivityNewView *viewer;
        viewer=[[[NSBundle mainBundle] loadNibNamed:@"ActivityNewView" owner:self options:nil]objectAtIndex:0];
        if(viewer==nil)
            viewer=[ActivityNewView alloc];
        NSDictionary *tmp=[AList objectAtIndex:itr];
        //viewer.frame=CGRectMake(320*itr,0.0f, 320.0f, ASV.contentSize.height);
        viewer.frame=CGRectMake(ASV.frame.size.width*itr+MicroLen,MicroLen, ASV.frame.size.width-2*MicroLen, ASV.frame.size.height-2*MicroLen);
        NSLog(@"%F,%f,%f,%f",viewer.frame.origin.x,viewer.frame.origin.y,viewer.frame.size.width,viewer.frame.size.height);
        /*[viewer initWithImg:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tmp objectForKey:@"activity_logo"]]] Title:[tmp objectForKey:@"activity_title"] Time:[tmp objectForKey:@"activity_begin_time"] Place:[tmp objectForKey:@"activity_place"] PeopleMax:[NSString stringWithFormat:@"%@",[tmp objectForKey:@"activity_people_max"]] PeopleJioned:[NSString stringWithFormat:@"%@",[tmp objectForKey:@"activity_people_number"]]];*/
        [viewer initWithImg:[tmp objectForKey:@"activity_logo"] Title:[tmp objectForKey:@"activity_title"] Time:[tmp objectForKey:@"activity_begin_time"] Place:[tmp objectForKey:@"activity_place"] PeopleMax:[NSString stringWithFormat:@"%@",[tmp objectForKey:@"activity_people_max"]] PeopleJioned:[NSString stringWithFormat:@"%@",[tmp objectForKey:@"activity_people_number"]]];
        //NSLog(@"%f,%f,%f,%f,itr=%d",viewer.frame.origin.x,viewer.frame.origin.y,viewer.frame.size.width,viewer.frame.size.height,itr);
        //viewer=[[ActivityNewView alloc]initWithFrame:CGRectMake(320*itr+20.0f, 0+20.0f,320, 300)];
        //[viewer defalutinit];
        //[viewer addGestureRecognizer:SingleTap ];
        [ASV addSubview:viewer];
        NSLog(@"Add the %d subview OK",itr);
    }
    
}

-(void)DealError{
    NSLog(@"NetWork Error");
    MBProgressHUD *ErrorView=[[MBProgressHUD alloc]initWithView:self.view];
    ErrorView.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cry"]];
    ErrorView.mode=MBProgressHUDModeCustomView;
    ErrorView.delegate=self;
    ErrorView.labelText=@"网络不给力";
    [ErrorView show:YES];
    [self.view addSubview:ErrorView];
    [ErrorView hide:YES afterDelay:2];
    
}

#pragma mark -
#pragma mark HUD的代理方法,关闭HUD时执行
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
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
