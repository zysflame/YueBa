//
//  Pople.m
//  Yueba
//
//  Created by qingyun on 16/8/31.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "People.h"

@implementation People

-(void)bandingUser:(UserInfo *)user{
    //绑定内容
    self.name.text = user.name;
    self.gender.text = [user.gender isEqualToString:@"F"] ? @"男" : @"女";
    self.distanse.text = [NSString stringWithFormat:@"%d m", (int)user.distanse];
}

@end
