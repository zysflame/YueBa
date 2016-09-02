//
//  UploadInfoVC.m
//  Yueba
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "UploadInfoVC.h"
#import "QYAccount.h"
#import "QYHTTPManager.h"
#import "AppDelegate.h"

@interface UploadInfoVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameFild;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderFild;
@property (weak, nonatomic) IBOutlet UITextField *briadeyFild;

@property (nonatomic, strong)UIDatePicker *datePicker;

@end

@implementation UploadInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    //当前时间为可选的最大时间
    self.datePicker.maximumDate = [NSDate date];
    //生日用datapicker做键盘
    self.briadeyFild.inputView = self.datePicker;
    //给datepicker添加事件
    [self.datePicker addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventValueChanged];
    
    
}

-(void)changeTime:(UIDatePicker *)picker{
    //将时间格式化为字符串,根据本地化的语言
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:picker.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    
    self.briadeyFild.text = dateStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)upload:(id)sender {
    //上传用户信息
    
    //构造参数字典
    NSDictionary *parmas = @{@"userId":[QYAccount shareAccount].user,
                             @"name":_nameFild.text ,
                             @"gender" :[@[@"F", @"M"] objectAtIndex:_genderFild.selectedSegmentIndex]};
    
    [[QYHTTPManager httpManager] uploadInfo:parmas Completion:^(NSURLSessionTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSLog(@"%@", responseObject);
        //判断上传是否成功
        
        //切换到首页
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate changeToHome];
    }];
}
@end
