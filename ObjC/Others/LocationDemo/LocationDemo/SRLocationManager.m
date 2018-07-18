
#import "SRLocationManager.h"
#import "SRUserDefaults.h"

NSString * const SRLocationManagerLocationServicesDisabled = @"LocationManagerLocationServicesDisabled";
NSString * const SRLocationManagerLocationServicesAuthorizationStatusDidChange = @"LocationManagerLocationServicesAuthorizationStatusDidChange";
NSString * const SRLocationManagerLocationServicesAuthorizationStatusDenied = @"LocationManagerLocationServicesAuthorizationStatusDenied";
NSString * const SRLocationManagerLocationServicesAuthorizationStatusAuthorized = @"LocationManagerLocationServicesAuthorizationStatusAuthorized";
NSString * const SRLocationManagerLocationServicesLocating = @"LocationManagerLocationServicesLocating";
NSString * const SRLocationManagerLocationSucceed = @"LocationManagerLocationSucceed";
NSString * const SRLocationManagerLocationFailed = @"LocationManagerLocationFailed";

#define SRCurrentLocationState     @"CurrentLocationState"
#define SRCurrentLocationCity      @"CurrentLocationCity"
#define SRCurrentLocationSubCity   @"CurrentLocationSubCity"
#define SRCurrentLocationLongitude @"CurrentLocationLongitude"
#define SRCurrentLocationLatitude  @"CurrentLocationLatitude"

@interface SRLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *location;

@end

@implementation SRLocationManager

@synthesize currentLocationState     = _currentLocationState;
@synthesize currentLocationCity      = _currentLocationCity;
@synthesize currentLocationSubCity   = _currentLocationSubCity;
@synthesize currentLocationLongitude = _currentLocationLongitude;
@synthesize currentLocationLatitude  = _currentLocationLatitude;

static SRLocationManager *instance;

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.0;
    }
    return _locationManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _authorizationType = SRLocationAuthorizationTypeWhenInUse;
    }
    return self;
}

- (void)requestAuthorization {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {    
        if ([CLLocationManager locationServicesEnabled]) {
            switch (self.authorizationType) {
                case SRLocationAuthorizationTypeWhenInUse:
                    [self.locationManager requestWhenInUseAuthorization];
                    break;
                case SRLocationAuthorizationTypeAlways:
                    [self.locationManager requestAlwaysAuthorization];
                    break;
            }
        } else {        
            if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesDisabled)]) {
                [self.delegate locationManagerLocationServicesDisabled];
            }
        }
    }
}

- (void)beginLocation {
    if (![CLLocationManager locationServicesEnabled]) {
        if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesDisabled)]) {
            [self.delegate locationManagerLocationServicesDisabled];
        }
        return;
    }
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesAuthorizationStatusDenied)]) {
                [self.delegate locationManagerLocationServicesAuthorizationStatusDenied];
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesAuthorizationStatusAuthorized)]) {
                [self.delegate locationManagerLocationServicesAuthorizationStatusAuthorized];
            }
            [self resetLocation];
            [self.locationManager startUpdatingLocation];
            if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesLocating)]) {
                [self.delegate locationManagerLocationServicesLocating];
            }
            break;
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    NSLog(@"locationManager didChangeAuthorizationStatus status: %zd", status);
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    if (![CLLocationManager locationServicesEnabled]) {
        if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesDisabled)]) {
            [self.delegate locationManagerLocationServicesDisabled];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesAuthorizationStatusDidChange)]) {
        [self.delegate locationManagerLocationServicesAuthorizationStatusDidChange];
    }
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusDenied:
        {
            if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesAuthorizationStatusDenied)]) {
                [self.delegate locationManagerLocationServicesAuthorizationStatusDenied];
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [self.locationManager startUpdatingLocation];
            if ([self.delegate respondsToSelector:@selector(locationManagerLocationServicesLocating)]) {
                [self.delegate locationManagerLocationServicesLocating];
            }
            break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (_location) {
        [self.locationManager stopUpdatingLocation];
        return;
    }
    _location = [locations firstObject];
    [self getAddress];
}

- (void)getAddress {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                       CLPlacemark *placemark = [placemarks firstObject];
                       CLLocation *location = placemark.location;
//                       CLRegion *region = placemark.region;
//                       NSDictionary *addressDic = placemark.addressDictionary;
                       self.currentLocationLongitude = @(location.coordinate.longitude);
                       self.currentLocationLatitude  = @(location.coordinate.latitude);
                       NSString *state = placemark.administrativeArea;
                       NSString *city = placemark.locality;
                       NSString *subCity = placemark.subLocality;
                       BOOL isChinese = NO;
                       for (int i = 0; i < city.length; i++) {
                           unichar character = [city characterAtIndex:i];
                           if (0x4e00 < character && character < 0x9fff) {
                               isChinese = YES;
                               break;
                           }
                       }
                       if (isChinese) {
                           state = [state substringToIndex:state.length -1];
                           city = [city substringToIndex:city.length -1];
                       }
//                       NSLog(@"State: %@", state);
//                       NSLog(@"City: %@", city);
//                       NSLog(@"SubCity: %@", subCity);
                       if (!city) {
                           if ([self.delegate respondsToSelector:@selector(locationManagerLocationFailed)]) {
                               [self.delegate locationManagerLocationFailed];
                           }
                           return;
                       }
                       NSString *previousSubCity = self.currentLocationSubCity;
                       self.currentLocationState = state;
                       self.currentLocationCity = city;
                       self.currentLocationSubCity = subCity;
                       if ([self.delegate respondsToSelector:@selector(locationManagerLocationSucceed)]) {
                           [self.delegate locationManagerLocationSucceed];
                       }
                       if ([self.delegate respondsToSelector:@selector(locationManagerLocationSucceedWithCity:)]) {
                           [self.delegate locationManagerLocationSucceedWithCity:subCity];
                       }
                       if ([self.delegate respondsToSelector:@selector(locationManagerLocationSucceedWithCity:lon:lat:)]) {
                           [self.delegate locationManagerLocationSucceedWithCity:subCity
                                                                             lon:self.currentLocationLongitude
                                                                             lat:self.currentLocationLatitude];
                       }
                       if ([self.delegate respondsToSelector:@selector(locationManagerLocationSucceedWithCity:previousCity:)]) {
                           [self.delegate locationManagerLocationSucceedWithCity:subCity previousCity:previousSubCity];
                       }
                   }];
}

- (void)resetLocation {
    _location = nil;
}

#pragma mark - City

- (NSString *)currentLocationCity {
    if (!_currentLocationCity) {
        _currentLocationCity = [SRUserDefaults objectForKey:SRCurrentLocationCity];
    }
    return _currentLocationCity;
}

- (void)setCurrentLocationCity:(NSString *)currentLocationCity {
    _currentLocationCity = currentLocationCity;
    
    [SRUserDefaults setObject:currentLocationCity forKey:SRCurrentLocationCity];
}

#pragma mark - SubCity

- (NSString *)currentLocationSubCity {
    if (!_currentLocationSubCity) {
        _currentLocationSubCity = [SRUserDefaults objectForKey:SRCurrentLocationSubCity];
    }
    return _currentLocationSubCity;
}

- (void)setCurrentLocationSubCity:(NSString *)currentLocationSubCity {
    _currentLocationSubCity = currentLocationSubCity;
    
    [SRUserDefaults setObject:currentLocationSubCity forKey:SRCurrentLocationSubCity];
}

#pragma mark - State

- (NSString *)currentLocationState {
    if (!_currentLocationState) {
        _currentLocationState = [SRUserDefaults objectForKey:SRCurrentLocationState];
    }
    return _currentLocationState;
}

- (void)setCurrentLocationState:(NSString *)currentLocationState {
    _currentLocationState = currentLocationState;
    
    [SRUserDefaults setObject:currentLocationState forKey:SRCurrentLocationState];
}

#pragma mark - Longitude

- (NSNumber *)currentLocationLongitude {
    if (!_currentLocationLongitude) {
        _currentLocationLongitude = [SRUserDefaults objectForKey:SRCurrentLocationLongitude];
    }
    return _currentLocationLongitude;
}

- (void)setCurrentLocationLongitude:(NSNumber *)currentLocationLongitude {
    _currentLocationLongitude = currentLocationLongitude;
    
    [SRUserDefaults setObject:currentLocationLongitude forKey:SRCurrentLocationLongitude];
}

#pragma mark - Latitude

- (NSNumber *)currentLocationLatitude {
    if (!_currentLocationLatitude) {
        _currentLocationLatitude = [SRUserDefaults objectForKey:SRCurrentLocationLatitude];
    }
    return _currentLocationLatitude;
}

- (void)setCurrentLocationLatitude:(NSNumber *)currentLocationLatitude {
    _currentLocationLatitude = currentLocationLatitude;
    
    [SRUserDefaults setObject:currentLocationLatitude forKey:SRCurrentLocationLatitude];
}

@end
