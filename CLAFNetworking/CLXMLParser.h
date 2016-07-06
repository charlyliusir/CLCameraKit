//
//  CLXMLParse.h
//  CLXMLParse
//
//  介绍:CLXMLParse类是一个基本通用的NSXMLParser解析类
//      它可以将一个NSXMLParser对象解析成一个字典然后通过
//      block回传用来显示或者调用
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XMLDocumentBlock) (NSDictionary *XMLDocument);

@interface CLXMLParser : NSObject

/**
 *  XML解析回调 block
 */
@property(nonatomic, copy)XMLDocumentBlock xmlDocumentBlock;

/**
 *  创建XMLParser 解析 解析成一个字典
 *
 *  @param parser NSXMLParser对象
 *
 *  @return 返回CLXMLParser对象
 */
- (instancetype)initWithXMLParser:(id)parser;
/**
 *  创建XMLParser 解析 解析成一个字典
 *
 *  @param parser        NSXMLParser对象
 *  @param documentBlock XMLDocumentBlock 回调block
 *
 *  @return 返回CLXMLParser对象
 */
- (instancetype)initWithXMLParser:(id)parser XMLDocumentBlock:(XMLDocumentBlock)documentBlock;

@end
