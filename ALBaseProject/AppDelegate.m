//
//  AppDelegate.m
//  ALBaseProject
//
//  Created by Mac on 2018/1/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveDataChange];
}


#pragma mark - Core Data stack
- (void)initCoreData
{
    //model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:CoreDataFileName withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //store coordinator
    NSURL* storeURL = CoreDataStoreURL;
    NSError *error = nil;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                                                initWithManagedObjectModel:managedObjectModel];
    
    NSDictionary* options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path])
        {
            //When data model has changed, the old storage file will no longer compatible
            [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
            [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
        }
        else
        {
            //TODO show error to user
            //            abort();
        }
    }
    
    //context
    self.mainManagedContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.mainManagedContext.persistentStoreCoordinator = persistentStoreCoordinator;
    self.mainManagedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
}

- (void)resetCoreData
{
    NSURL* storeURL = CoreDataStoreURL;
    [self.mainManagedContext.persistentStoreCoordinator removePersistentStore:[self.mainManagedContext.persistentStoreCoordinator.persistentStores lastObject] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
    
    NSError *error = nil;
    if (![self.mainManagedContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                          configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //        abort();
    }
}

- (void)mergeContextChangesForNotification:(NSNotification *)aNotification
{
    NSManagedObjectContext * moc = aNotification.object;
    if (moc != self.mainManagedContext) {
        [self.mainManagedContext performBlock:^{
            [self.mainManagedContext mergeChangesFromContextDidSaveNotification:aNotification];
        }];
    }
}

- (NSManagedObjectContext*)newThreadManagedContext
{
    NSManagedObjectContext* threadManagedContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    threadManagedContext.parentContext = self.mainManagedContext;
    threadManagedContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeContextChangesForNotification:) name:NSManagedObjectContextDidSaveNotification object:threadManagedContext];
    
    return threadManagedContext;
}



- (BOOL)saveDataChange
{
    NSError *error = nil;
    BOOL success = NO;
    if (self.mainManagedContext != nil)//&& [NSThread isMainThread]
    {
        if ([self.mainManagedContext hasChanges])
        {
            success = [self.mainManagedContext save:&error];
            if (!success)
            {
                NSLog(@"saving mainManagedContext failed: %@", error);
            }
        }
        else
        {
            //            NSLog(@"saving mainManagedContext: has no changes");
        }
    }
    return success;
}

- (BOOL)saveDataChangeForContext:(NSManagedObjectContext*)context
{
    NSError *error = nil;
    BOOL success = NO;
    if (context != nil)
    {
        if ([context hasChanges])
        {
            success = [context save:&error];
            if (!success)
            {
                NSLog(@"saving Context %p failed: %@", context, error);
            }
        }
        else
        {
            //            NSLog(@"saving Context %p: has no changes", context);
        }
    }
    return success;
}

@end
