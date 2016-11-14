//
//  SPAnnotation.m
//  SmartParking
//
//  Created by Ashish Awaghad on 17/1/13.
//
//

#import "SPAnnotation.h"

@implementation SPAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle andColor:(UIColor *)aColor {
    if ((self = [super init])) {
        self.coordinate = aCoordinate;
        self.title = aTitle;
        self.subtitle = aSubtitle;
        self.color = aColor;
    }
    
    return self;
}

@end
