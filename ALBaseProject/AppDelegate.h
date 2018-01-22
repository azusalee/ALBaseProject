//
//  AppDelegate.h
//  ALBaseProject
//
//  Created by Mac on 2018/1/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) NSManagedObjectContext *mainManagedContext;



- (NSManagedObjectContext*)newThreadManagedContext;
- (BOOL)saveDataChange;
- (BOOL)saveDataChangeForContext:(NSManagedObjectContext*)context;


@end

