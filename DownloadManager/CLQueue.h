//
//  CLQueue.h
//  CLDownloadManager
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

//  CLQueue是一个下载信息的Model类
//  主要包括 URL、Name
//  可选包括 Model、Folder、PATH
#import <Foundation/Foundation.h>

@interface CLQueue : NSObject

// 设置name会重新修改path的值
// 设置folder需先设置name，否则默认显示folder为name
@property (nonatomic, copy)NSString *url;    // 下载地址
@property (nonatomic, copy)NSString *name;   // 保存文件名称
@property (nonatomic, copy)NSString *path;   // 保存文件地址
@property (nonatomic, copy)NSString *folder; // 保存文件文件夹
@property (nonatomic, strong)id model;       // 可选保存对象

@property (nonatomic, assign)float   progress; // 下载进度

#pragma mark - 实例方法

/**
 *  创建一个CLQueue对象
 *
 *  @param url  下载地址
 *  @param path 保存文件地址
 *
 *  @return CLQueue对象
 */
- (instancetype)initQueueWithDownloadURL:(NSString *)url path:(NSString *)path;
/**
 *  创建一个CLQueue对象
 *
 *  @param url  下载地址
 *  @param name 保存文件名称
 *
 *  @return CLQueue对象
 */
- (instancetype)initQueueWithDownloadURL:(NSString *)url name:(NSString *)name;
/**
 *  创建一个CLQueue对象
 *
 *  @param url    下载地址
 *  @param folder 保存文件文件夹
 *  @param name   保存文件名称
 *
 *  @return CLQueue对象
 */
- (instancetype)initQueueWithDownloadURL:(NSString *)url folder:(NSString *)folder name:(NSString *)name;

/**
 *  创建一个CLQueue对象
 *
 *  @param url   下载地址
 *  @param path  保存文件地址
 *  @param model 可选保存对象
 *
 *  @return CLQueue对象
 */
- (instancetype)initQueueWithDownloadURL:(NSString *)url path:(NSString *)path model:(id)model;
/**
 *  创建一个CLQueue对象
 *
 *  @param url   下载地址
 *  @param name  保存文件名称
 *  @param model 可选保存对象
 *
 *  @return CLQueue对象
 */
- (instancetype)initQueueWithDownloadURL:(NSString *)url name:(NSString *)name model:(id)model;
/**
 *  创建一个CLQueue对象
 *
 *  @param url    下载地址
 *  @param folder 保存文件文件夹
 *  @param name   保存文件名称
 *  @param model  可选保存对象
 *
 *  @return CLQueue对象
 */
- (instancetype)initQueueWithDownloadURL:(NSString *)url folder:(NSString *)folder name:(NSString *)name model:(id)model;


@end
