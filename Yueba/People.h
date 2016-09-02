//
//  Pople.h
//  Yueba
//
//  Created by qingyun on 16/8/31.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface People : UIView
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *like;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

-(void)bandingUser:(UserInfo *)user;
@property (weak, nonatomic) IBOutlet UILabel *distanse;

@end
