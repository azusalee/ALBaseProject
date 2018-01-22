//
//  LocationService.m
//  Miju
//
//  Created by patrick on 12/10/13.
//  Copyright (c) 2013 Miju. All rights reserved.
//

#import "LocationService.h"
#import "CLLocation+Sino.h"
#import "LZHAlertView.h"

#define DistanceFitler      30
//#define UploadMinInterval   10
#define UpdateLocationInterval 360

//#define LOCATIONSERVICE_DEBUG

#ifdef LOCATIONSERVICE_DEBUG
#define LOCATIONSERVICE_LOG NSLog
#else
#define LOCATIONSERVICE_LOG(...)
#endif

@interface LocationService() < CLLocationManagerDelegate>
{
    CLLocationManager* _locationManager;
    BOOL _isGettingLocationString;
    BOOL _isRest;
    
}

@property CLLocation* lastLocation;
@property CLLocation* lastUploadLocation;
@property NSDate*     lastUploadTime;


@property (nonatomic, strong) NSMutableArray *needUploadOrderList;
@property (nonatomic, strong) NSTimer *uploadOrderTimer;

@end

@implementation LocationService

+ (instancetype)sharedInstance
{
    static LocationService *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isBackground = false;
        _needUploadOrderList = [[NSMutableArray alloc] init];
        _lastCity = [ALFuncTooles getUserDefault:@"LastCity" defaultValue:@"全国"];
        self.prevLocation = [[CLLocation alloc]init];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locationManager.distanceFilter = DistanceFitler;
        _locationManager.activityType = CLActivityTypeFitness;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [_locationManager performSelector:@selector(requestWhenInUseAuthorization)];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [self stopUpdateLocation];
    [self stopMonitoringSignificantLocationChanges];
    _locationManager.delegate = nil;
}
- (BOOL)isLocationServiceEnabled
{
    return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
}

- (BOOL)isSignificantLocationChangeMonitoringAvailable
{
    return [CLLocationManager significantLocationChangeMonitoringAvailable];
}

- (void)startUpdateLocation
{
    if ([self isLocationServiceEnabled])
    {
        [_locationManager startMonitoringSignificantLocationChanges];
        [_locationManager startUpdatingLocation];
    }
}

-(void)startMonitoringSignificantLocationChanges
{
    if ([self isSignificantLocationChangeMonitoringAvailable])
    {
        [_locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)stopUpdateLocation 
{
    [_locationManager stopUpdatingLocation];
    [_locationManager stopMonitoringSignificantLocationChanges];
}

- (void)stopMonitoringSignificantLocationChanges
{
    [_locationManager stopMonitoringSignificantLocationChanges];
}

- (void)updateLocationManually
{
    if ([self isLocationServiceEnabled])
    {
        [_locationManager stopUpdatingLocation];
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    LOCATIONSERVICE_LOG(@"%@ %d", NSStringFromSelector(_cmd), status);
    switch (status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            LZHAlertView *alertView = [LZHAlertView createWithTitleArray:@[@"现在开启"]];
            alertView.contentLabel.text = @"开启位置权限";
            __weak LZHAlertView *weakAlert = alertView;
            [alertView setBlock:^(NSInteger index, NSString *title) {
                if (index == 0) {
                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
                [weakAlert hide];
            }];
            [alertView show];
            [self stopUpdateLocation];
            [self stopMonitoringSignificantLocationChanges];
            break;
        }
        default:
        {
            break;
        }
            
    }
}


- (void)getLocationRest{
    _isRest = NO;
}


- (void)getLocation{
    if (_isGettingLocationString) {
        return;
    }
    if (_isRest) {
        return;
    }
//    if (_locationString.length != 0) {
//        return;
//    }
    if ([[LocationService sharedInstance] lastLocation])
    {
        if (self.lastLocation.coordinate.latitude == 0 && self.lastLocation.coordinate.longitude == 0) {
            return;
        }
        
        CLGeocoder *revGeo = [[CLGeocoder alloc] init];
        //反向地理编码
        
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLocationRest) userInfo:nil repeats:NO];
        _isGettingLocationString = YES;
        _isRest = YES;
        
        [revGeo reverseGeocodeLocation:[LocationService sharedInstance].lastLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            _isGettingLocationString = NO;
            if (!error && [placemarks count] > 0)
            {
                NSDictionary *dict = [[placemarks objectAtIndex:0] addressDictionary];
                //                CLog(@"%@", [[placemarks objectAtIndex:0] locality]);
                //                CLog(@"%@", [[placemarks objectAtIndex:0] thoroughfare]);
                
                //NSLog(@"%@",dict);
                NSString *locString = @"";
                self.lastLocationName = [dict safeStringForKey:@"Name"];
                if ([dict hasObjectForKey:@"State"]) {
                    NSString *stateName = dict[@"State"];
                    locString = [locString stringByAppendingString:stateName];
                }
                if ([dict hasObjectForKey:@"City"]) {
                    NSString *cityName = dict[@"City"];
                    locString = [locString stringByAppendingString:cityName];
                    if(cityName > 0){
                        cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
                        [ALFuncTooles setUserDefault:@"LastCity" value:cityName];
                        self.lastCity = cityName;
                    }
                }
                if ([dict hasObjectForKey:@"SubLocality"]) {
                    NSString *areaName = dict[@"SubLocality"];
                    locString = [locString stringByAppendingString:areaName];
                    if(areaName > 0){
                        //areaName = [areaName stringByReplacingOccurrencesOfString:@"市" withString:@""];
                        self.lastArea = areaName;
                    }
                }
                if ([dict hasObjectForKey:@"Thoroughfare"]) {
                    locString = [locString stringByAppendingString:dict[@"Thoroughfare"]];
                }
                if ([dict hasObjectForKey:@"SubThoroughfare"]) {
                    locString = [locString stringByAppendingString:dict[@"SubThoroughfare"]];
                }
                if (![locString isEqualToString:_locationString] && locString.length>0) {
                    self.locationString = locString;
                }
//                if (_locationString.length == 0) {
//                    _locationString = [dict safeStringForKey:@"Name"];
//                }
            }else{
                NSLog(@"ERROR: %@", error);
            }
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    CLLocation* location = [[locations lastObject] locationMarsFromEarth];
    LOCATIONSERVICE_LOG(@"LOCATION6 %@ %@", NSStringFromSelector(_cmd), location);
    
    self.lastLocation = location;
    
    //NSTimeInterval dTime = [location.timestamp timeIntervalSinceDate:self.prevLocation.timestamp];
    //CLLocationDistance distance = [self.prevLocation distanceFromLocation:location];
    
    [self getLocation];
}




- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    LOCATIONSERVICE_LOG(@"%@ %@", NSStringFromSelector(_cmd), error);
//    CLLocation *fixLocation = [[CLLocation alloc] initWithLatitude:23.111873 longitude:113.277555];
//    self.lastLocation = fixLocation;
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    LOCATIONSERVICE_LOG(@"%@", NSStringFromSelector(_cmd));
}


- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    LOCATIONSERVICE_LOG(@"%@", NSStringFromSelector(_cmd));
}


- (void)postLocalNotificationWithMsg:(NSString*)msg fireDateSinceNow:(int)interval
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    localNotification.alertBody = msg;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark application life cycle

- (void)applicationWillTerminate:(UIApplication*)application
{

}

- (NSString*)filePathForLocations
{
    NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* filePath = [documentDir stringByAppendingPathComponent:@"location"];
    return filePath;
}

- (void)saveUploadLocation:(CLLocation*)location
{
#ifdef DEBUG
    NSArray* oldLocations = [self getUploadedLocations];
    NSMutableArray* locations = [NSMutableArray array];
    if (!oldLocations)
    {
        locations = [NSMutableArray arrayWithObject:location];
    }
    else
    {
        locations = [NSMutableArray arrayWithArray:oldLocations];
        [locations addObject:location];
    }
    
    [NSKeyedArchiver archiveRootObject:locations toFile:[self filePathForLocations]];
#endif
}

- (NSArray*)getUploadedLocations
{
#ifdef DEBUG
    NSArray* locations = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathForLocations]];
    if (!locations)
    {
        return [NSArray array];
    }
    else
    {
        return locations;
    }
#else
    return [NSArray array];
#endif
}

- (void)clearUploadedLocations
{
    [NSKeyedArchiver archiveRootObject:[NSArray array] toFile:[self filePathForLocations]];
}

-(NSString*)getNowTime
{
    NSDate* inputDate = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init] ;
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];//yyyy年MM月dd日 HH时mm分ss秒
    NSString *str = [outputFormatter stringFromDate:inputDate];
    return str;
}


- (void)getLocationCoordinate:(NSString*)locationName andBlock:(LocationServiceGerCoorBlock)block{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:locationName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error != nil || placemarks.count == 0) {
            //[AlertHelper showAlertWithTitle:@"没有找到对应的位置"];
            if (block) {
                block(CLLocationCoordinate2DMake(0, 0),@"");
            }
        }else{
            CLPlacemark *firstMark = [placemarks firstObject];
            if (block) {
                NSDictionary *addressDict = firstMark.addressDictionary;
                NSString *cityName = [addressDict safeStringForKey:@"City"];
                cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
                block(firstMark.location.coordinate,cityName);
            }
        }
    }];
}

- (void)getLocationName:(CLLocationCoordinate2D)coordinate andBlock:(LocationServiceGeoNameBlock)block{
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    //反向地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [revGeo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && [placemarks count] > 0)
        {
            NSDictionary *dict = [[placemarks objectAtIndex:0] addressDictionary];
            NSString *locationName = [dict safeStringForKey:@"Name"];
            if (block) {
                block(locationName);
            }
            
        }else{
            NSLog(@"ERROR: %@", error);
            if (block) {
                block(@"");
            }
        }
    }];
}



@end
