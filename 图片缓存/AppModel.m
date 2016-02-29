//
//  AppModel.m
//  图片缓存
//
//  Created by 风起兮 on 16/1/12.
//  Copyright © 2016年 风起兮. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

+ (instancetype)appWithDict:(NSDictionary *)dict{
    AppModel *app = [self new];
    [app setValuesForKeysWithDictionary:dict];
    return app;
}

@end
