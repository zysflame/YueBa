//
//  HomeVC.m
//  Yueba
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "HomeVC.h"
#import <SWRevealViewController.h>
#import "SearchVC.h"
#import "AppDelegate.h"
#import "QYLocationManager.h"
#import "QYHTTPManager.h"
#import "UserInfo.h"
#import "People.h"
#import "Friend.h"

@interface HomeVC ()

@property (nonatomic, strong)NSMutableArray *nearUser;//找到的周围用户
@property (nonatomic, weak)People *nowPeople;//显示的视图

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutReveal];
    //视图边不延伸
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.nearUser) {
        //展示搜索界面
        SearchVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"searchvc"];

        [self.revealViewController presentViewController:vc animated:YES completion:nil];
        
        //雷达的回调
        __weak HomeVC *home = self;
        [[QYLocationManager shareLocationManager] setRadarNear:^(NSArray *result){
            home.nearUser = [NSMutableArray arrayWithArray:result];
            //更新内容;
            [home uploadInfo];
            //取消展示界面
            [home.revealViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
}

//更新内容
-(void)uploadInfo{
    //获取所有用户的id
    NSArray *userids = [self.nearUser valueForKeyPath:@"userID"];
    
    //筛选只包含没有做出选择的
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *userId in userids) {
        //如果不存在,则查询结果
        if (![Friend inContentUserID:userId]) {
            [result addObject:userId];
        }
    }
    
    //根据Uid 获取用户属性
    [[QYHTTPManager httpManager] getUserInfosWith:result Completion:^(NSURLSessionTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        NSLog(@"%@", responseObject);
        
        
        if ([responseObject[@"success"] boolValue]) {
            NSArray *userArray = responseObject[@"data"];
            NSMutableArray *userModels = [NSMutableArray array];
            //将返回的结果转化为model
            for (NSDictionary *dict in userArray) {
                UserInfo *info = [[UserInfo alloc] initWithDict:dict];
                for (UserInfo *user in self.nearUser) {
                    if ([info.userID isEqualToString:user.userID]) {
                        info.distanse = user.distanse;
                    }
                }
                [userModels addObject:info];
            }
            //更新为包含详细用户信息的
            self.nearUser = userModels;
            //更新显示
            [self loadSubView];
            
        }
        
    }];
    
}

//更新视图
//根据获取的数据添加视图
-(void)loadSubView{
    
    if (self.nearUser.count == 0) {
        [self.nowPeople removeFromSuperview];
        NSLog(@"周围没有好友了");
        return;
    }
    
    People *people = [[[NSBundle mainBundle] loadNibNamed:@"People" owner:nil options:nil] firstObject];
    [people bandingUser:self.nearUser[0]];
    
    people.frame = CGRectMake(5, 5, CGRectGetWidth(self.view.frame) - 10, CGRectGetHeight(self.view.frame) - 100);
    //添加边框和圆角
    people.layer.borderWidth = 1.f;
    people.layer.borderColor = [UIColor lightGrayColor].CGColor;
    people.layer.cornerRadius = 5.f;
    people.layer.masksToBounds = YES;
    
    
    if (self.nowPeople) {
        [self.view insertSubview:people belowSubview:self.nowPeople];
        //添加一个消失动画
        [UIView animateWithDuration:0.25 animations:^{
            self.nowPeople.frame = CGRectOffset(self.nowPeople.frame, CGRectGetWidth(self.view.frame), 0);
        } completion:^(BOOL finished) {
            [self.nowPeople removeFromSuperview];
            self.nowPeople = people;
        }];
        
    }else{
        [self.view addSubview:people];
        self.nowPeople = people;
    }
    
    
}

//配置侧滑
-(void)layoutReveal{
    //支持侧滑手势和点击手势,先找到侧滑控制器
    SWRevealViewController *revealVC = [self revealViewController];
    [revealVC panGestureRecognizer];
    [revealVC tapGestureRecognizer];
    
    //添加时间
    self.navigationItem.leftBarButtonItem.target = revealVC;
    self.navigationItem.leftBarButtonItem.action = @selector(revealToggle:);
    
    //右边按钮
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc
                               ] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:revealVC action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    revealVC.rearViewRevealWidth = 300.f;
    revealVC.rightViewRevealWidth = 300.f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)like:(id)sender {
    if (self.nearUser.count == 0) {
        return;
    }
    NSString *friendId = [self.nearUser[0] userID];
    [[QYHTTPManager httpManager] addUser:friendId Like:YES Completion:^(NSURLSessionTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[@"success"] boolValue]) {
            
            if ([responseObject[@"data"][@"friend"] boolValue]) {
                NSLog(@"匹配好友成功");
            }
            
            //将结果保存到数据库
            
            AppDelegate *app = [[UIApplication sharedApplication] delegate];
            Friend *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:app.managedObjectContext];
            UserInfo *info = self.nearUser[0];
            NSDictionary *result = responseObject[@"data"];
            friend.name = info.name;
            friend.gender = info.gender;
            friend.uid = info.userID;
            friend.like = result[@"like"];
            friend.isFriend = result[@"friend"];
            
            //保存修改
            [app saveContext];
        
        }
        
        
        
        [self.nearUser removeObjectAtIndex:0];
        [self loadSubView];
        
    }];
}

- (IBAction)unlike:(id)sender {
    if (self.nearUser.count == 0) {
        return;
    }
    NSString *friendId = [self.nearUser[0] userID];
    [[QYHTTPManager httpManager] addUser:friendId Like:NO Completion:^(NSURLSessionTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
            
        }
        NSLog(@"%@", responseObject);
        
        
        //将结果保存到数据库
        
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        Friend *friend = [NSEntityDescription insertNewObjectForEntityForName:@"friend" inManagedObjectContext:app.managedObjectContext];
        UserInfo *info = self.nearUser[0];
        NSDictionary *result = responseObject[@"data"];
        friend.name = info.name;
        friend.gender = info.gender;
        friend.uid = info.userID;
        friend.like = result[@"like"];
        friend.isFriend = result[@"friend"];
        
        //保存修改
        [app saveContext];
        
        //删除选择过的用户进行下一位
        [self.nearUser removeObjectAtIndex:0];
        [self loadSubView];

        
    }];
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
