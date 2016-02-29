//
//  DownloadImageOperation.h
//  图片缓存
//
//  Created by 风起兮 on 16/1/13.
//  Copyright © 2016年 风起兮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownloadImageOperation : NSOperation


@property(nonatomic,readonly) NSURL *url;

@property(nonatomic,readonly) void (^block)(UIImage *image,NSURL *url);

- (instancetype)initWithUrl:(NSURL *)url block:(void (^) (UIImage *image,NSURL *url)) block;




@end
