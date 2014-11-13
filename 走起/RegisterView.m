//
//  RegisterView.m
//  走起
//
//  Created by Nicholas on 14-11-1.
//  Copyright (c) 2014年 Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterView.h"
#import "Common.h"

@interface RegisterView()<CLLocationManagerDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
    

@end

@implementation RegisterView

@synthesize txtPaswd;
@synthesize txtEmail;
@synthesize txtSid;
@synthesize txtSpwd;
@synthesize txtSchool;
@synthesize registerData;
@synthesize locData;
@synthesize locMgr;
@synthesize schoolSearchView;
@synthesize dataList;
@synthesize searchData;

NSMutableData *iconUrlData;
NSString *iconUrl;


-(BOOL)canCommit{
    if ([self.txtEmail.text isEqualToString:@""])
        return NO;
    if ([self.txtPaswd.text isEqualToString:@""])
        return NO;
    if ([self.txtPaswdConfirm.text isEqualToString:@""])
        return NO;
    if ([self.txtSid.text isEqualToString:@""])
        return NO;
    if ([self.txtSpwd.text isEqualToString:@""])
        return NO;
    if ([self.txtSchool.text isEqualToString:@""]) {
        return NO;
    }
    if (iconUrlData == nil)
        return NO;
    else
    {
        iconUrl=[[NSString alloc]initWithData:iconUrlData encoding:NSUTF8StringEncoding];
        if ([iconUrl isEqualToString:@""])
            return NO;
    }
    return YES;
}

-(void)uploadDone{
    [self.btnReg setEnabled:[self canCommit]];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    image=[Common resizePic:image resizeTo:CGSizeMake(150, 150)];
    self.imgIcon.image=image;
    iconUrlData=[[NSMutableData alloc]init];
    [Common uploadPic:image picUrl:iconUrlData sender:self onDone:@selector(uploadDone)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapOncePic{
    self.picker=[[UIImagePickerController alloc]init];
    //self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    self.picker.mediaTypes=[NSArray arrayWithObjects:@"public.image", nil];
    self.picker.allowsEditing=YES;
    
    self.picker.delegate=self;
    [self presentViewController:self.picker animated:YES completion:nil];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"did end");
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.btnReg setEnabled:[self canCommit]];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"did begin");
    CGRect frame = searchBar.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 320.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [txtSchool resignFirstResponder];
    NSLog(@"search clicked");
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"changed");
    if (txtSchool.text.length == 0) {
        [self setSearchControllerHidden:YES]; //控制下拉列表的隐现
    }else{
        [self searchSchool:searchText];
        [self setSearchControllerHidden:NO];
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

-(void)searchSchool:(NSString *)name{
    self.searchData = [[NSMutableData alloc]init];
    NSString *url=[Common getUrlString:@"/schools/search"];
    //NSString *url=@"http://localhost/school.txt";
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:name forKey:@"school_name"];
    NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    HTTPPost *post = [[HTTPPost alloc]initWithArgs:url postData:json resultData:self.searchData sender:self onSuccess:@selector(searchDone) onError:@selector(networkErr)];
    [post Run];
}

-(void)searchDone{
    NSArray *keys = [NSJSONSerialization JSONObjectWithData:self.searchData options:NSJSONReadingMutableLeaves error:nil];
    NSInteger count = keys.count;
    [self.dataList removeAllObjects];
    for (int i=0; i<count; i++){
        [self.dataList addObject:[[clsSchool alloc]initWithData:[keys objectAtIndex:i]]];
    }
    [schoolSearchView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    clsSchool *sch=[self.dataList objectAtIndex:row];
    cell.textLabel.text = sch.name;
    //cell.detailTextLabel.text = @"详细信息";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    txtSchool.text = cell.textLabel.text;
    [cell setSelected:NO animated:YES];
    [self setSearchControllerHidden:YES];
}

-(void)initLoc{
    self.locMgr = [[CLLocationManager alloc]init];
    self.locMgr.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locMgr requestAlwaysAuthorization];
    if ([CLLocationManager locationServicesEnabled]){
        self.locMgr.distanceFilter = kCLDistanceFilterNone;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locMgr startUpdatingLocation];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启定位后可自动选择您所在的学校" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if ([txtSchool.text isEqual:@""]){
        CLLocation *loc = [locations lastObject];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[NSNumber numberWithDouble:loc.coordinate.latitude] forKey:@"school_lat"];
        [dic setValue:[NSNumber numberWithDouble:loc.coordinate.longitude] forKey:@"school_lon"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        self.locData = [NSMutableData alloc];
        NSLog(@"%f,%f",loc.coordinate.latitude,loc.coordinate.longitude);
        NSString *url=[Common getUrlString:@"/schools/search"];
        HTTPPost *pLoc = [[HTTPPost alloc]initWithArgs:url postData:data resultData:self.locData sender:self onSuccess:@selector(gotSchool) onError:@selector(networkErr)];
        [pLoc Run];
        [self.locMgr stopUpdatingLocation];
    }
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    NSLog(@"location paused");
}

-(void)gotSchool{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.locData options:NSJSONReadingMutableLeaves error:nil];
    txtSchool.text = [dic objectForKey:@"school_name"];
    if (txtSchool.text.length>0) {
        [self.dataList addObject:[[clsSchool alloc]initWithData:dic]];
    }
}

-(void)networkErr{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络连接。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
//reg:/users.json
-(IBAction)Register:(id)sender{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:txtPaswd.text forKey:@"password"];
    [dic setValue:self.txtPaswdConfirm.text forKey:@"password_confirmation"];
    [dic setValue:txtEmail.text forKey:@"email"];
    [dic setValue:txtSid.text forKey:@"student_id"];
    [dic setValue:txtSpwd.text forKey:@"student_pwd"];
    [dic setValue:iconUrl forKey:@"user_logo"];
    clsSchool *sch;
    int i;
    for (i=0; i<self.dataList.count; i++) {
        sch=[self.dataList objectAtIndex:i];
        if ([sch.name isEqualToString:txtSchool.text]) {
            [dic setValue:[NSNumber numberWithInteger:sch.schoolID] forKey:@"school_id"];
            break;
        }
    }
    if (i==self.dataList.count) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请选择学校" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //[dic setValue:iconUrl forKey:@"user_logo"];
    self.registerData = [NSMutableData alloc];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    NSString *url=[Common getUrlString:@"/users.json"];
    HTTPPost *pRegister = [[HTTPPost alloc]initWithArgs:url postData:data resultData:self.registerData sender:self onSuccess:@selector(registerFinished) onError:@selector(registerError)];
    [pRegister Run];
}

-(void)registerFinished{
    NSString *recvStr = [[NSString alloc]initWithData:self.registerData encoding:NSUTF8StringEncoding];
    NSLog(@"success!%@", recvStr);
    //传输成功
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.registerData options:NSJSONReadingMutableLeaves error:nil];
    int status = [[json objectForKey:@"status"]intValue];
    switch (status) {
        case _REG_SUCCESS_:{
            NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
            [localData setObject:[json objectForKey:@"user_token"] forKey:@"user_token"];
            [localData setInteger:[[json objectForKey:@"user_id"]integerValue] forKey:@"user_id"];
            [localData setObject:self.txtEmail.text forKey:@"email"];
            [localData synchronize];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功！" delegate:self cancelButtonTitle:@"继续" otherButtonTitles: nil];
            [alert show];
            [self performSegueWithIdentifier:@"registed" sender:self];
            [self.navigationController popToRootViewControllerAnimated:NO];
            break;
        }
            
        case _REG_EMAIL_EXIST_:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"该E-Mail地址已被使用" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
            txtEmail.text = @"";
            [txtEmail becomeFirstResponder];
            break;
        }
            
        case _REG_PERSON_EXIST_:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请不要重复认证个人信息" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
            txtSid.text = @"";
            txtSpwd.text = @"";
            [txtSid becomeFirstResponder];
            break;
        }
            
        case _REG_PASWD_SHORT_:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"密码过短，请设置至少8位密码。" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
            txtPaswd.text = @"";
            [txtPaswd becomeFirstResponder];
            break;
        }
            
        default:
            break;
    }
}

-(void)registerError{
    //网络错误
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: nil message:@"网络错误，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
    [self.txtPaswd resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtSid resignFirstResponder];
    [self.txtSpwd resignFirstResponder];
    [self.txtSchool resignFirstResponder];
    [self setSearchControllerHidden:YES];
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(schoolSearchView.frame, point))
        return NO;
    if (CGRectContainsPoint(self.imgIcon.frame, point)) {
        [self tapOncePic];
        return YES;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"ib begin");
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 320.0);//键盘高度216
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
    [self.btnReg setEnabled:[self canCommit]];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tapOnce];
    return YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self tapBackground];
    txtSchool.delegate = self;
    txtEmail.delegate=self;
    txtPaswd.delegate=self;
    txtSid.delegate=self;
    txtSpwd.delegate=self;
    self.txtPaswdConfirm.delegate=self;
    CGPoint point=self.txtSchool.frame.origin;
    CGRect frame=CGRectMake(point.x, point.y-182, 200, 180);
    self.schoolSearchView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.schoolSearchView.layer.borderWidth=1;
    self.schoolSearchView.layer.borderColor=[[UIColor blackColor]CGColor];
    [self.view addSubview:self.schoolSearchView];
    [self setSearchControllerHidden:YES];
    self.dataList = [[NSMutableArray alloc]init];
    self.schoolSearchView.dataSource = self;
    self.schoolSearchView.delegate = self;
    [self.btnReg.layer setMasksToBounds:YES];
    [self.btnReg.layer setCornerRadius:5];
    [self.btnReg setEnabled:[self canCommit]];
    [self.imgIcon.layer setMasksToBounds:YES];
    [self.imgIcon.layer setCornerRadius:10];
    [self initLoc];
    //schoolSearchView = [[schoolSearchViewController alloc]initWithStyle:UITableViewStylePlain];
    //[schoolSearchView.view setFrame:CGRectMake(30, 40, 200, 0)];
    //[self.view addSubview:schoolSearchView.view];
}

- (void) setSearchControllerHidden:(BOOL)hidden {
    CGFloat alpha = hidden? 0: 100;
    [UIView beginAnimations:nil context:nil];
    if (hidden)
        [UIView setAnimationDuration:0];
    else
        [UIView setAnimationDuration:0.5];
    [self.schoolSearchView setAlpha:alpha];
    [UIView commitAnimations];
}

@end
