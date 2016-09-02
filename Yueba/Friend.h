//
//  Friend.h
//  Yueba
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Friend : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

//userID是否在记录中存在
+(BOOL)inContentUserID:(NSString *)userID;

@end

NS_ASSUME_NONNULL_END

#import "Friend+CoreDataProperties.h"
