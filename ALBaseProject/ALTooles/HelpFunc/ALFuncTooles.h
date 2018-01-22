//
//  ALFuncTooles.h
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALFuncTooles : NSObject


//创建某种颜色的图片
+(UIImage*)createImageWithColor:(UIColor*)color;
//计算字符串大小
+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString*)string;
//获取截图
+ (UIImage*)getShotWithView:(UIView*)view andSize:(CGRect)rect;

/**
 *  字符串转json
 */
+ (id)stringToJson:(NSString *)jsonString;
/**
 *  json转字符串
 */
+ (NSString*)jsonToString:(id)json;
/**
 *  从txt文件获取Json
 */
+ (id)getJsonFromTxtFile:(NSString*)fileName;

//获取某key关闭了几次
+(NSInteger)hintCountWithKey:(NSString*)key;
+(void)setHintCountWithKey:(NSString*)key andCount:(NSInteger)count;

+ (void)setUserDefault:(NSString*)key value:(id)value;
+ (id)getUserDefault:(NSString*)key defaultValue:(id)value;

//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;

/**
 *  从url获取参数字典
 */
+ (NSDictionary *)getDictFromUrlString:(NSString *)urlString;
/**
 *  从字典拼接成url的参数
 */
+ (NSString*)getUrlStringParamFromDict:(NSDictionary*)dict;

/**
 *  距离字符串显示处理
 */
+ (NSString*)getDistanceString:(double)distance;

/**
 获取App信息
 */
+ (NSDictionary*)getAppInfo;

/**
 *  计算两点坐标的距离(米)
 */
double LantitudeLongitudeDist(double lon1,double lat1,
                              double lon2,double lat2);

@end
