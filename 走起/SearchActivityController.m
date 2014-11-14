//
//  SearchActivityController.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/13/14.
//
//

#import "SearchActivityController.h"
#import "ActivityTable.h"
#import "ActivityIntroCell.h"
@interface SearchActivityController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation SearchActivityController




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityTable *AactivityDetail=[storyBoard instantiateViewControllerWithIdentifier:@"ActivityTableView" ];
    AactivityDetail.hidesBottomBarWhenPushed=YES;
    AactivityDetail.Aid=[[ADic objectAtIndex:[indexPath row]]objectForKey:@"activity_id"];
    [self.navigationController pushViewController:AactivityDetail animated:YES];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return ADic.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"creatcell");
    if(!cellloaded){
        UINib *nib=[UINib nibWithNibName:@"ActivityIntroCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"AList"];
        cellloaded=YES;
    }
    ActivityIntroCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AList"];
    if (cell==nil ) {
        cell=[[ ActivityIntroCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AList"];
    }
    NSDictionary *tmp;
    tmp=[ADic objectAtIndex:[indexPath row]];
    [cell initwithTitle:[tmp objectForKey:@"activity_title"] Img:[tmp objectForKey:@"activity_logo"] BeginTime:[tmp objectForKey:@"activity_begin_time"] EndTime:[tmp objectForKey:@"activity_end_time"] Place:[tmp objectForKey:@"activity_place"]];
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header=[[UIView alloc]init];
    header.backgroundColor=[UIColor clearColor];
    return header;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length>0){
        searchdata=[[NSMutableData alloc]init];
        NSString *url=[Common getUrlString:@"/activities/search"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setValue:searchBar.text forKey:@"activity_title"];
        NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        HTTPPost *post=[[HTTPPost alloc]initWithArgs:url postData:json resultData:searchdata sender:self onSuccess:@selector(searchDone) onError:@selector(networkErr)];
        [post Run];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    shouldTouch=YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return shouldTouch;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    shouldTouch=NO;
    
}

-(void)searchDone{
    //[actlist removeAllObjects];
    ADic=[NSJSONSerialization JSONObjectWithData:searchdata options:NSJSONReadingMutableLeaves error:nil];
    [self.ATable reloadData];
}
///////////////做到这里
-(void)networkErr{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setDelegate:self];
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce//手势方法
{
    [self.ASearch resignFirstResponder];
}

-(void)viewDidLoad{
    actlist=[[NSMutableArray alloc]init];
    self.ATable.delegate=self;
    self.ATable.dataSource=self;
    self.ASearch.delegate=self;
    [self tapBackground];
    self.ATable.sectionHeaderHeight=10;
    self.ATable.rowHeight=150;
    self.ATable.backgroundColor=[UIColor groupTableViewBackgroundColor];
    NSString *url=[Common getUrlString:@"/organizations.json"];///////////////////////////WHAT ARE U DOING.....
    searchdata=[[NSMutableData alloc]init];
    [[GetInfo alloc]initWithURL:url ResultData:searchdata sender:self OnSuccess:@selector(searchDone) OnError:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
 
    return cell;
}
*/

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
