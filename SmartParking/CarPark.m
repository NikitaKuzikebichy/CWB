//
//  CarPark.m
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CarPark.h"
#import "AppDelegate.h"

@implementation CarPark

@synthesize ID, lots, eta, whetherCarWash, whetherSurePark, whetherValetParking, distance, description, debugDescription, color, carparkArray;

- (id) init
{
    if (self = [super init]) {
        self.ID = 4;
        self.eta = 20;
        self.lots = 200;
    }
    
    return self;
}

+ (NSString *) parseClassName
{
    return @"CarWashBay";
}

- (id)initWithName:(NSString *)aName andId:(int)carParkId andEta:(int)aEta andLots:(int)aLots andLatitude:(float)aLatitude andLongitude:(float)aLongitude andWhetherCarWash:(BOOL)aWhetherCarWash andWhetherValetParking:(BOOL)aWhetherValetParking andWhetherSurePark:(BOOL)aWhetherSurePark
{
    if ((self = [super init])) {
        self.name = aName;
        self.ID = 4;//carParkId;
        self.eta = 20;//aEta;
        self.lots = 200;//aLots;
        self.latitude = aLatitude;
        self.longitude = aLongitude;
        self.whetherCarWash = aWhetherCarWash;
        self.whetherValetParking = aWhetherValetParking;
        self.whetherSurePark = aWhetherSurePark;
        self.distance = 0.0;
        self.carparkArray = [[NSMutableArray alloc] init];
        
        [[AppDelegate getAppDelegate] addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}


- (float) latitude
{
    //    PFGeoPoint *geoPoint = (PFGeoPoint *)self[@"locationG"];
    //    return geoPoint.latitude;
    float rr = _latitude;
    return rr;
}

- (float) longitude
{
    //    return ((PFGeoPoint *)self[@"locationG"]).longitude;
    return _longitude;
}

//- (void) setLongitude:(float)longitude{
//
//}
//
//- (void) setLatitude:(float)longitude{
//
//}
- (NSString *)name
{
    //    return [NSString stringWithFormat:@"%@ %@", self[@"blkNo"], self[@"stName"]];
    
    NSString* strReturn = @"";
    NSString* strBlkNo = @"";
    NSString* strName = @"";
    for (int i = 0; i < [carparkArray count]; i++ )
    {
        NSMutableDictionary* dictionary = (NSMutableDictionary*)[carparkArray objectAtIndex:i];
        if (dictionary != nil)
        {
            if (dictionary[@"blkNo"])
            {
                strBlkNo = dictionary[@"blkNo"];
            }
            if (dictionary[@"stName"])
            {
                strName = dictionary[@"stName"];
            }
        }
    }
    strReturn = [NSString stringWithFormat:@"%@ %@", strBlkNo, strName];
    
    return strReturn;
}

- (void) setName:(NSString *)name
{
    //    self[@"stName"] = name;
    for (int i = 0; i < [carparkArray count]; i++ )
    {
        NSMutableDictionary* dictionary = (NSMutableDictionary*)[carparkArray objectAtIndex:i];
        if (dictionary != nil)
        {
            if (dictionary[@"stName"])
            {
                dictionary[@"stName"] = name;
            }
        }
    }
}

- (NSString *) description {
    NSString* strNama = self.name;
    return strNama;
}


- (NSString *) getOccupancyText {
    //    NSString *occupancyText = [NSString stringWithFormat:@"%@ %d wash bays", self[@"machineType"], [self[@"noOfWashBays"] intValue]];
    
    //    return occupancyText;
    NSString* strReturn = @"";
    NSString* strMachine = @"";
    NSString* strNoOfWashBays = @"";
    for (int i = 0; i < [carparkArray count]; i++ )
    {
        NSMutableDictionary* dictionary = (NSMutableDictionary*)[carparkArray objectAtIndex:i];
        if (dictionary != nil)
        {
            if (dictionary[@"machineType"])
            {
                strMachine = dictionary[@"machineType"];
            }
            if (dictionary[@"noOfWashBays"])
            {
                strNoOfWashBays = dictionary[@"noOfWashBays"];
            }
        }
    }
    strReturn = [NSString stringWithFormat:@"%@ %@ wash bays", strMachine, strNoOfWashBays];
    return strReturn;
    
}

- (NSString *) getDetailLabelText {
    return [NSString stringWithFormat:@"Available Lots: %d", self.lots];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"location"]) {
        CLLocation *location = (CLLocation *)[change objectForKey:NSKeyValueChangeNewKey];
        if (location != NULL) {
            self.distance = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude]];
            self.distance /= 1000;
        }
    }
}

- (CLLocation *) location
{
    return [[CLLocation alloc] initWithLatitude:[self latitude] longitude:[self longitude]];
}

- (float) distanceFromCurrentLocation
{
    float dist = [[AppDelegate getAppDelegate].location distanceFromLocation:[self location]];
    return dist/1000;
}

- (NSComparisonResult)compareDistance:(CarPark *)otherObject {
    return [[AppDelegate getAppDelegate].location distanceFromLocation:[self location]] > [[AppDelegate getAppDelegate].location distanceFromLocation:[otherObject location]];
}

- (void) dealloc {
    [[AppDelegate getAppDelegate] removeObserver:self forKeyPath:@"location"];
}

- (UIColor *) getParkingAvailabilityColorForHours:(int) hours andWhetherHalfPast:(BOOL) whetherHalfPast {
    //NSLog(@"Hours: %d, WhetherHalfPast:%@", hours, whetherHalfPast?@"True":@"False");
    UIColor *returnColor = [UIColor greenColor];
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"hours: %@", dateString);
    int hoursNow = [dateString intValue];
    
    [dateFormat setDateFormat:@"mm"];
    dateString = [dateFormat stringFromDate:today];
    NSLog(@"minutes: %@", dateString);
    int minutesNow = [dateString intValue];
    
    BOOL whetherCurrentTime = false;
    if (hours == hoursNow && (minutesNow>29)==whetherHalfPast) {
        whetherCurrentTime = true;
    }
    
    if ([self.name isEqualToString:CarParkAmara]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 207;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 90;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 123;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkCentrePoint]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 212;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 47;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 103;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkGreatWorldCity]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 747;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 145;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 349;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkIONOrchard]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 203;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 17;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 125;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkParagon]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 11:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 12:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
            case 13:
            case 14:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
            case 15:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 16:
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            case 19:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 237;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 23;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 176;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkPlaza]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 12:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 13:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 14:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 15:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 16:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 22:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 386;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 6;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 213;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkShawLido]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 414;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 89;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 168;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkSomerset]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 188;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 32;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 113;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkTakashimaya]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 487;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 99;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 316;
            }
        }
    }
    else if ([self.name isEqualToString:CarParkWismaAtria]) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            case 18:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 19:
            case 20:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getRedColor];
                }
                else {
                    returnColor = [AppDelegate getRedColor];
                }
            }
                break;
                
            case 21:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getAmberColor];
                }
                else {
                    returnColor = [AppDelegate getAmberColor];
                }
            }
                break;
                
            case 22:
            case 23:
            {
                if (whetherHalfPast) {
                    returnColor = [AppDelegate getGreenColor];
                }
                else {
                    returnColor = [AppDelegate getGreenColor];
                }
            }
                break;
                
            default:
                returnColor = [AppDelegate getGreenColor];
                break;
        }
        
        if (whetherCurrentTime) {
            if ([returnColor isEqual:[AppDelegate getGreenColor]]) {
                self.lots = 217;
            }
            else if ([returnColor isEqual:[AppDelegate getRedColor]]) {
                self.lots = 56;
            }
            else if ([returnColor isEqual:[AppDelegate getAmberColor]]) {
                self.lots = 110;
            }
        }
    }
    //below comment function> returnColor sets constant>
    //self.color = [AppDelegate getRedColor];
    self.color = returnColor;
    return returnColor;
}

@end
