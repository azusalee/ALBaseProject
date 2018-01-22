//
//  HTTPClient.m
//  Miju
//
//  Created by Roger on 12/9/13.
//  Copyright (c) 2013 Miju. All rights reserved.
//

#import "HTTPClient.h"

static HTTPClient *_instance = nil;
@interface HTTPClient ()
@end

@implementation HTTPClient

+ (instancetype)instance
{
    if (!_instance)
    {
        _instance = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:base_url]]];
        [_instance readLoginData];
    }
    return _instance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
    }
    
    return self;
}

- (NSMutableDictionary*)newDefaultParameters
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //double time = ([[NSDate date] timeIntervalSince1970] * ServiceTimeToLocalTimeRate);
    //[parameters setValue:[NSNumber numberWithInteger:time] forKey:@"timestamp"];
    //[parameters setValue:ClientKey forKey:@"client_key"];
    //parameters[@"request_from"] = @"app";
    parameters[@"client"] = @"ios";
    //[parameters setValue:AppDelegateInstance.defaultUser.user_id forKey:@"user_id"];
    if(self.token != nil) {
        [parameters setObject:self.token forKey:@"key"];
    }
    else
    {
        [self readLoginData];
        if (self.token!=nil) {
            [parameters setObject:self.token forKey:@"key"];
        }else{
            //[parameters setObject:@"123" forKey:@"ticket"];
        }
    }
    //[parameters setObject:@"3f50c8e9117be3dd9f54e5f4494af394" forKey:@"ticket"];
    return parameters;
}

- (NSDictionary*)getRequestParamWithCustomParam:(NSDictionary*)dict{
    NSMutableDictionary *mutRequestDict = [self newDefaultParameters];
    [mutRequestDict addEntriesFromDictionary:dict];
    NSDictionary *requestParam = [NSDictionary dictionaryWithDictionary:mutRequestDict];
    return requestParam;
    
}

- (BOOL)isLogin
{
    return self.uid && self.token;
}

- (void)setUid:(NSString *)new_uid token:(NSString*)new_token
{
    if ([new_uid isKindOfClass:[NSString class]])
    {
        self.uid = [NSString stringWithString:new_uid];
    }
    else
    {
        self.uid = [NSString stringWithFormat:@"%lld", new_uid.longLongValue];
    }
    self.token = new_token;
    [self saveLoginData];
}

- (void)readLoginData
{
    NSString* login_uid_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLoginUidToken"];
    if (login_uid_token.length > 0)
    {
        NSArray* array = [login_uid_token componentsSeparatedByString:@"__"];
        if (array.count >= 2)
        {
            [self setUid:[array objectAtIndex:0] token:[array objectAtIndex:1]];
        }
    }
}

- (void)saveLoginData
{
    NSString* login_uid_token = [NSString stringWithFormat:@"%@__%@", self.uid, self.token];
    [[NSUserDefaults standardUserDefaults] setObject:login_uid_token forKey:@"kLoginUidToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearLoginData
{
    self.uid = nil;
    self.token = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kLoginUidToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (NSURLSessionDataTask*)postWithActionOp:(NSString*)actOpName params:(NSDictionary*)params block:(GetRequestBlock)block{
    NSString *urlString = [NSString stringWithFormat:@"%@",actOpName];
    NSDictionary* requestDict = [self getRequestParamWithCustomParam:params];
    NSURLSessionDataTask *task = [self POST:urlString parameters:requestDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        long long status = [responseObject safeLongLongForKey:kResponseStatus];
        [AlertHelper showAlertWithCode:status];
        
        id errorObj = responseObject[kResponseData];
        NSString *error = nil;
        if ([errorObj isKindOfClass:[NSDictionary class]]) {
            error = [errorObj safeStringForKey:kResponseError];
        }else{
            error = [responseObject safeStringForKey:kResponseError];
        }
        
        
        block(responseObject,error,status,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,nil,-1,error);
        
    }];
    
    return task;
}

- (NSURLSessionDataTask*)getWithActionOp:(NSString*)actOpName params:(NSDictionary*)params block:(GetRequestBlock)block{
    NSString *urlString = [NSString stringWithFormat:@"%@",actOpName];
    NSDictionary* requestDict = [self getRequestParamWithCustomParam:params];
    NSURLSessionDataTask *task = [self GET:urlString parameters:requestDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        long long status = [responseObject safeLongLongForKey:kResponseStatus];
        [AlertHelper showAlertWithCode:status];
        
        id errorObj = responseObject[kResponseData];
        NSString *error = nil;
        if ([errorObj isKindOfClass:[NSDictionary class]]) {
            error = [errorObj safeStringForKey:kResponseError];
        }else{
            error = [responseObject safeStringForKey:kResponseError];
        }
        block(responseObject,error,status,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,nil,-1,error);
        
    }];
    
    return task;
}


- (NSURLSessionDataTask*)postWithActionOp:(NSString*)actOpName params:(NSDictionary*)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress block:(GetRequestBlock)resultBlock{
    NSString *urlString = [NSString stringWithFormat:@"%@",actOpName];
    NSDictionary* requestDict = [self getRequestParamWithCustomParam:params];
    NSURLSessionDataTask *task = [self POST:urlString parameters:requestDict constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        long long status = [responseObject safeLongLongForKey:kResponseStatus];
        NSString *error = [responseObject safeStringForKey:kResponseError];
        resultBlock(responseObject,error,status,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resultBlock(nil,nil,-1,error);
    }];
    
    return task;
}

- (NSString*)getUploadImageName{
    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 要解决此问题，
    // 可以在上传时使用当前的系统事件作为文件名
    NSDate *date = [NSDate date];
    long long dateTime = date.timeIntervalSince1970*1000;
    int ramValue = arc4random()%10000;
    NSString *fileName = [NSString stringWithFormat:@"%lld_%d.jpg", dateTime, ramValue];
    return fileName;
    
}

- (NSString*)getUploadVoiceName{
    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 要解决此问题，
    // 可以在上传时使用当前的系统事件作为文件名
    NSDate *date = [NSDate date];
    long long dateTime = date.timeIntervalSince1970*1000;
    int ramValue = arc4random()%10000;
    NSString *fileName = [NSString stringWithFormat:@"%lld_%d.wav", dateTime, ramValue];
    return fileName;
    
}

- (NSString*)getUploadVideoName{
    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 要解决此问题，
    // 可以在上传时使用当前的系统事件作为文件名
    NSDate *date = [NSDate date];
    long long dateTime = date.timeIntervalSince1970*1000;
    int ramValue = arc4random()%10000;
    NSString *fileName = [NSString stringWithFormat:@"%lld_%d.mp4", dateTime, ramValue];
    return fileName;
    
}


- (NSURLSessionDataTask*)postUploadImageWithAction:(NSString*)actOpName andImage:(UIImage*)image andUploadImageName:(NSString*)fileName andUploadKeyName:(NSString*)keyName params:(NSDictionary*)params progress:( void (^)(NSProgress * ))uploadProgress block:(GetRequestBlock)resultBlock{
    NSString *urlString = [NSString stringWithFormat:@"%@",actOpName];
    
    if (fileName == nil) {
        fileName = [self getUploadImageName];
    }
    
    
    NSDictionary* requestDict = [self getRequestParamWithCustomParam:params];
    NSURLSessionDataTask *task = [self POST:urlString parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        
        
        
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:keyName fileName:fileName mimeType:@"image/jpeg"];

        
    } progress:uploadProgress success:^(NSURLSessionDataTask *  task, id   responseObject) {
        long long status = [responseObject safeLongLongForKey:kResponseStatus];
        NSString *error = [responseObject safeStringForKey:kResponseError];
        resultBlock(responseObject,error,status,nil);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        resultBlock(nil,nil,-1,error);
    }];
    
    return task;
}


- (NSURLSessionDataTask*)postFileWithActionOp:(NSString*)actOpName andData:(NSData*)fileData andUploadFileName:(NSString*)fileName andUploadKeyName:(NSString*)keyName and:(NSString*)ext params:(NSDictionary*)params progress:( void (^)(NSProgress * ))uploadProgress block:(GetRequestBlock)resultBlock{
    NSString *urlString = [NSString stringWithFormat:@"%@",actOpName];
    
    if (fileName == nil) {
        fileName = [self getUploadImageName];
    }
    
    
    NSDictionary* requestDict = [self getRequestParamWithCustomParam:params];
    NSURLSessionDataTask *task = [self POST:urlString parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        
        
        
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        
        NSInputStream *inputStream = [NSInputStream inputStreamWithData:fileData];
        [formData appendPartWithInputStream:inputStream name:keyName fileName:fileName length:fileData.length mimeType:ext];
        
        //[formData appendPartWithFileData:fileData name:keyName fileName:fileName mimeType:ext];
        //[formData appendPartWithFormData:fileData name:keyName];
        
        
    } progress:uploadProgress success:^(NSURLSessionDataTask *  task, id   responseObject) {
        long long status = [responseObject safeLongLongForKey:kResponseStatus];
        NSString *error = [responseObject safeStringForKey:kResponseError];
        resultBlock(responseObject,error,status,nil);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        resultBlock(nil,nil,-1,error);
    }];
    
    return task;
}

@end
