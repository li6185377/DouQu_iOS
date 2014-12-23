//
// Created by ivan on 13-7-17.
//
//

#import "objc/runtime.h"

@protocol YYJSONHelperProtocol

@end

@interface YYJSONParser : NSObject
@property(strong, nonatomic) Class clazz;   //要转换成什么class
@property(assign, nonatomic) BOOL single;   //是否单个
@property(strong, nonatomic) NSString *key; //key
@property(strong, nonatomic) id result;     //结果
@property(readonly, nonatomic) id smartResult;

- (instancetype)initWithKey:(NSString *)key clazz:(Class)clazz single:(BOOL)single;

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz single:(BOOL)single;

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz;

@end

@interface NSObject (YYJSONHelper)

/**
*   如果model需要取父类的属性，那么需要自己实现这个方法，并且返回YES
*/
+ (BOOL)YYSuper;

/**
*   映射好的字典
*   {jsonkey:property}
*/
+ (NSDictionary *)YYJSONKeyDict;

/**
*   自己绑定jsonkey和property
*   如果没有自己绑定，默认为 {jsonkey:property} 【jsonkey=property】
*/
+ (void)bindYYJSONKey:(NSString *)jsonKey toProperty:(NSString *)property;

/**
*   返回jsonString
*/
- (NSString *)YYJSONString;

/**
*   返回jsonData
*/
- (NSData *)YYJSONData;

/**
*   返回json字典，不支持NSArray
*/
- (NSDictionary *)YYJSONDictionary;

/**
*   防止服务端返回的数据不对 导致没找到此方法造成的闪退
*/
- (NSArray *)toModels:(Class)modelClass;

- (NSArray *)toModels:(Class)modelClass forKey:(NSString *)key;

- (id)toModel:(Class)modelClass;

- (id)toModel:(Class)modelClass forKey:(NSString *)key;
@end

@interface NSObject (YYProperties)
/**
*   根据传入的class返回属性集合
*/
const char *property_getTypeString(objc_property_t property);

- (NSArray *)yyPropertiesOfClass:(Class)aClass;

+ (NSString *)propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName;
@end


@interface NSString (YYJSONHelper)

@end

@interface NSDictionary (YYJSONHelper)

- (id)yyObjectForKey:(id)key;

@end

@interface NSData (YYJSONHelper)
/**
*   @brief  通过key拿到json数据
*/
- (id)valueForJsonKey:(NSString *)key;

/**
*   @brief  通过key集合拿到对应的key的json数据字典
*/
- (NSDictionary *)dictForJsonKeys:(NSArray *)keys;

/**
*   @brief  解析结果直接在parser的result字段里面，这个方法主要是为了提高解析的效率
*   如果一个json中有多个key ex：{用户列表，商品列表、打折列表}那么传3个解析器进来就好了，不会对data进行三次重复的解析操作
*   @param  parsers 要解析为json的解析器集合
*/

- (void)parseToObjectWithParsers:(NSArray *)parsers;
@end

@interface NSArray (YYJSONHelper)

@end