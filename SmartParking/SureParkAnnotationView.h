//
//  SureParkAnnotationView.h
//  SmartParking
//
//  Created by Ashish Awaghad on 19/1/13.
//
//

#import <MapKit/MapKit.h>
@class CarPark;

@interface SureParkAnnotationView : MKAnnotationView
{
}

- (void) setCarPark:(CarPark *)carPark;

@end