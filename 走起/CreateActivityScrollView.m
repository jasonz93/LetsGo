//
//  CreateActivityScrollView.m
//  LetsGo
//
//  Created by Nicholas on 14/11/5.
//
//

#import <Foundation/Foundation.h>
#import "CreateActivityScrollView.h"

@interface CreateActivityScrollView()<UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation CreateActivityScrollView

@synthesize txtActTitle;
@synthesize txtActContent;
@synthesize txtActPlace;
@synthesize txtActTime;
@synthesize txtActCap;
@synthesize txtActOrg;
@synthesize imgActLogo;
@synthesize imgActPic;
@synthesize view;
@synthesize txtActDur;
@synthesize btnCommit;
@synthesize controller;


UIDatePicker *dateActTime;
UIDatePicker *dateActDur;
UITableView *tblActOrg;
NSMutableData *logoUrlData;
NSMutableData *picUrlData;
NSString *logoUrl;
NSString *picUrl;
UIImagePickerController *logoPicker;
UIImagePickerController *picPicker;
NSMutableData *commitResult;
NSMutableArray *orgDataList;
NSMutableData *orgData;
NSString *user;

-(IBAction)test:(id)sender{
    NSLog(@"%f,%f",[self.lat floatValue],[self.lon floatValue]);
}

-(IBAction)Commit:(id)sender{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:self.txtActTitle.text forKey:@"activity_title"];
    [dic setValue:self.txtActContent.text forKey:@"activity_content"];
    [dic setValue:self.txtActPlace forKey:@"activity_place"];
    [dic setValue:@"" forKey:@"activity_place_lat"];
    [dic setValue:@"" forKey:@"activity_place_lon"];
    [dic setValue:self.txtActTime.text forKey:@"activity_begin_time"];
    [dic setValue:self.txtActDur.text forKey:@"activity_end_time"];//changed
    [dic setValue:self.txtActCap.text forKey:@"activity_people_max"];
    [dic setValue:user forKey:@"user_id"];
    [dic setValue:self.txtActOrg.text forKey:@"organization_id"];
    [dic setValue:[[NSString alloc]initWithData:logoUrlData encoding:NSUTF8StringEncoding] forKey:@"activity_logo"];
    [dic setValue:[[NSString alloc]initWithData:picUrlData encoding:NSUTF8StringEncoding] forKey:@"activity_pic"];
    NSMutableDictionary *request=[[NSMutableDictionary alloc]init];
    [request setObject:dic forKey:@"activity"];
    NSData *json=[NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:nil];
    commitResult=[[NSMutableData alloc]init];
    HTTPPost *post=[[HTTPPost alloc]initWithArgs:@"commit" postData:json resultData:commitResult sender:self onSuccess:@selector(commitDone) onError:@selector(errOrgData)];
    [post Run];
}

-(void)commitDone{
    
}

-(BOOL)canCommit{
    if ([self.txtActCap.text isEqualToString:@""])
        return NO;
    if ([self.txtActContent.text isEqualToString:@""])
        return NO;
    if ([self.txtActPlace.text isEqualToString:@""])
        return NO;
    if ([self.txtActTitle.text isEqualToString:@""])
        return NO;
    if (logoUrlData == nil)
        return NO;
    else
    {
        logoUrl=[[NSString alloc]initWithData:logoUrlData encoding:NSUTF8StringEncoding];
        if ([logoUrl isEqualToString:@""])
            return NO;
    }
    if (picUrlData == nil)
        return NO;
    else{
        picUrl=[[NSString alloc]initWithData:picUrlData encoding:NSUTF8StringEncoding];
        if ([picUrl isEqualToString:@""])
            return NO;
    }
    return YES;
}

-(void)uploadPic:(UIImage *)image result:(NSMutableData *)result{
    NSData *picData=UIImageJPEGRepresentation(image, 1.0);
    HTTPPost *post=[[HTTPPost alloc]initWithArgs:@"http://localhost/upload.php" postData:picData resultData:result sender:self onSuccess:@selector(uploadDone) onError:@selector(errOrgData)];
    [post Run];
}

-(void)uploadDone{
    [self.btnCommit setEnabled:[self canCommit]];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker == logoPicker){
        self.imgActLogo.image=image;
        logoUrlData=[[NSMutableData alloc]init];
        [Common uploadPic:image picUrl:logoUrlData sender:self onDone:@selector(uploadDone)];
    }
    if (picker == picPicker){
        self.imgActPic.image=image;
        picUrlData=[[NSMutableData alloc]init];
        [Common uploadPic:image picUrl:logoUrlData sender:self onDone:@selector(uploadDone)];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)getLogo:(id)sender{
    logoPicker=[[UIImagePickerController alloc]init];
    logoPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    logoPicker.mediaTypes=[NSArray arrayWithObjects:@"public.image", nil];
    logoPicker.allowsEditing=YES;
    
    logoPicker.delegate=self;
    [self.controller presentViewController:logoPicker animated:YES completion:nil];
}

-(IBAction)getPic:(id)sender{
    picPicker=[[UIImagePickerController alloc]init];
    picPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picPicker.mediaTypes=[NSArray arrayWithObjects:@"public.image", nil];
    picPicker.delegate=self;
    [self.controller presentViewController:picPicker animated:YES completion:nil];
}

-(void)hideTblActOrg{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect pos=CGRectMake(tblActOrg.frame.origin.x, tblActOrg.frame.origin.y, 200, 0);
    tblActOrg.frame=pos;
    [UIView commitAnimations];
}

-(void)showTblActOrg{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect pos=CGRectMake(tblActOrg.frame.origin.x, tblActOrg.frame.origin.y, 200, 180);
    tblActOrg.frame=pos;
    [UIView commitAnimations];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orgDataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    clsOrg *org=[orgDataList objectAtIndex:row];
    cell.textLabel.text = org.name;
    //cell.detailTextLabel.text = @"详细信息";
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)dateActDurChanged{
    self.txtActDur.text=[Common durFromDate:dateActDur.date];
}

-(void)showActDur{
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height-162.0f, 0, 0);
    [UIControl beginAnimations:nil context:nil];
    [UIControl setAnimationDuration:0.5];
    dateActDur.frame=pos;
    [UIControl commitAnimations];
}

-(void)hideActDur{
    [UIControl beginAnimations:nil context:nil];
    [UIControl setAnimationDuration:0.5];
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height, 0, 0);
    dateActDur.frame=pos;
    [UIControl commitAnimations];
}

-(void)dateActTimeChanged{
    self.txtActTime.text=[Common stringFromDate:dateActTime.date];
}

-(void)showActTime{
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height-162.0f, 0, 0);
    [UIControl beginAnimations:nil context:nil];
    [UIControl setAnimationDuration:0.5];
    dateActTime.frame=pos;
    [UIControl commitAnimations];
}

-(void)hideActTime{
    [UIControl beginAnimations:nil context:nil];
    [UIControl setAnimationDuration:0.5];
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height, 0, 0);
    dateActTime.frame=pos;
    [UIControl commitAnimations];
}

-(void)gotOrgData{
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:orgData options:NSJSONReadingMutableLeaves error:nil];
    NSInteger count = dic.count;
    [orgDataList removeAllObjects];
    for (int i=0; i<count; i++){
        [orgDataList addObject:[[clsOrg alloc]initWithData:[dic objectAtIndex:i]]];
    }
    [tblActOrg reloadData];
}

-(void)errOrgData{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络连接。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)initScrollView{
    NSUserDefaults *local=[NSUserDefaults standardUserDefaults];
    user=[local objectForKey:@"Email"];
    orgData=[[NSMutableData alloc]init];
    orgDataList=[[NSMutableArray alloc]init];
    NSString *url=[Common getUrlString:@"/search.php"];
    HTTPPost *post=[[HTTPPost alloc]initWithArgs:url postData:[user dataUsingEncoding:NSUTF8StringEncoding] resultData:orgData sender:self onSuccess:@selector(gotOrgData) onError:@selector(errOrgData)];
    [post Run];
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height, 0, 0);
    dateActTime=[[UIDatePicker alloc]initWithFrame:pos];
    dateActDur=[[UIDatePicker alloc]initWithFrame:pos];
    [self.view addSubview:dateActTime];
    dateActDur.datePickerMode=UIDatePickerModeCountDownTimer;
    [self.view addSubview:dateActDur];
    [dateActTime addTarget:self action:@selector(dateActTimeChanged) forControlEvents:UIControlEventValueChanged];
    [dateActDur addTarget:self action:@selector(dateActDurChanged) forControlEvents:UIControlEventValueChanged];
    self.txtActTime.delegate=self;
    self.txtActDur.delegate=self;
    self.txtActTitle.delegate=self;
    self.txtActCap.delegate=self;
    self.txtActContent.delegate=self;
    self.txtActOrg.delegate=self;
    self.txtActPlace.delegate=self;
    [self dateActTimeChanged];
    [self dateActDurChanged];
    [self tapBackground];
    self.txtActOrg.text=@"个人";
    self.txtActOrg.delegate=self;
    tblActOrg=[[UITableView alloc]initWithFrame:CGRectMake(self.txtActOrg.frame.origin.x, self.txtActOrg.frame.origin.y+32, 200, 0) style:UITableViewStylePlain];
    tblActOrg.layer.borderWidth=1;
    tblActOrg.layer.borderColor=[[UIColor blackColor]CGColor];
    tblActOrg.delegate=self;
    tblActOrg.dataSource=self;
    [self addSubview:tblActOrg];
    self.contentInset=UIEdgeInsetsMake(0, 0, 1300, 0);
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
    [self.txtActTitle resignFirstResponder];
    [self.txtActOrg resignFirstResponder];
    [self.txtActContent resignFirstResponder];
    [self.txtActCap resignFirstResponder];
    [self.txtActPlace resignFirstResponder];
    [self hideActTime];
    [self hideActDur];
    [self hideTblActOrg];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"ib begin");
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 225.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.btnCommit setEnabled:[self canCommit]];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hideActTime];
    [self hideActDur];
    [self hideTblActOrg];
    if (textField == self.txtActTime){
        [self showActTime];
        return NO;
    }
    if (textField == self.txtActDur){
        [self showActDur];
        return NO;
    }
    if (textField == self.txtActOrg){
        [self showTblActOrg];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self hideActTime];
    [self hideActDur];
    [self hideTblActOrg];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"ib begin");
    CGRect frame = textView.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 225.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.btnCommit setEnabled:[self canCommit]];
}

@end