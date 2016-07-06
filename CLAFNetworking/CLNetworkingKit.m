//
//  CLNetworkingKit.m
//  CameraKitDemo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CLNetworkingKit.h"
#import "AFNetworking.h"

@implementation CLNetworkingKit

/**
 *  网络请求
 *
 *  @param URL       网络请求地址
 *  @param paramters 网络请求参数
 *  @param responses 网络请求返回 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters responseblock:(ResponseBlock)responses
{
    
    [self RequestWithURL:URL parameters:parameters requestmethod:RequestMethodPost contenttype:ContentTypesJson progress:NULL responseblock:responses];
    
}


+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
    
    [self RequestWithURL:URL parameters:parameters requestmethod:RequestMethodPost contenttype:ContentTypesJson progress:progress responseblock:responses];
    
}


/**
 *  网络请求
 *
 *  @param URL       网络请求地址
 *  @param paramters 网络请求参数
 *  @param method    网络请求方式
 *  @param responses 网络请求返回 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters requestmethod:(RequestMethod)method responseblock:(ResponseBlock)responses
{
    
    [self RequestWithURL:URL parameters:parameters requestmethod:method contenttype:ContentTypesJson progress:NULL responseblock:responses];
    
}


+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters requestmethod:(RequestMethod)method progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
    
    [self RequestWithURL:URL parameters:parameters requestmethod:method contenttype:ContentTypesJson progress:progress responseblock:responses];
    
}


/**
 *  网络请求
 *
 *  @param URL       网络请求地址
 *  @param paramters 网络请求参数
 *  @param content   网络请求返回类型
 *  @param responses 网络请求返回 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters contenttype:(ContentTypes)content responseblock:(ResponseBlock)responses
{
    
    [self RequestWithURL:URL parameters:parameters requestmethod:RequestMethodPost contenttype:content progress:NULL responseblock:responses];
    
}


+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters contenttype:(ContentTypes)content progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
    
    [self RequestWithURL:URL parameters:parameters requestmethod:RequestMethodPost contenttype:content progress:progress responseblock:responses];
    
}


/**
 *  网络请求
 *
 *  @param URL       网络请求地址
 *  @param paramters 网络请求参数
 *  @param method    网络请求方式
 *  @param content   网络请求返回类型
 *  @param responses 网络请求返回 block
 */
+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters requestmethod:(RequestMethod)method contenttype:(ContentTypes)content responseblock:(ResponseBlock)responses
{
    
    [self RequestWithURL:URL parameters:parameters requestmethod:method contenttype:content progress:NULL responseblock:responses];
    
}


+ (void)RequestWithURL:(NSString *)URL parameters:(id)parameters requestmethod:(RequestMethod)method contenttype:(ContentTypes)content progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
    
    // 创建网络请求管理器
    AFHTTPSessionManager *netManager = [AFHTTPSessionManager manager];
    netManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    netManager.requestSerializer.timeoutInterval = 10;
    // 判断返回样式
    if (content == ContentTypesJson) {
        
        // 网络请求返回样式序列号
        netManager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 网络请求返回数据的格式
//        netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentTypes_Json];
        
    } else if (content == ContentTypesXML){
        
        // 网络请求返回样式序列号
        netManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        // 网络请求返回数据的格式
//        netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:ContentTypes_XML,ContentTypes_TextXML,ContentTypes_SoapXML,nil];
        
    } else if (content == ContentTypesText || content == ContentTypesData) {
        
        // 网络请求返回样式序列号
        netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 网络请求返回数据的格式
        netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:ContentTypes_Text,nil];
        
    } 
    
    // 判断网络请求方式
    if (method == RequestMethodGet) {
        
        [self HTTPSessionManager:netManager getMethodWithURL:URL parameters:parameters contenttype:content progress:progress responseblock:responses];
        
    } else if (method == RequestMethodPost) {
        
        [self HTTPSessionManager:netManager postMethodWithURL:URL parameters:parameters contenttype:content progress:progress responseblock:responses];
        
    }
    
}


/**
 *  HTTP Get 请求 + Progress
 *
 *  @param sessionManager 网络请求管理器
 *  @param URL            请求地址
 *  @param parameters     请求参数
 *  @param progress       请求进度
 *  @param responses      返回 block
 */
+ (void)HTTPSessionManager:(AFHTTPSessionManager *)sessionManager getMethodWithURL:(NSString *)URL parameters:(id)parameters contenttype:(ContentTypes)content progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
    
    [sessionManager GET:URL parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (content == ContentTypesXML) {
            
            CLXMLParser *xmlParser = [[CLXMLParser alloc] initWithXMLParser:responseObject];
            xmlParser.xmlDocumentBlock = ^(NSDictionary *XMLDocument) {
                
                responses(XMLDocument, YES, NULL);
                
            };
            
        } else if(content == ContentTypesText){
            
            responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            responses(responseObject, YES, NULL);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        responses(NULL, NO, error);
        
    }];
    
}


/**
 *  HTTP Post 请求  +  Progress
 *
 *  @param sessionManager 网络请求管理器
 *  @param URL            请求地址
 *  @param parameters     请求参数
 *  @param progress       请求进度
 *  @param responses      返回 block
 */
+ (void)HTTPSessionManager:(AFHTTPSessionManager *)sessionManager postMethodWithURL:(NSString *)URL parameters:(id)parameters contenttype:(ContentTypes)content progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
    
    [sessionManager POST:URL parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        responses(responseObject, YES, NULL);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        responses(NULL, NO, error);
        
    }];
    
}


#pragma mark -- 网络上传
/**
 *  上传文件
 *
 *  @param URL        上传地址
 *  @param parameters NSDictionary 字典
 *                    1.MimeType 上传文件类型 2.FileName 文件名 3.FileData 上传数据
 *  @param progress   上传进度
 *  @param responses  成功或失败回调
 */
+ (NSURLSessionUploadTask *)UploadWithURL:(NSString *)URL uploadparameters:(id)uploadparameters progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
 
    return [self UploadWithURL:URL method:RequestMethodPost parameters:NULL uploadparameters:uploadparameters progress:progress responseblock:responses];
    
}


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
+ (NSURLSessionUploadTask *)UploadWithURL:(NSString *)URL method:(RequestMethod)method parameters:(id)parameters uploadparameters:(id)uploadparameters progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
    
    NSURLSessionUploadTask *uploadTask;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:[self getRequestMethod:method] URLString:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:uploadparameters[UPLOAD_PARAMETERS_FILEDATA] name:UPLOAD_PARAMETERS_NAME fileName:uploadparameters[UPLOAD_PARAMETERS_FILENAME] mimeType:[self getMimeType:[uploadparameters[UPLOAD_PARAMETERS_MIME] integerValue]]];
        
    } error:nil];
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:progress
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      BOOL success = error == NULL;
                      
                      responses(responseObject, success, error);
                      
                  }];
    
    [uploadTask resume];
    
    return uploadTask;
    
}


#pragma mark -- 网络下载
/**
 *  网络文件下载方法
 *
 *  @param URL       下载文件地址
 *  @param path      下载文件保存地址
 *  @param progress  下载进度
 *  @param responses 下载结束返回回调 block
 */
+ (NSURLSessionDownloadTask *)DownloadWithURL:(NSString *)URL cachepath:(NSString *)path progress:(RequestProgress)progress responseblock:(ResponseBlock)responses
{
    
    NSURLSessionDownloadTask *downloadTask;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    downloadTask = [manager downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        BOOL success = error == NULL;
        
        responses(NULL,success, error);
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
    
}

#pragma mark -- private tools method

/**
 *  获取请求的方式的字符串
 *
 *  @param method 请求方式
 *
 *  @return 请求方式字符串
 */
+ (NSString *)getRequestMethod:(RequestMethod)method
{
    switch (method) {
        case RequestMethodPost:
            
            return @"Post";
            
            break;
        case RequestMethodGet:
            
            return @"GET";
            break;
            
        default:
            return NULL;
            break;
    }
}


/**
 *  获取上传的mime类型
 *
 *  @param mime mime类型
 *
 *  @return mime类型字符串
 */
+ (NSString *)getMimeType:(MimeType)mime
{
    
    switch (mime) {
            
        case MimeTypeJPG:
            
            return NULL;
            
            break;
        case MimeTypeMOV:
            
            return MIMETYPES_AUDIO_MOV;
            
            break;
        case MimeTypeMP4:
            
            return MIMETYPES_AUDIO_MP4;
            
            break;
        case MimeTypePNG:
            
            return MIMETYPES_IMAGE_PNG;
            
            break;
        default:
            
            return NULL;
            
            break;
    }
    
}

@end
