//
//  CLNetworkingKit.h
//  CameraKitDemo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLXMLParser.h"

#pragma mark -- upload parameters

#define UPLOAD_PARAMETERS_NAME @"file"
#define UPLOAD_PARAMETERS_FILENAME @"filename"
#define UPLOAD_PARAMETERS_FILEDATA @"filedata"
#define UPLOAD_PARAMETERS_MIME @"mimetype"


#pragma mark -- contenttypes

#define ContentTypes_Json @"application/json"

#define ContentTypes_XML @"application/xml"
#define ContentTypes_SoapXML @"application/soap+xml"
#define ContentTypes_TextXML @"text/xml"

#define ContentTypes_Text @"text/plain"

#pragma mark -- mimetypes

#define MIMETYPES_IMAGE_PNG  @"image/png"
#define MIMETYPES_AUDIO_MOV  @"video/quicktime"
#define MIMETYPES_AUDIO_MP4  @"video/mp4"

/**
 *  返回数据的格式
 */
typedef NS_ENUM(NSInteger, ContentTypes) {
    /**
     *  Json数据
     */
    ContentTypesJson,
    /**
     *  XML数据
     */
    ContentTypesXML,
    /**
     *  Text数据
     */
    ContentTypesText,
    /**
     *  Data数据
     */
    ContentTypesData,
};
/**
 *  请求数据的方式
 */
typedef NS_ENUM(NSInteger, RequestMethod) {
    /**
     *  Post请求
     */
    RequestMethodPost,
    /**
     *  Get请求
     */
    RequestMethodGet
};
typedef NS_ENUM(NSInteger, MimeType) {
    MimeTypePNG,
    MimeTypeMOV,
    MimeTypeMP4,
    MimeTypeJPG
};

/**
 *  请求后，获取到数据的block
 *
 *  @param responseObj 请求到数据
 *  @param success     请求成功或失败
 *  @param error       失败描述
 *
 *  @return 暂留
 */
typedef void(^ResponseBlock)(id responseObj, BOOL success, NSError *error);

/**
 *  网络请求,请求进度 block
 *
 *  @param downloadProgress 进度条
 */
typedef void(^RequestProgress)(NSProgress * downloadProgress);


@interface CLNetworkingKit : NSObject

#pragma mark -- 网络请求


/**
 *  网络请求,URL+Parameters
 *
 *  @param URL       网络请求地址
 *  @param paramters 网络请求参数
 *  @param responses 网络请求返回 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters responseblock:(ResponseBlock)responses;


/**
 *  网络请求,URL+Parameters,添加进度条
 *  @param progress 进度 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters progress:(RequestProgress)progress responseblock:(ResponseBlock)responses;


/**
 *  网络请求,URL+Parameters+Method
 *
 *  @param URL       网络请求地址
 *  @param paramters 网络请求参数
 *  @param method    网络请求方式
 *  @param responses 网络请求返回 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters requestmethod:(RequestMethod)method responseblock:(ResponseBlock)responses;


/**
 *  网络请求,URL+Parameters+Method,添加进度条
 *  @param progress 进度 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters requestmethod:(RequestMethod)method progress:(RequestProgress)progress responseblock:(ResponseBlock)responses;


/**
 *  网络请求,URL+Parameters+Contents
 *
 *  @param URL       网络请求地址
 *  @param paramters 网络请求参数
 *  @param content   网络请求返回类型
 *  @param responses 网络请求返回 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters contenttype:(ContentTypes)content responseblock:(ResponseBlock)responses;


/**
 *  网络请求,URL+Parameters+Contents,添加进度条
 *  @param progress 进度 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters contenttype:(ContentTypes)content progress:(RequestProgress)progress responseblock:(ResponseBlock)responses;


/**
 *  网络请求,URL+Parameters+Method+Contents
 *
 *  @param URL       网络请求地址
 *  @param paramters 网络请求参数
 *  @param method    网络请求方式
 *  @param content   网络请求返回类型
 *  @param responses 网络请求返回 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters requestmethod:(RequestMethod)method contenttype:(ContentTypes)content responseblock:(ResponseBlock)responses;


/**
 *  网络请求,URL+Parameters+Method+Contents,添加进度条
 *  @param progress 进度 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters requestmethod:(RequestMethod)method contenttype:(ContentTypes)content progress:(RequestProgress)progress responseblock:(ResponseBlock)responses;

#pragma mark -- 网络上传


/**
 *  上传文件
 *
 *  @param URL        上传地址
 *  @param uploadparameters NSDictionary 字典
 *                    1.MimeType 上传文件类型 2.FileName 文件名 3.FileData 上传数据
 *  @param progress   上传进度
 *  @param responses  成功或失败回调
 */
+ (NSURLSessionUploadTask *)UploadWithURL:(NSString *)URL uploadparameters:(id)uploadparameters progress:(RequestProgress)progress responseblock:(ResponseBlock)responses;


/**
 *  上传文件 + Method
 *
 *  @param URL              上传地址
 *  @param method           上传方法
 *  @param parameters       上传URL参数
 *  @param uploadparameters NSDictionary 字典
 *                          1.MimeType 上传文件类型 2.FileName 文件名 3.FileData 上传数据
 *  @param progress   上传进度
 *  @param responses  成功或失败回调
 */
+ (NSURLSessionUploadTask *)UploadWithURL:(NSString *)URL method:(RequestMethod)method parameters:(id)parameters uploadparameters:(id)uploadparameters progress:(RequestProgress)progress responseblock:(ResponseBlock)responses;


#pragma mark -- 网络下载


/**
 *  网络文件下载方法
 *
 *  @param URL       下载文件地址
 *  @param path      下载文件保存地址
 *  @param progress  下载进度
 *  @param responses 下载结束返回回调 block
 */
+ (NSURLSessionDownloadTask *)DownloadWithURL:(NSString *)URL cachepath:(NSString *)path progress:(RequestProgress)progress responseblock:(ResponseBlock)responses;

#pragma mark -- private method

@end
