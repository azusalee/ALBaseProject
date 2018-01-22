//
//  HTTPClient.h
//  Miju
//
//  Created by Roger on 12/9/13.
//  Copyright (c) 2013 Miju. All rights reserved.
//

#import "AFNetworking.h"

typedef void (^GetRequestBlock)(NSDictionary * _Nullable responseObject,NSString * _Nullable error,long long status,NSError * _Nullable requestFailed);

#define HTTPClientInstance [HTTPClient instance]

@interface HTTPClient : AFHTTPSessionManager
@property NSString* _Nullable uid;
@property NSString* _Nullable token;
+ (instancetype _Nullable )instance;
- (NSMutableDictionary*_Nullable)newDefaultParameters;
- (NSDictionary*_Nullable)getRequestParamWithCustomParam:(NSDictionary*_Nullable)dict;
- (void)setUid:(NSString *_Nullable)new_uid token:(NSString*_Nullable)new_token;
- (BOOL)isLogin;
- (void)saveLoginData;
- (void)readLoginData;
- (void)clearLoginData;


- (NSURLSessionDataTask*_Nullable)getWithActionOp:(NSString*_Nullable)actOpName params:(NSDictionary*_Nullable)params block:(GetRequestBlock _Nullable )block;
- (NSURLSessionDataTask*_Nullable)postWithActionOp:(NSString*_Nullable)actOpName params:(NSDictionary*_Nullable)params block:(GetRequestBlock _Nullable )block;


- (NSURLSessionDataTask*_Nullable)postWithActionOp:(NSString*_Nullable)actOpName params:(NSDictionary*_Nullable)params constructingBodyWithBlock:(void (^_Nullable)(_Nullable id  <AFMultipartFormData> formData))block
                                          progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress block:(GetRequestBlock _Nullable )resultBlock;

- (NSURLSessionDataTask*_Nullable)postFileWithActionOp:(NSString*_Nullable)actOpName andData:(NSData*_Nullable)fileData andUploadFileName:(NSString*_Nullable)fileName andUploadKeyName:(NSString*_Nullable)keyName and:(NSString*_Nullable)ext params:(NSDictionary*_Nullable)params progress:( void (^_Nullable)(NSProgress * _Nullable ))uploadProgress block:(GetRequestBlock _Nullable )resultBlock;

- (NSString*_Nullable)getUploadImageName;
- (NSString*_Nullable)getUploadVoiceName;
- (NSString*_Nullable)getUploadVideoName;
@end
