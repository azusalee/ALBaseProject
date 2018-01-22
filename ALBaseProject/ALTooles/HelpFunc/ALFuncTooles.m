//
//  ALFuncTooles.m
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ALFuncTooles.h"

@implementation ALFuncTooles

+(UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString*)string{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSDictionary *attrs = @{NSFontAttributeName : font,
                            NSParagraphStyleAttributeName : paragraphStyle.copy};
    
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (UIImage*)getShotWithView:(UIView*)view andSize:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(CGRectMake(0, 0, rect.size.width*2, rect.size.height*2));
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}


+ (id)stringToJson:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:NSJSONReadingMutableContainers
                                                  error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return object;
}

+ (NSString*)jsonToString:(id)json
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)getJsonFromTxtFile:(NSString*)fileName{
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    
    NSStringEncoding *useEncodeing = nil;
    //带编码头的如utf-8等，这里会识别出来
    NSString *body = [NSString stringWithContentsOfFile:txtPath usedEncoding:useEncodeing error:nil];
    
    //识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
    if (!body) {
        body = [NSString stringWithContentsOfFile:txtPath encoding:0x80000632 error:nil];
        //NSLog(@"%@",body);
    }
    //还是识别不到，按GB18030编码再解码一次.
    if (!body) {
        body = [NSString stringWithContentsOfFile:txtPath encoding:0x80000631 error:nil];
        //NSLog(@"%@",body);
    }
    
    id json = [self stringToJson:body];
    
    return json;
    
}


+(NSInteger)hintCountWithKey:(NSString*)key{
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    return count;
}

+(void)setHintCountWithKey:(NSString*)key andCount:(NSInteger)count{
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)setUserDefault:(NSString*)key value:(id)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getUserDefault:(NSString*)key defaultValue:(id)value{
    id thisValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!thisValue) {
        if (value) {
            [self setUserDefault:key value:value];
            thisValue = value;
        }
    }
    return thisValue;
}


+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

+ (NSDictionary *)getDictFromUrlString:(NSString *)urlString{
    NSArray *array1 = [urlString componentsSeparatedByString:@"?"];
    if (array1.count < 2) {
        return @{};
    }
    NSString *paramsString = [array1 lastObject];
    NSArray *array2 = [paramsString componentsSeparatedByString:@"&"];
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] initWithCapacity:array2.count];
    
    for (int i = 0; i < array2.count; ++i) {
        NSString *keyValueString = array2[i];
        NSArray *keyValue = [keyValueString componentsSeparatedByString:@"="];
        NSString *key = [keyValue firstObject];
        NSString *value = [keyValue lastObject];
        resultDict[key] = value;
    }
    
    return resultDict;
}

+ (NSString*)getUrlStringParamFromDict:(NSDictionary*)dict{
    NSString *result = @"";
    NSArray *allkey = dict.allKeys;
    for (int i = 0; i < allkey.count; ++i) {
        NSString *key = allkey[i];
        NSString *value = dict[key];
        if (i == 0) {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
        }else{
            result = [result stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        }
        
        
    }
    return result;
}


+ (NSString *)getDistanceString:(double)distance{
    //    if (distance > 1000) {
    //        NSString *distance_km = [NSString stringWithFormat:@"%0.1fkm",distance/1000];
    //        return distance_km;
    //    }else{
    NSString *distance_m = [NSString stringWithFormat:@"%0.1fkm",distance];
    return distance_m;
    //    }
}



double LantitudeLongitudeDist(double lon1,double lat1,
                              double lon2,double lat2)
{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double PI = 3.1415926;
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}

+ (NSDictionary*)getAppInfo{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    //NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    //NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    //NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return infoDictionary;
    
//    //手机序列号
//    NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
//    NSLog(@"手机序列号: %@",identifierNumber);
//    //手机别名： 用户定义的名称
//    NSString* userPhoneName = [[UIDevice currentDevice] name];
//    NSLog(@"手机别名: %@", userPhoneName);
//    //设备名称
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//    NSLog(@"设备名称: %@",deviceName );
//    //手机系统版本
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    NSLog(@"手机系统版本: %@", phoneVersion);
//    //手机型号
//    NSString* phoneModel = [[UIDevice currentDevice] model];
//    NSLog(@"手机型号: %@",phoneModel );
//    //地方型号  （国际化区域名称）
//    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
//    NSLog(@"国际化区域名称: %@",localPhoneModel );
}

@end
