//
//  SureParkAnnotationView.m
//  SmartParking
//
//  Created by Ashish Awaghad on 19/1/13.
//
//

#import "SureParkAnnotationView.h"
#import "SPAnnotation.h"
#import "AppDelegate.h"

@interface SureParkAnnotationView()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation SureParkAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cwb_icon"]];
        [self addSubview:_imageView];
    }
    return self;
}

- (void) setCarPark:(CarPark *)carPark
{
    //    if ([carPark[@"hasWater"] boolValue] && [carPark[@"hasVacuum"] boolValue] && [carPark[@"hasJet"] boolValue]) {
    //        _imageView.image = [UIImage imageNamed:@"cwb_icon_all"];
    //    }
    //    else if([carPark[@"hasWater"] boolValue] && [carPark[@"hasVacuum"] boolValue]) {
    //        _imageView.image = [UIImage imageNamed:@"cwb_icon_water_vacuum"];
    //    }
    //    else if([carPark[@"hasWater"] boolValue] && [carPark[@"hasJet"] boolValue]) {
    //        _imageView.image = [UIImage imageNamed:@"cwb_icon_water_jet"];
    //    }
    //    else if([carPark[@"hasVacuum"] boolValue] && [carPark[@"hasJet"] boolValue]) {
    //        _imageView.image = [UIImage imageNamed:@"cwb_icon_vacuum_jet"];
    //    }
    //    else if([carPark[@"hasWater"] boolValue]) {
    //        _imageView.image = [UIImage imageNamed:@"cwb_icon_water"];
    //    }
    //    else if([carPark[@"hasVacuum"] boolValue]) {
    //        _imageView.image = [UIImage imageNamed:@"cwb_icon_vacuum"];
    //    }
    //    else if([carPark[@"hasJet"] boolValue]) {
    //        _imageView.image = [UIImage imageNamed:@"cwb_icon_jet"];
    //    }
}

- (void) layoutSubviews{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cwb_icon"]];
        [self addSubview:_imageView];
        
    }
    _imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

/*- (void) drawRect: (CGRect) rect
 {
 [super drawRect:rect];
 CGContextRef ctx = UIGraphicsGetCurrentContext();
 UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4.0];
 
 //CGContextSetFillColorWithColor(ctx, [[UIColor purpleColor] CGColor]);
 CGContextSetFillColorWithColor(ctx, [((SPAnnotation *)self.annotation).color CGColor]); //setting color of box
 CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);  //setting color of box border
 CGContextSetLineWidth(ctx, 2.0); //setting width of box border
 [aPath fill];
 [aPath stroke];
 CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
 CGFloat fontSize = 12.0;
 //CGFloat fontSize = 25.0;
 
 SPAnnotation *annotation = self.annotation;
 
 NSString *typeString = @"";
 
 if (annotation.carPark.ID == CarParkTypeWater) {
 typeString = @"\nW";
 }
 else if (annotation.carPark.ID == CarParkTypeVacuum) {
 typeString = @"\nV";
 }
 else if (annotation.carPark.ID == CarParkTypeWaterAndVacuum) {
 typeString = @"\nW V";
 }
 //    [[@"CWB" stringByAppendingString:typeString] drawInRect:rect withFont:[UIFont boldSystemFontOfSize:fontSize]];
 [@"CWB" drawInRect:rect withFont:[UIFont boldSystemFontOfSize:fontSize]];
 //[@" P" drawInRect:rect withFont:[UIFont boldSystemFontOfSize:fontSize]];
 }*/

@end
