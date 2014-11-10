//
//  SendCommentViewController.m
//  LetsGo
//
//  Created by 周瑞琦 on 11/7/14.
//评论方式post,data里存评论内容，通过url指示提交的是哪个活动的评论
//

#import "SendCommentViewController.h"

@interface SendCommentViewController ()

@end

@implementation SendCommentViewController

- (void)viewDidLoad {
    self.CommentContentTxt.returnKeyType=UIReturnKeyDefault;
    self.SendButton.title=@"发送";
    self.CancelButton.title=@"取消";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CancelButton:(id)sender {
    //取消评论
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SendCommentButton:(id)sender {//CommentContentTxt 数据可能不对应，一会有网要改
    HTTPPost *SendCommentPost=[[HTTPPost alloc]initWithArgs:SendCommentURL postData:[self.CommentContentTxt.text dataUsingEncoding:NSUTF8StringEncoding] resultData:ResultData sender:self onSuccess:@selector(ReceiveSuccess) onError:nil];
    [SendCommentPost Run];
}

-(void)ReceiveSuccess{
    NSLog(@"Recevie Data");
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(void)keyboardDidShow:(NSNotification *)notif{
    NSLog(@"DidShow");
    if(keyboardVisible){
        return;
    }
    NSDictionary *info=[notif userInfo];
    NSValue* aValue=[info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardsize=[aValue CGRectValue].size;
    
    CGRect viewFrame=self.Scroll.frame;
    viewFrame.size.height-=(keyboardsize.height);
    self.Scroll.frame=viewFrame;
    CGRect textFieldRect=[self.CommentContentTxt frame];
    [self.CommentContentTxt scrollRectToVisible:textFieldRect animated:YES];
    
    keyboardVisible=YES;
}

-(void) keyboardDidHide:(NSNotification*)notif{
    NSLog(@"DidHide");
    NSDictionary* info=[notif userInfo];
    NSValue *aValue=[info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardsize=[aValue CGRectValue].size;
    
    CGRect viewFrame=self.Scroll.frame;
    viewFrame.size.height+=(keyboardsize.height);
    self.Scroll.frame=viewFrame;
    CGRect textFieldRect=[self.CommentContentTxt frame];
    [self.CommentContentTxt scrollRectToVisible:textFieldRect animated:YES];
    
    if(!keyboardVisible)
    {
        return;
    }
    keyboardVisible=NO;
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
