//
//  Friend.m
//  Yueba
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "Friend.h"
#import "AppDelegate.h"

@implementation Friend

// Insert code here to add functionality to your managed object subclass

+(BOOL)inContentUserID:(NSString *)userID{
    //userID
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    //设置以userid最为谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", userID];
    request.predicate = predicate;
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    //查询结果有几条
    NSInteger result = [app.managedObjectContext countForFetchRequest:request error:nil];
    //如果没有记录,则不存在
    return (result != 0);
}

@end
