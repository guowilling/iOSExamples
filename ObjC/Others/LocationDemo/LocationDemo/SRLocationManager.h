
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, SRLocationAuthorizationType) {
    SRLocationAuthorizationTypeAlways,
    SRLocationAuthorizationTypeWhenInUse,
};

extern NSString * const HSLocationManagerLocationServicesDisabled;
extern NSString * const HSLocationManagerLocationServicesAuthorizationStatusDidChange;
extern NSString * const HSLocationManagerLocationServicesAuthorizationStatusDenied;
extern NSString * const HSLocationManagerLocationServicesAuthorizationStatusAuthorized;
extern NSString * const HSLocationManagerLocationServicesLocating;
extern NSString * const HSLocationManagerLocationSucceed;
extern NSString * const HSLocationManagerLocationFailed;

@protocol SRLocationManagerDelegate <NSObject>

@optional
- (void)locationManagerLocationServicesDisabled;
- (void)locationManagerLocationServicesAuthorizationStatusDidChange;
- (void)locationManagerLocationServicesAuthorizationStatusDenied;
- (void)locationManagerLocationServicesAuthorizationStatusAuthorized;
- (void)locationManagerLocationServicesLocating;
- (void)locationManagerLocationSucceed;
- (void)locationManagerLocationSucceedWithCity:(NSString *)city;
- (void)locationManagerLocationSucceedWithCity:(NSString *)city lon:(NSNumber *)lon lat:(NSNumber *)lat;
- (void)locationManagerLocationSucceedWithCity:(NSString *)city previousCity:(NSString *)previousCity;
- (void)locationManagerLocationFailed;

@end

@interface SRLocationManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak) id<SRLocationManagerDelegate> delegate;

@property (nonatomic, strong, readonly) NSNumber *currentLocationLongitude;
@property (nonatomic, strong, readonly) NSNumber *currentLocationLatitude;

@property (nonatomic, copy  , readonly) NSString *currentLocationState;
@property (nonatomic, copy  , readonly) NSString *currentLocationCity;
@property (nonatomic, copy  , readonly) NSString *currentLocationSubCity;

/// Default is SRLocationAuthorizationTypeWhenInUse.
@property (nonatomic, assign) SRLocationAuthorizationType authorizationType;

- (void)requestAuthorization;

- (void)beginLocation;

@end
