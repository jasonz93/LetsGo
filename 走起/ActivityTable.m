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
-(void)LabelsAndContentInit{
    CGRect AppScreenFrame = [ UIScreen mainScreen ].applicationFrame;
    self.ActivityTitleLabel.font=[UIFont systemFontOfSize:18.0f];
    self.ActivityOriginatorLabel.frame=CGRectMake(0, 0, AppScreenFrame.size.width, 10);
    self.ActivityOriginatorLabel.font=[UIFont systemFontOfSize:12];
    self.ActivityOriginatorLabel.textColor=[UIColor lightGrayColor];
    
    self.ActivityOrganizationLabel.frame=CGRectMake(0, 0, AppScreenFrame.size.width, 10);
    self.ActivityOrganizationLabel.font=[UIFont systemFontOfSize:12];
    self.ActivityOrganizationLabel.textColor=[UIColor lightGrayColor];
}
- (void)viewDidLoad {
    [self LabelsAndContentInit];
    [self MapInit];
    [super viewDidLoad];
    NSLog(@"ActivityTable Aid is %@",self.Aid);
    [self initRefreshControl];
    [self.refreshControl beginRefreshing];
    [self RefreshATable];
    
    //[self TableInit];
    //[self.refreshControl beginRefreshing];
}

/*-(void)TableInit{
    NSLog(@"tableinit");
    CGSize ScreenSize=[UIScreen mainScreen].applicationFrame.size;
    self.ActivityOriginatorLabel.numberOfLines=1;
    [self.ActivityOriginatorLabel setFrame:CGRectMake(0, 0, ScreenSize.width, 22)];
    [self.ActivityOrganizationNameLabel setFrame:CGRectMake(0, 0, ScreenSize.width, 22)];

    self.ActivityOrganizationNameLabel.numberOfLines=1;
    self.ActivityTimeBeginLabel.numberOfLines=1;
    self.ActivityTimeEndLabel.numberOfLines=1;
    self.ActivityPlaceLabel.numberOfLines=1;
    self.ActivityPeopleLabel.numberOfLines=1;
    self.ActivityContentTxt.editable=NO;
    self.ActivityContentTxt.selectable=NO;
}*/

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
    [[GetInfo alloc]initWithURL:@"http://1.r7test.sinaapp.com/activity_1.json" ResultData:AData sender:self OnSuccess:@selector(ProcessData) OnError:nil];
}

-(void) ProcessData{
    if(self.refreshControl.refreshing)
    {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"👻下拉刷新"];
    }
    NSLog(@"Json Success received!!!");
    AData_Dic= [NSJSONSerialization JSONObjectWithData:AData options:NSJSONReadingMutableContainers error:nil];
   // AComment=[AData_Dic objectForKey:@"Comment"];
    [self ReloadActivityData];
}

-(void)ReloadActivityData{
    CLLocationCoordinate2D Activitycoords = CLLocationCoordinate2DMake([[AData_Dic objectForKey:@"activity_place_lat"] doubleValue],[[AData_Dic objectForKey:@"activity_place_lon"] doubleValue]);
    MKCoordinateRegion viewRegion=MKCoordinateRegionMakeWithDistance(Activitycoords, 1000, 1000);
    [self.ActivityMap setRegion:viewRegion animated:YES];
    ActivityPoint *Apoint=[[ActivityPoint alloc]init];
    Apoint.coordinate=Activitycoords;
    [self.ActivityMap addAnnotation:Apoint];
    
    
    
    self.ActivityImg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AData_Dic objectForKey:@"activity_pic"]]]];
    self.ActivityTitleLabel.text=[AData_Dic objectForKey:@"activity_title"];
    self.ActivityOrganizationLabel.text=[NSString stringWithFormat:@"活动所属群组：%@",[AData_Dic objectForKey:@"organization_name"]];
    self.ActivityOriginatorLabel.text=[NSString stringWithFormat:@"发起者：%@",[AData_Dic objectForKey:@"owner_name"]];
    self.ActivityTimeBeginLabel.text=[AData_Dic objectForKey:@"activity_begin_time"];
    self.ActivityTimeEndLabel.text=[AData_Dic objectForKey:@"activity_end_time"];
    self.ActivityPlaceLabel.text=[AData_Dic objectForKey:@"activity_place"];
    self.ActivityPeopleLabel.text=[NSString stringWithFormat:@"%@",[AData_Dic objectForKey:@"activity_people_number"]];
    self.ActivityContent.text=[AData_Dic objectForKey:@"activity_content"];
    self.ActivityContent.scrollEnabled = YES;
    //textView.font = [UIFont systemFontOfSize:14];
    self.ActivityContent.userInteractionEnabled = NO;
    self.ActivityContent.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    NSLog(@"Textview height is %f,content height is %f,cell height is %f",self.ActivityContent.frame.size.height,self.ActivityContent.contentSize.height,self.ContentCell.frame.size.height);
    //self.ActivityContent.frame=CGRectMake(self.ActivityContent.frame.origin.x,self.ActivityContent.frame.origin.y,self.ActivityContent.frame.size.width, 800);
    //self.ContentCell.frame=CGRectMake(self.ContentCell.frame.origin.x,self.ContentCell.frame.origin.y,self.ContentCell.frame.size.width, 800);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [segue.destinationViewController setValue:self.Aid forKey:@"Aid"];
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 617;
    //self.ActivityContent.contentSize.height;
  
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)MapInit{
    self.ActivityMap.mapType=MKMapTypeStandard;
    self.ActivityMap.delegate=self;
}

-(void) mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    NSLog(@"MapKit Run Error,Now U are in mapViewDidFailLoadingMap function");
    NSLog(@"Detail: %@",[error description]);
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *annotationView=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ActivityPoint"];
    if(annotationView==nil)
    {
        annotationView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"ActivityPoint"];
    }
    annotationView.pinColor=MKPinAnnotationColorRed;
    annotationView.animatesDrop=YES;
    annotationView.canShowCallout=YES;
    return annotationView;
    
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
