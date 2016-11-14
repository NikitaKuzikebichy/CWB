//
//  DetailViewController.h
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarPark.h"

@interface DetailViewController : UIViewController
{
    NSMutableArray *timeArray, *availabilityArray;
    NSString *liveAvailability;
    UITableView *tableView;
}

@property (strong, nonatomic) NSMutableArray *timeArray, *colorsArray;
@property (strong, nonatomic) NSString *liveAvailability;
@property (strong, nonatomic) CarPark *selectedCarPark;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *prebookButton, *routeButton, *ratesButton;

- (IBAction) preBookButtonClicked:(UIButton *) sender;
- (IBAction) routesButtonClicked:(UIButton *) sender;
- (IBAction) ratesButtonClicked:(UIButton *) sender;

@end
