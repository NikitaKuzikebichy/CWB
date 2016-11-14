//
//  CarPark.h
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

static NSString *CarParkIONOrchard = @"202A TAMPINES ST 21";
static NSString *CarParkTakashimaya = @"Takashimaya";
static NSString *CarParkGreatWorldCity = @"Great World City";
static NSString *CarParkParagon = @"Paragon";
static NSString *CarParkWismaAtria = @"Wisma Atria";
static NSString *CarParkSomerset = @"Somerset@313";
static NSString *CarParkPlaza = @"Plaza Singapura";
static NSString *CarParkCentrePoint = @"Centrepoint";
static NSString *CarParkShawLido = @"Shaw Lido";
static NSString *CarParkAmara = @"Amara Hotel";

typedef enum CarParkType
{
    CarParkTypeWater,
    CarParkTypeWaterAndVacuum,
    CarParkTypeVacuum,
}CarParkType;

@interface CarPark : PFObject <PFSubclassing>
{
}

@property (nonatomic, assign) int ID, lots, eta;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) float latitude, longitude, distance;
@property (nonatomic, assign) BOOL whetherCarWash, whetherValetParking, whetherSurePark;

- (id)initWithName:(NSString *)aName andId:(int)carParkId andEta:(int)aEta andLots:(int)aLots andLatitude:(float)aLatitude andLongitude:(float)aLongitude andWhetherCarWash:(BOOL)aWhetherCarWash andWhetherValetParking:(BOOL)aWhetherValetParking andWhetherSurePark:(BOOL)aWhetherSurePark;
- (NSString *) getDetailLabelText;  
- (NSString *) getOccupancyText;
- (NSComparisonResult)compareDistance:(CarPark *)otherObject;
- (UIColor *) getParkingAvailabilityColorForHours:(int) hours andWhetherHalfPast:(BOOL)whetherHalfPast;

+ (NSString *) parseClassName;
- (NSString *)name;
- (void) setName:(NSString *)name;
- (float) distanceFromCurrentLocation;
@end
