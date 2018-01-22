//
//  LocationService.h
//  Miju
//
//  Created by patrick on 12/10/13.
//  Copyright (c) 2013 Miju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationServiceGerCoorBlock)(CLLocationCoordinate2D coordinate, NSString *cityName);
typedef void (^LocationServiceGeoNameBlock)(NSString *locationName);

@interface LocationService : NSObject
@property (nonatomic , strong) CLLocation *prevLocation;
@property (readonly) CLLocation* lastLocation;
@property (assign,nonatomic) BOOL isBackground;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) NSString *lastCity;
@property (nonatomic, strong) NSString *lastArea;
@property (nonatomic, strong) NSString *lastLocationName;

//@property (nonatomic) BOOL isFirstTimeGetLocation;
//@property (nonatomic,readonly) BOOL isUpdateLocation;

+ (LocationService *)sharedInstance;
- (BOOL)isLocationServiceEnabled;
- (void)startUpdateLocation;
- (void)startMonitoringSignificantLocationChanges;
- (void)stopUpdateLocation;
- (void)stopMonitoringSignificantLocationChanges;
- (void)updateLocationManually;
- (void)getLocationCoordinate:(NSString*)locationName andBlock:(LocationServiceGerCoorBlock)block;
- (void)getLocationName:(CLLocationCoordinate2D)coordinate andBlock:(LocationServiceGeoNameBlock)block;

@end
