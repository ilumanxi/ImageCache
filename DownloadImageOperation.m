//
//  DownloadImageOperation.m
//  图片缓存
//
//  Created by 风起兮 on 16/1/13.
//  Copyright © 2016年 风起兮. All rights reserved.
//

#import "DownloadImageOperation.h"

@implementation DownloadImageOperation

- (instancetype)initWithUrl:(NSURL *)url block:(void (^)(UIImage *, NSURL *))block{
    
    if (self = [super init]) {
        _url = url;
        _block = block;
    }
    return self;
}


// 自动调用
- (void)main{
    
    @autoreleasepool {//防止内存泄露,因为自己开启线程访问不到主线程创建的@autoreleasepool
        if (self.cancelled) return;
        NSData *data = [NSData dataWithContentsOfURL:_url];
        UIImage *image = [UIImage imageWithData:data];
        if (self.cancelled) return;
        if (self.block) self.block(image,_url);
    }
}

@end
