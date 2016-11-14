//
//  SPAnnotation.h
//  SmartParking
//
//  Created by Ashish Awaghad on 17/1/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CarPark.h"

@interface SPAnnotation : NSObject <MKAnnotation> {
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title, *subtitle;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) int carParkIndex;
@property (nonatomic, assign) CarPark *carPark;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle andColor:(UIColor *)aColor;

@end