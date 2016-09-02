//
//  UserInfo.h
//  Yueba
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong)NSString *userID;
@property (nonatomic)float distanse;//距离
@property (nonatomic, strong)NSString *gender;
@property (nonatomic, strong)NSString *name;

//根据字典初始化模型
-(instancetype)initWithDict:(NSDictionary *)info;

@end
