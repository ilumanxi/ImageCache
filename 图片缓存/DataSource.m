//
//  DataSource.m
//  图片缓存
//
//  Created by 风起兮 on 16/1/31.
//  Copyright © 2016年 风起兮. All rights reserved.
//

#import "DataSource.h"
#import "DownloadImageOperation.h"

@implementation DataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellWithIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    self.configCell(cell,indexPath);
    return cell;
}

@end
