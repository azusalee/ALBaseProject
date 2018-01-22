//
//  ALConfig.h
//  ALBaseProject
//
//  Created by Mac on 2018/1/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#ifndef ALConfig_h
#define ALConfig_h

#define isInDev 0

#define base_url @"http://huazipintuan.cas668.cn/"
#define base_domain @"huazipintuan.cas668.cn"


#define CoreDataFileName @"ALBaseProject"
#define CoreDataStoreURL [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:CoreDataFileName]

#define ServiceTimeToLocalTimeRate 1.0f

#define DefaultFontOfSize(s)    [UIFont systemFontOfSize:s]

#define AppDelegateInstance ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define ScreenBounds                    [UIScreen mainScreen].bounds
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height
#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS10Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)
#define iOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)


#endif /* ALConfig_h */
