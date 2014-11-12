//
//  CreateActivityViewController.m
//  LetsGo
//
//  Created by Nicholas on 14/11/4.
//
//

#import <Foundation/Foundation.h>
#import "CreateActivityViewController.h"

@interface CreateActivityViewController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation CreateActivityViewController

BOOL shouldTouch;

-(void)clickLocate{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"actLocate"] animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row=[indexPath row];
    NSString *reuse=[[NSString alloc]initWithFormat:@"%ld",row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 21)];
        label.textAlignment=NSTextAlignmentCenter;
        CGSize size=self.view.frame.size;
        switch (row) {
            case 0:{
                label.text=@"活动名称";
                [cell addSubview:label];
                self.txtActTitle=[[UITextField alloc]initWithFrame:CGRectMake(90, 5, size.width-100, 30)];
                self.txtActTitle.borderStyle=UITextBorderStyleRoundedRect;
                self.txtActTitle.delegate=self;
                [cell addSubview:self.txtActTitle];
                return cell;
                break;
            }
            case 1://活动地点
                label.text=@"活动地点";
                [cell addSubview:label];
                self.txtActPlace=[[UITextField alloc]initWithFrame:CGRectMake(90, 5, size.width-200, 30)];
                self.txtActPlace.borderStyle=UITextBorderStyleRoundedRect;
                self.txtActPlace.delegate=self;
                [cell addSubview:self.txtActPlace];
                self.btnLocate=[[UIButton alloc]initWithFrame:CGRectMake(size.width-100, 5, 90, 30)];
                self.btnLocate.backgroundColor=[UIColor cyanColor];
                [self.btnLocate.layer setMasksToBounds:YES];
                [self.btnLocate.layer setCornerRadius:8.0];
                [self.btnLocate setTitle:@"选取位置" forState:UIControlStateNormal];
                [self.btnLocate setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                [self.btnLocate addTarget:self action:@selector(clickLocate) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:self.btnLocate];
                return cell;
                break;
            
            case 2://活动开始时间
                label.text=@"开始时间";
                [cell addSubview:label];
                self.txtActTime=[[UITextField alloc]initWithFrame:CGRectMake(90, 5, size.width-100, 30)];
                self.txtActTime.borderStyle=UITextBorderStyleRoundedRect;
                self.txtActTime.delegate=self;
                [cell addSubview:self.txtActTime];
                [self dateActTimeChanged];
                return cell;
                break;
            
            case 3://活动结束时间
                label.text=@"结束时间";
                [cell addSubview:label];
                self.txtActEnd=[[UITextField alloc]initWithFrame:CGRectMake(90, 5, size.width-100, 30)];
                self.txtActEnd.borderStyle=UITextBorderStyleRoundedRect;
                self.txtActEnd.delegate=self;
                [cell addSubview:self.txtActEnd];
                [self dateActEndChanged];
                return cell;
                break;
                
            case 4://最大人数
                label.text=@"最大人数";
                [cell addSubview:label];
                self.txtActCap=[[UITextField alloc]initWithFrame:CGRectMake(90, 5, 80, 30)];
                self.txtActCap.borderStyle=UITextBorderStyleRoundedRect;
                self.txtActCap.delegate=self;
                [cell addSubview:self.txtActCap];
                return cell;
                break;
            
            case 5://群组
                label.text=@"活动群组";
                [cell addSubview:label];
                self.txtActOrg=[[UITextField alloc]initWithFrame:CGRectMake(90, 5, size.width-100, 30)];
                self.txtActOrg.borderStyle=UITextBorderStyleRoundedRect;
                self.txtActOrg.delegate=self;
                [cell addSubview:self.txtActOrg];
                return cell;
                break;
            
            case 6://活动介绍
                label.text=@"活动介绍";
                [cell addSubview:label];
                self.txtActContent=[[UITextView alloc]initWithFrame:CGRectMake(90, 5, size.width-100, 200)];
                [self.txtActContent.layer setMasksToBounds:YES];
                [self.txtActContent.layer setBorderWidth:1];
                [self.txtActContent.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
                [self.txtActContent.layer setCornerRadius:5];
                self.txtActContent.delegate=self;
                [cell addSubview:self.txtActContent];
                return cell;
                break;
            
            case 7://logo
                self.imgActLogo=[[UIImageView alloc]initWithFrame:CGRectMake(size.width/2-160, 5, 150, 150)];
                self.imgActLogo.backgroundColor=[UIColor lightGrayColor];
                [self.imgActLogo.layer setMasksToBounds:YES];
                [self.imgActLogo.layer setCornerRadius:10];
                [cell addSubview:self.imgActLogo];
                self.btnLogo=[[UIButton alloc]initWithFrame:CGRectMake(size.width/2+10, 65, 90, 30)];
                [self.btnLogo setTitle:@"选取小图" forState:UIControlStateNormal];
                [self.btnLogo setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                self.btnLogo.backgroundColor=[UIColor cyanColor];
                [self.btnLogo.layer setMasksToBounds:YES];
                [self.btnLogo.layer setCornerRadius:8];
                [self.btnLogo addTarget:self action:@selector(getLogo) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:self.btnLogo];
                return cell;
                break;
            
            case 8://pic
            {
                CGFloat width=size.width-20;
                self.imgActPic=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, width, width*0.5)];
                self.imgActPic.backgroundColor=[UIColor lightGrayColor];
                [self.imgActPic.layer setMasksToBounds:YES];
                [self.imgActPic.layer setCornerRadius:10];
                [cell addSubview:self.imgActPic];
                self.btnPic=[[UIButton alloc]initWithFrame:CGRectMake(size.width/2-45, width*0.5+15, 90, 30)];
                [self.btnPic.layer setMasksToBounds:YES];
                [self.btnPic.layer setCornerRadius:8];
                [self.btnPic setTitle:@"选取大图" forState:UIControlStateNormal];
                [self.btnPic setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                self.btnPic.backgroundColor=[UIColor cyanColor];
                [self.btnPic addTarget:self action:@selector(getPic) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:self.btnPic];
                return cell;
            }
            default:
                return cell;
                break;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row=[indexPath row];
    CGSize size=self.view.frame.size;
    switch (row) {
        case 0://活动标题
            return 40;
            break;
            
        case 1://活动地点
            return 40;
            break;
            
        case 2://活动开始时间
            return 40;
            break;
            
        case 3://活动结束时间
            return 40;
            break;
            
        case 4://最大人数
            return 40;
            break;
            
        case 5://群组
            return 40;
            break;
            
        case 6://活动介绍
            return 210;
            break;
            
        case 7://logo
            return 160;
            break;
            
        case 8://pic
            return (size.width-20)*0.5+50;
            break;
            
        default:
            return 40;
            break;
    }
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
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
    if (self.lat==nil) {
        return NO;
    }
    if (self.lon==nil) {
        return NO;
    }
    if (self.logoUrlData == nil)
        return NO;
    else
    {
        self.logoUrl=[[NSString alloc]initWithData:self.logoUrlData encoding:NSUTF8StringEncoding];
        if ([self.logoUrl isEqualToString:@""])
            return NO;
    }
    if (self.picUrlData == nil)
        return NO;
    else{
        self.picUrl=[[NSString alloc]initWithData:self.picUrlData encoding:NSUTF8StringEncoding];
        if ([self.picUrl isEqualToString:@""])
            return NO;
    }
    return YES;
}

-(void)uploadDone{
    [self.btnCommit setEnabled:[self canCommit]];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (picker == self.logoPicker){
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        self.imgActLogo.image=image;
        self.logoUrlData=[[NSMutableData alloc]init];
        [Common uploadPic:image picUrl:self.logoUrlData sender:self onDone:@selector(uploadDone)];
    }
    if (picker == self.picPicker){
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.imgActPic.image=image;
        self.picUrlData=[[NSMutableData alloc]init];
        [Common uploadPic:image picUrl:self.picUrlData sender:self onDone:@selector(uploadDone)];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)getLogo{
    self.logoPicker=[[UIImagePickerController alloc]init];
    self.logoPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    self.logoPicker.mediaTypes=[NSArray arrayWithObjects:@"public.image", nil];
    self.logoPicker.allowsEditing=YES;
    self.logoPicker.delegate=self;
    [self.navigationController presentViewController:self.logoPicker animated:YES completion:nil];
}

-(void)getPic{
    self.picPicker=[[UIImagePickerController alloc]init];
    self.picPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    self.picPicker.mediaTypes=[NSArray arrayWithObjects:@"public.image", nil];
    self.picPicker.delegate=self;
    [self.navigationController presentViewController:self.picPicker animated:YES completion:nil];
}


-(void)dateActEndChanged{
    self.txtActEnd.text=[Common stringFromDate:self.dateActEnd.date];
}

-(void)showActEnd{
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height-162.0f, 0, 0);
    [UIControl beginAnimations:nil context:nil];
    [UIControl setAnimationDuration:0.5];
    self.dateActEnd.frame=pos;
    [UIControl commitAnimations];
    shouldTouch=YES;
}

-(void)hideActEnd{
    [UIControl beginAnimations:nil context:nil];
    [UIControl setAnimationDuration:0.5];
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height, 0, 0);
    self.dateActEnd.frame=pos;
    [UIControl commitAnimations];
}

-(void)dateActTimeChanged{
    self.txtActTime.text=[Common stringFromDate:self.dateActTime.date];
}

-(void)showActTime{
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height-162.0f, 0, 0);
    [UIControl beginAnimations:nil context:nil];
    [UIControl setAnimationDuration:0.5];
    self.dateActTime.frame=pos;
    [UIControl commitAnimations];
    shouldTouch=YES;
}

-(void)hideActTime{
    [UIControl beginAnimations:nil context:nil];
    [UIControl setAnimationDuration:0.5];
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height, 0, 0);
    self.dateActTime.frame=pos;
    [UIControl commitAnimations];
}

-(void)hideTblActOrg{
    CGSize size=self.view.frame.size;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height, size.width, size.height);
    self.tblActOrg.frame=pos;
    [UIView commitAnimations];
    shouldTouch=YES;
}

-(void)showTblActOrg{
    CGSize size=self.view.frame.size;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height-162.0f, size.width, size.height);
    self.tblActOrg.frame=pos;
    [UIView commitAnimations];
    shouldTouch=NO;
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
    //[self.btnCommit setEnabled:[self canCommit]];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hideTblActOrg];
    if (textField == self.txtActTime){
        [self tapOnce];
        [self showActTime];
        return NO;
    }
    if (textField == self.txtActEnd){
        [self tapOnce];
        [self showActEnd];
        return NO;
    }
    if (textField == self.txtActOrg){
        [self tapOnce];
        [self showTblActOrg];
        return NO;
    }
    if (textField==self.txtActPlace) {
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self hideActTime];
    [self hideActEnd];
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
    //[self.btnCommit setEnabled:[self canCommit]];
}

-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setDelegate:self];
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
    shouldTouch=YES;
}

-(void)tapOnce//手势方法
{
    [self.txtActTitle resignFirstResponder];
    [self.txtActOrg resignFirstResponder];
    [self.txtActContent resignFirstResponder];
    [self.txtActCap resignFirstResponder];
    [self.txtActPlace resignFirstResponder];
    [self hideActTime];
    [self hideActEnd];
    [self hideTblActOrg];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return shouldTouch;
}

-(void)viewDidLoad{
    self.tblMain.delegate=self;
    self.tblMain.dataSource=self;
    CGSize size=self.view.frame.size;
    CGRect pos = CGRectMake(0.0f, self.view.frame.size.height, size.width, size.height);
    self.dateActTime=[[UIDatePicker alloc]initWithFrame:pos];
    self.dateActEnd=[[UIDatePicker alloc]initWithFrame:pos];
    [self.dateActTime addTarget:self action:@selector(dateActTimeChanged) forControlEvents:UIControlEventValueChanged];
    [self.dateActEnd addTarget:self action:@selector(dateActEndChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.dateActTime];
    [self.view addSubview:self.dateActEnd];
    self.tblActOrg=[[UITableView alloc]initWithFrame:pos style:UITableViewStylePlain];
    self.tblActOrg.layer.borderWidth=1;
    self.tblActOrg.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.tblActOrgDele=[[tblActOrgDelegate alloc]initWithTableView:self.tblActOrg sender:self onClick:@selector(tblActOrgClicked)];
    self.tblActOrg.delegate=self.tblActOrgDele;
    self.tblActOrg.dataSource=self.tblActOrgDele;
    [self.view addSubview:self.tblActOrg];
}

-(void)tblActOrgClicked{
    self.txtActOrg.text=self.tblActOrgDele.selectOrg.name;
    [self tapOnce];
    shouldTouch=YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self tapBackground];
}

@end

@implementation tblActOrgDelegate

-(id)initWithTableView:(UITableView *)tbl sender:(id)sender onClick:(SEL)onClick{
    self.sender=sender;
    self.tblActOrg=tbl;
    self.onClicked=onClick;
    self.orgData=[[NSMutableData alloc]init];
    self.orgDataList=[[NSMutableArray alloc]init];
    //NSString *url=[Common getUrlString:@"/search.php"];
    NSString *url=@"http://localhost/organization_list.txt";
    [[GetInfo alloc]initWithURL:url ResultData:self.orgData sender:self OnSuccess:@selector(gotOrgData) OnError:@selector(errOrgData)];
    return self;
}

-(void)gotOrgData{
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:self.orgData options:NSJSONReadingMutableLeaves error:nil];
    NSInteger count = dic.count;
    [self.orgDataList removeAllObjects];
    clsOrg *t=[[clsOrg alloc]init];
    t.orgID=0;
    t.name=@"个人";
    [self.orgDataList addObject:t];
    for (int i=0; i<count; i++){
        [self.orgDataList addObject:[[clsOrg alloc]initWithData:[dic objectAtIndex:i]]];
    }
    [self.tblActOrg reloadData];
}

-(void)errOrgData{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查网络连接。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orgDataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    clsOrg *org=[self.orgDataList objectAtIndex:row];
    cell.textLabel.text = org.name;
    //cell.detailTextLabel.text = @"详细信息";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row=[indexPath row];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    self.selectOrg=[self.orgDataList objectAtIndex:row];
    [self.sender performSelector:self.onClicked];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end

