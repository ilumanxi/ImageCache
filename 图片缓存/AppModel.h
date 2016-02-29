//
//  AppModel.h
//  图片缓存
//
//  Created by 风起兮 on 16/1/12.
//  Copyright © 2016年 风起兮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject


@property(nonatomic,copy) NSString *name;

@property(nonatomic,copy) NSString *icon;

@property(nonatomic,copy) NSString *download;

+ (instancetype)appWithDict:(NSDictionary *)dict;
@end
