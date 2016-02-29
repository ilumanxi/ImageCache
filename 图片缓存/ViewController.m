//
//  ViewController.m
//  图片缓存
//
//  Created by 风起兮 on 16/1/12.
//  Copyright © 2016年 风起兮. All rights reserved.
//

#import "ViewController.h"
#import "AppModel.h"
#import "DownloadImageOperation.h"
#import "DataSource.h"

@interface ViewController ()

/**
 *  数据模型
 */
@property(nonatomic,strong) NSArray<AppModel *> *apps;

@property(nonatomic,strong) DataSource *dataSource;


/**
 *  内存图片缓存
 */
@property(nonatomic,strong) NSMutableDictionary<NSString *, UIImage *> *cacheImages;


/**
 *  图片下载任务
 */
@property(nonatomic,strong) NSMutableDictionary<NSString *, NSOperation *>*cacheOperations;

/**
 *  图片下载任务执行队列
 */
@property(nonatomic,strong) NSOperationQueue *operationQueue;

@end

@implementation ViewController

- (NSArray *)apps{
    
    if (_apps)  return _apps;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"apps" withExtension:@"plist"];
    
    NSArray *arr = [NSArray arrayWithContentsOfURL:url];
    NSMutableArray<AppModel *> *appArray = @[].mutableCopy;
    for (NSDictionary *dict in arr) {
        [appArray addObject:[AppModel appWithDict:dict]];
    }
    return _apps = appArray.copy;
    
}


- (DataSource *)dataSource
{
    if (_dataSource) return _dataSource;
    _dataSource = [DataSource new];
    _dataSource.apps = self.apps;
    __weak typeof(self) weakSelf = self;
    _dataSource.configCell = ^(UITableViewCell *cell,NSIndexPath *indexPath){
        AppModel *app = weakSelf.apps[indexPath.row];
        cell.textLabel.text = app.name;
        cell.detailTextLabel.text = app.download;
        if ([weakSelf loadCacheImage:app.icon]) {//加载本地缓存
            cell.imageView.image = [weakSelf loadCacheImage:app.icon];
        }else if (weakSelf.cacheImages[app.icon]) {//加载内存缓存图片
            cell.imageView.image = weakSelf.cacheImages[app.icon];
        }else if (!weakSelf.cacheOperations[app.icon]){//下载图片
            cell.imageView.image = [UIImage imageNamed:@"Snip20160111_304"];
            DownloadImageOperation *downloadImageOperation =[[DownloadImageOperation alloc] initWithUrl:[NSURL URLWithString:app.icon] block:^(UIImage *image, NSURL *url) {
                [weakSelf downloadImageFinsh:image url:url.relativePath indexPath:indexPath];
            }];
            weakSelf.cacheOperations[app.icon] = downloadImageOperation;//存储下载任务,防止重复下载
            [weakSelf.operationQueue addOperation:downloadImageOperation];//执行下载任务
        }else{
            cell.imageView.image = [UIImage imageNamed:@"Snip20160111_304"];
        }
    };
    return _dataSource;
}


- (NSMutableDictionary *)cacheImages{
    if (_cacheImages) return _cacheImages;
    return _cacheImages = @{}.mutableCopy;
    
}


- (NSMutableDictionary<NSString *,NSOperation *> *)cacheOperations{
    if (_cacheOperations) return _cacheOperations;
    return _cacheOperations = @{}.mutableCopy;
}

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue)  return _operationQueue;
    return  _operationQueue = [NSOperationQueue new];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource.tableView = self.tableView;
    self.tableView.dataSource = self.dataSource;
}



/**
 *  加载缓存图片
 *
 *  @param imageName 图片名
 *
 *  @return 图片
 */
- (UIImage *)loadCacheImage:(NSString *)imageName{
    return [UIImage imageWithContentsOfFile:[self bulidImageCachePath:imageName]];
}

/**
 *  缓存图片
 *
 *  @param image     图片
 *  @param imageName 图片名
 */
- (void)cacheImage:(UIImage *)image imageName:(NSString *)imageName{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    [data writeToFile:[self bulidImageCachePath:imageName] atomically:YES];
}


/**
 *  构建图片缓存路径
 *
 *  @param imageName 图片名
 *
 *  @return 缓存路径
 */
- (NSString *)bulidImageCachePath:(NSString *)imageName{
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //获得文件名称
    NSString *fileName = [imageName lastPathComponent];
    //拼接文件的全路径
    return [caches stringByAppendingPathComponent:fileName];
}

/**
 *  图片下载完成
 *
 *  @param image     图片
 *  @param url       下载路径
 */
- (void)downloadImageFinsh:(UIImage *)image url:(NSString *)url indexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%s \n %@",__FUNCTION__,[NSThread currentThread]);
    
    // 子线程
    if (image)
    {
        self.cacheImages[url] = image;
        [self cacheImage:image imageName:url];
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshCellWithImage:image indexPath:indexPath];
        });
    }
    [self.cacheOperations removeObjectForKey:url];
}

/**
 *  刷新cell
 *
 *  @param image     图片
 */
- (void)refreshCellWithImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = image;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}


@end
