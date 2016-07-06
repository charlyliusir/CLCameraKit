//
//  CLXMLParse.m
//  CLXMLParse
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CLXMLParser.h"
#import "NSString+CLEmpty.h"

@interface CLXMLParser () <NSXMLParserDelegate>

// XML 对象
@property (nonatomic, strong)NSXMLParser *xmlParamers;
// XML解析后的字典文档
@property (nonatomic, strong)NSMutableDictionary *document;
// XML解析中的rootElement
@property (nonatomic, strong)NSMutableArray *rootElement;
// 解析过程中结点名称
@property (nonatomic, strong)id elementObj;
// 解析过程中结点名称对应数据
@property (nonatomic, copy)NSString *elementValue;

@property (nonatomic, copy)NSString *rootElementName;

@property (nonatomic, assign)BOOL isFindCharacters;


@end

@implementation CLXMLParser

/**
 *  创建XMLParser 解析 解析成一个字典
 *
 *  @param parser NSXMLParser对象
 *
 *  @return 返回CLXMLParser对象
 */
- (instancetype)initWithXMLParser:(id)parser
{
    
    if (self = [super init]) {
        
        self.xmlParamers = (NSXMLParser *)parser;
        self.xmlParamers.delegate = self;
        self.isFindCharacters = NO;
        
    }
    
    return self;
    
}

/**
 *  创建XMLParser 解析 解析成一个字典
 *
 *  @param parser        NSXMLParser对象
 *  @param documentBlock XMLDocumentBlock 回调block
 *
 *  @return 返回CLXMLParser对象
 */
- (instancetype)initWithXMLParser:(id)parser XMLDocumentBlock:(XMLDocumentBlock)documentBlock
{

    if (self = [self initWithXMLParser:parser]) {
        
        self.xmlDocumentBlock = documentBlock;
        
    }
    
    return self;
    
}

- (void)setXmlDocumentBlock:(XMLDocumentBlock)xmlDocumentBlock
{
    
    _xmlDocumentBlock = xmlDocumentBlock;
    
    [self.xmlParamers parse];
    
}

#pragma mark - XMLParserDelegate
// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    // 第一步
    self.document = @{}.mutableCopy;
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // 第三步
    id rootObject = self.document[self.rootElementName];
    if ([rootObject isKindOfClass:[NSDictionary class]]) {
        
        [self.document removeObjectForKey:self.rootElementName];
        [self.document addEntriesFromDictionary:rootObject];
        
    }
    
    __weak typeof(self)currentWeakSelf = self;
    
    self.xmlDocumentBlock(currentWeakSelf.document.copy);
    
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    // 第二步 , elementName 是Element的结点
    if (self.rootElement) {
        
        // 遍历最后一个结点对应的值，此结点包含要改变键值对所在的字典中
        // 然后将每一个结点对应的值保存到一个数组中，用来重新生成一个解析值
        id elementObj = self.document;
        NSMutableArray *elementObjArray = @[].mutableCopy;
        
        for (NSString *elementNames in self.rootElement) {
            
            if ([elementObj isKindOfClass:[NSArray class]]) {
                
                elementObj = [elementObj lastObject][elementNames];
                
            }else {
                
                elementObj = elementObj[elementNames];
                
            }
            
            [elementObjArray addObject:elementObj];
            
        }
        // 获得解析完后，最近一个结点数据更新，并且生成最后一个结点的数据
        id elementendObj = [self parserStartElement:elementObj elementName:[elementName lowercaseString]];
        
        [self reBuildDocument:elementendObj elementValueArray:elementObjArray];
        
    } else 
    {
        self.rootElementName = [elementName lowercaseString];
        // 创建rootElement
        self.rootElement = @[].mutableCopy;
        // 将当前的elementName初始化一个对应值字典添加到xml解析字典中
        [self.document setObject:@{} forKey:[elementName lowercaseString]];
        
    }
    
    [self.rootElement addObject:[elementName lowercaseString]];
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    
    [self.rootElement removeObject:[elementName lowercaseString]];
    
    // 判断结点值是否存在且不为空
    if (self.elementValue&&[self.elementValue isNotEmpty]&&self.isFindCharacters) {
        
        self.isFindCharacters = NO;
        // 遍历最后一个结点对应的值，此结点包含要改变键值对所在的字典中
        // 然后将每一个结点对应的值保存到一个数组中，用来重新生成一个解析值
        id elementObj = self.document;
        NSMutableArray *elementObjArray = @[].mutableCopy;
        
        for (NSString *elementNames in self.rootElement) {
            
            if ([elementObj isKindOfClass:[NSArray class]]) {
                
                elementObj = [elementObj lastObject][elementNames];
                
            }else {
                
                elementObj = elementObj[elementNames];
                
            }
            
            [elementObjArray addObject:elementObj];
            
        }
        // 获得解析完后，最近一个结点数据更新，并且生成最后一个结点的数据
        id elementendObj = [self parserEndElement:elementObj elementName:[elementName lowercaseString]];
        // 重组解析数据
        [self reBuildDocument:elementendObj elementValueArray:elementObjArray];
        
    }
    
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    // 第三步 对应elementName的值
    self.isFindCharacters = YES;
    self.elementValue = string;
    
}

/**
 *  重组方法
 *
 *  @param elementendObj   最后合成的数据
 *  @param elementObjArray 所有结点的数据数组
 */
- (void)reBuildDocument:(id)elementendObj elementValueArray:(NSArray *)elementObjArray
{
    
    NSDictionary *document = @{};
    // 遍历所有root结点，将所有数据整合起来，生成最后的数据
    for (int i = (int)elementObjArray.count-1; i >= 0; i --) {
        // 当前结点的后一个结点的名称
        NSString *pastElement = NULL;
        // 当前结点的名称
        NSString *rootElement = self.rootElement[i];
        id obj = elementObjArray[i];
        // 如果当前结点是root结点中最后一个结点，直接拼接最后一条数据
        // 如果当前结点不是root结点中最后一个结点，获取当前结点对应的下一个结点
        // 下一个结点对应的数据就是doucment，更新当前结点中key值为下一个结点名称的数据为doucment
        // 重新赋值doucment为当前结点的数据值
        if (i>=self.rootElement.count-1) {
            
            document = @{rootElement:elementendObj};
            
        } else {
            
            pastElement = self.rootElement[i + 1];
            // 以当前结点为key值，以新生成的对象为value值，创建新的解析对象
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                document = @{rootElement:document};
                
            } else if ([obj isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *emementValueArray = [obj mutableCopy];
                [emementValueArray replaceObjectAtIndex:emementValueArray.count-1 withObject:document];
                document = @{rootElement:emementValueArray.copy};
                
            }
            
        }
        
    }
    
    // 拼接数据完成，重新赋值xml解析数据
    self.document = document.mutableCopy;
}

/**
 *  对最后一个遍历到的element赋值,从一个RootElement开始
 *
 *  @param document  需要解析的字典
 *  @param cuElement 需要重新赋值的结点
 */
- (id)parserStartElement:(id)elementValue elementName:(NSString *)cuElement
{
    
    id mutableElementValue = nil;
    // 判断最新的elementName是否在当前的elements的name数组中
    // 此处rootElementValue有可能是NSDictionary,也有可能是NSArry
    // 根据不同的数值类型，进行判断
    // 如果存在，说明xml是一个列表，此时我们就把它整理成一个数组
    // 如果不存在，说明xml就是一个字典类型，此时不用进行其他操作
    // 这个xml解析只适用于联咏的xml文档解析
    if ([elementValue isKindOfClass:[NSDictionary class]]) {
        
        // 取得当前elementvalue中所有的key值
        NSArray *elementsName = [elementValue allKeys];
        // 判断当前的element的key值是否存在于key值数组中
        // 如果存在说明，当前rootelement对应的value是一个数组
        // 如果不存在说明，当前rootelement对应的value是一个字典
        if ([elementsName containsObject:cuElement]) {
            // 给当前rootElementName重新设置值，即将原先的字典替换成一个数组
            // 当前elementName创建成一个字典，其对应的值为
            
            id elementValueObj = elementValue[cuElement];
            if ([elementValueObj isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *elements = [elementValueObj mutableCopy];
                [elements addObject:@{}];
                mutableElementValue = @{cuElement:elements.copy};
                
            } else {
                
                mutableElementValue = @{cuElement:@[elementValue[cuElement],@{}]};
                
            }
//            mutableElementValue = @[elementValue, @{cuElement:@{}}];
            
        } else {
            
            NSMutableDictionary *newElementValue = [elementValue mutableCopy];
            [newElementValue setObject:@{} forKey:cuElement];
            mutableElementValue = newElementValue.copy;
            
        }
        
    }else if ([elementValue isKindOfClass:[NSArray class]]) {
        
        // 获取可操作数组
        NSMutableArray *tempArray = [elementValue mutableCopy];
        // 取得最后一条数据
        NSMutableDictionary *elementDictory = [[tempArray lastObject] mutableCopy];
        // 取得当前elementvalue中所有的key值
        NSArray *elementsName = [elementDictory allKeys];
        
        // 判断当前的element的key值是否存在于key值数组中
        // 如果存在说明，当前rootelement对应的value是一个数组
        // 如果不存在说明，当前rootelement对应的value是一个字典
        // 重新对tempArray进行操作，然后重新赋值
        if ([elementsName containsObject:cuElement]) {
            // 字典中添加数据 ， 然后对tempArray最后一个数据进行重新赋值
            [tempArray addObject:@{cuElement:@{}}];
            
        } else {
            
            [elementDictory setObject:@{} forKey:cuElement];
            [tempArray replaceObjectAtIndex:tempArray.count-1 withObject:elementDictory.copy];
            
        }
        
        // 给当前rootElementName重新设置值，即将原先的字典替换成一个数组
        mutableElementValue = tempArray;
        
    }
    
    return mutableElementValue;
    
}

/**
 *  对最后一个遍历到的element赋值,结束一个RootElement
 *
 *  @param document  需要解析的字典
 *  @param cuElement 需要重新赋值的结点
 */
- (id)parserEndElement:(id)elementValue elementName:(NSString *)cuElement
{
    
    id mutableElementValue = nil;
    
    // 遍历所有没有成对的根结点
    if ([elementValue isKindOfClass:[NSDictionary class]]) {
        
        // 创建一个可变字典，用于赋值
        // 获取所有字典的key值
        NSMutableDictionary *mutableDictionary = [elementValue mutableCopy];
        
        [mutableDictionary removeObjectForKey:cuElement];
        [mutableDictionary setObject:self.elementValue forKey:cuElement];
        
        mutableElementValue = mutableDictionary.copy;
        
    }else if ([elementValue isKindOfClass:[NSArray class]]) {
        
        // 创建一个可变字典，用于赋值
        // 获取所有字典的key值
        NSMutableArray *mutableArray             = [elementValue mutableCopy];
        NSMutableDictionary *mutableDictionary   = [[elementValue lastObject] mutableCopy];
        
        [mutableDictionary removeObjectForKey:cuElement];
        [mutableDictionary setObject:self.elementValue forKey:cuElement];
        mutableArray[mutableArray.count-1] = mutableDictionary.copy;
        
        mutableElementValue = mutableArray.copy;
        
    }
    
    return mutableElementValue;
    
}

@end
