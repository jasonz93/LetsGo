//
//  CommentDetailView.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/14/14.
//
//

#import "CommentDetailView.h"

@interface CommentDetailView ()

@end

@implementation CommentDetailView

- (void)viewDidLoad {
    RevData=[NSMutableData alloc];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f];
    [self.navigationItem setTitle:@"评论详情"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    NSLog(@"CommentDetailView:- My Aid is %@",self.Aid);
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [self GetCList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return Clist.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    NSDictionary *tmp =[Clist objectAtIndex:[indexPath row]];
    cell.User_name.text=[tmp objectForKey:@"email"];
    cell.CommentContent.text=[tmp objectForKey:@"comment_content"];
    //NSLog(@"User Comment Info is :%@",tmp);
    if([tmp objectForKey:@"user_logo"])
    {
        [Common loadPic:[[Clist objectAtIndex:[indexPath row]]objectForKey:@"user_logo"] imageView:cell.UserLogo];
    }
    else
    {
        cell.UserLogo.image=[UIImage imageNamed:@"SnowPng"];
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    [cell.UserLogo.layer setMasksToBounds:YES];
    [cell.UserLogo.layer setCornerRadius:10];
    [cell.UserLogo.layer setBorderWidth:1];
    [cell.UserLogo.layer setBorderColor:[[UIColor colorWithRed:0.0f green:150.0/255 blue:136.0/255 alpha:1.0f]CGColor]];
    
       return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}



//organizations/id/activities.json


-(void) GetCList{
    NSString *URLpre=[Common getUrlString:[NSString stringWithFormat:@"/activities/%@/comments.json",self.Aid]];
    [[GetInfo alloc]initWithURL:URLpre ResultData:RevData sender:self OnSuccess:@selector(ProcessData) OnError:nil];
}


-(void) ProcessData{
    NSLog(@"Json received success");
    Clist= [NSJSONSerialization JSONObjectWithData:RevData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"CommentDtailView:-CommentsList Reload");
    [self.CommentList reloadData];
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
