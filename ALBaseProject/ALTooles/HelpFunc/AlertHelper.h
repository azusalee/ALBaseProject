//
//  AlertHelper.h
//  Ekeo2
//
//  Created by Roger on 13-8-29.
//  Copyright (c) 2013年 Ekeo. All rights reserved.
//

#import <Foundation/Foundation.h>

/***
 errorCode:
 
 ***/

@interface AlertHelper : NSObject

+ (void)showErrorAlert:(NSError*)error;

+ (void)showAlertWithTitle:(NSString*)title;

+ (void)showAlertWithCode:(long long)code;

@end
