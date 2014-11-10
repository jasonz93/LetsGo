//
//  CommentViewController.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/6/14.
//
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CommentViewController's Aid is %@",self.Aid);
    [self GetComment];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // NSLog(@"NumberOfCell:%d",CommentList.count);
    return CommentList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static BOOL CommentCellLoaded=NO;
    if(!CommentCellLoaded){
        // NSLog(@"CC first load");
        UINib *nib=[UINib nibWithNibName:@"CommentCell" bundle:nil];
        [self.CommentTableView registerNib:nib forCellReuseIdentifier:@"CC"];
        CommentCellLoaded=YES;
    }
    CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CC"];
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CC"];
    if (cell==nil ) {
        cell=[[CommentCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CC"];
        //cell=[[CommentCell alloc]init];
    }
    NSDictionary *tmp =[CommentList objectAtIndex:[indexPath row]];
    //NSLog(@"%@",tmp);
    //cell.textLabel.text=[tmp objectForKey:@"comment_content"];
    //cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tmp objectForKey:@"comment_pic"]]]];
    [cell initWithComment:[tmp objectForKey:@"comment_content"]];
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}




-(void)GetComment{
    ResultData=[NSMutableData alloc];
    [[GetInfo alloc]initWithURL:@"http://1.r7test.sinaapp.com/comment.json" ResultData:ResultData sender:self OnSuccess:@selector(DealWithData) OnError:nil];
    
}

-(void)DealWithData{
    //NSLog(@"CommentList:");
    CommentList=[[NSJSONSerialization JSONObjectWithData:ResultData options:NSJSONReadingMutableContainers error:nil]objectForKey:@"Comment"];
    // NSLog(@"%@",CommentList);
    [self.CommentTableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
