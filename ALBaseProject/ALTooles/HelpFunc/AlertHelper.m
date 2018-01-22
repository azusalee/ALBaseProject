//
//  AlertHelper.m
//  Ekeo2
//
//  Created by Roger on 13-8-29.
//  Copyright (c) 2013年 Ekeo. All rights reserved.
//

#import "AlertHelper.h"
//#import "SVProgressHUD.h"
#import "LZHAlertView.h"
@implementation AlertHelper

+ (NSMutableArray*)alertQueue
{
    static NSMutableArray *_alertQueueInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _alertQueueInstance = [[NSMutableArray alloc] init];
    });
    
    return _alertQueueInstance;
}

+ (void)showErrorAlert:(NSError*)error
{
    NSString *errorString = @"";
    if ([error.domain isEqualToString:NSURLErrorDomain])
    {
        errorString = @"网络异常";
    }
    
   
    NSString *recoverySuggestion = [error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
    
    errorString = recoverySuggestion;

    [AlertHelper showAlertWithTitle:errorString];
}

+ (void)showErrorAlertIfURLError:(NSError *)error
{
    if ([error.domain isEqualToString:NSURLErrorDomain])
    {
        [self showErrorAlert:error];
    }
}


+ (void)showAlertWithTitle:(NSString*)title
{
//    if (title.length > 0) {
//        [SVProgressHUD showImage:nil status:title];
//    }else{
//        [SVProgressHUD showImage:nil status:@"网络异常"];
//    }
//    if ([title isEqualToString:@"请登录"]) {
//        LZHAlertView *alertView = [LZHAlertView sharedLoginAlert];
//        alertView.contentLabel.text = @"登录凭证失效，请重新登录";
//        __weak LZHAlertView *weakAlert = alertView;
//        [alertView setBlock:^(NSInteger index, NSString *title) {
//            [AppDelegateInstance logout];
//            
//            [weakAlert hide];
//        }];
//        [alertView show];
//    }
}

+ (void)showAlertWithCode:(long long)code{
//    if (code == 20000) {
//        LZHAlertView *alertView = [LZHAlertView sharedLoginAlert];
//        alertView.contentLabel.text = @"登录凭证失效，请重新登录";
//        __weak LZHAlertView *weakAlert = alertView;
//        [alertView setBlock:^(NSInteger index, NSString *title) {
//            [AppDelegateInstance logout];
//
//            [weakAlert hide];
//        }];
//        [alertView show];
//    }
}

@end
