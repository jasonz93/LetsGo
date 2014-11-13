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
[super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)preinit{
    //NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"user_token"];
    //[defaults synchronize];
    
    SingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpenDetailView)];
    SingleTap.delegate=self;
    SingleTap.cancelsTouchesInView=NO;
    PageArray=[[NSMutableArray alloc]init] ;
    [ASVV addGestureRecognizer:SingleTap];
    ASVV.backgroundColor=[UIColor colorWithRed:227.0/255 green:232.0/255 blue:234.0/255 alpha:1.0f];
    [self.view addSubview:ASVV];
    PGC=[[UIPageControl alloc]initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width/2-100, [UIScreen mainScreen].applicationFrame.size.height-RTopHeight+10, 200, 36)];
    NSLog(@"Notice!- HotActivityPage:-  PGC-frame:%f,%f,%f,%f",PGC.frame.origin.x,PGC.frame.origin.y,PGC.frame.size.width,PGC.frame.size.height);
    NSLog(@"Notice!- HotActivityPage:-  CompareWith Scroll-frame:%f,%f,%f,%f",ASVV.frame.origin.x,ASVV.frame.origin.y,ASVV.frame.size.width,ASVV.frame.size.height);

    PGC.currentPage = 0;
    PGC.userInteractionEnabled = YES;
    PGC.alpha = 1.0;
   [ASVV addSubview:PGC];
    
}

-(void)viewWillAppear:(BOOL)animated{
    MicroLen=10.0f;
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f]];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    Mytoken=[defaults objectForKey:@"user_token"];
    NSLog(@"Hot Activity Get token %@",Mytoken);
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f];
    [self.navigationItem setTitle:@"热门活动"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self preinit];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self GetMyAList];
}

-(void)viewDidDisappear:(BOOL)animated{
    for (UIView* a in PageArray) {
        [a removeFromSuperview];
    }
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
    NSLog(@"Trun to page= %d Set the Control page= %ld",pageNum,(long)PGC.currentPage);
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
    ASVV.contentSize=CGSizeMake([UIScreen mainScreen].applicationFrame.size.width*AList.count, ASVV.frame.size.height);
    ASVV.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    PGC.numberOfPages = AList.count;
    NSLog(@"Page Control Display %ld dots",(long)PGC.numberOfPages);
    [self initActivityView];
}

-(void) initActivityView{
    NSLog(@"Notice!- HotActivityView:- ContentView  size: width:%f ,height:%f",ASVV.contentSize.width,ASVV.contentSize.height);
    NSLog(@"Notice!- HotActivityView:- scrollview  size: width:%f ,height:%f",ASVV.frame.size.width,ASVV.frame.size.height);
    for(int itr=0;itr<AList.count;itr++)
    {
        ActivityNewView *viewer;
        viewer=[[[NSBundle mainBundle] loadNibNamed:@"ActivityNewView" owner:self options:nil]objectAtIndex:0];
        if(viewer==nil)
            viewer=[ActivityNewView alloc];
        NSDictionary *tmp=[AList objectAtIndex:itr];
        //viewer.frame=CGRectMake(320*itr,0.0f, 320.0f, ASVV.contentSize.height);
        viewer.frame=CGRectMake(ASVV.frame.size.width*itr+MicroLen,MicroLen, ASVV.frame.size.width-2*MicroLen, ASVV.frame.size.height-2*MicroLen);
        [viewer initWithImg:[tmp objectForKey:@"activity_logo"] Title:[tmp objectForKey:@"activity_title"] Time:[tmp objectForKey:@"activity_begin_time"] Place:[tmp objectForKey:@"activity_place"] PeopleMax:[NSString stringWithFormat:@"%@",[tmp objectForKey:@"activity_people_max"]] PeopleJioned:[NSString stringWithFormat:@"%@",[tmp objectForKey:@"activity_people_number"]]];
        [ASVV addSubview:viewer];
        [PageArray addObject:viewer];
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
