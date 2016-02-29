//
//  DataSource.h
//  图片缓存
//
//  Created by 风起兮 on 16/1/31.
//  Copyright © 2016年 风起兮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppModel.h"


@interface DataSource : NSObject<UITableViewDataSource>
/**
 *  数据模型
 */
@property(nonatomic,strong) NSArray<AppModel *> *apps;


@property(nonatomic,weak) UITableView *tableView;

/**
 *  配置cell
 *
 */
@property(nonatomic,strong) void(^configCell)(UITableViewCell *cell,NSIndexPath *indexPath);


@end
