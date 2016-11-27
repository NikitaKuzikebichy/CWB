//
//  MasterViewController.h
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseInstanceID/FirebaseInstanceID.h>
@class DetailViewController;

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
// [START define_database_reference]
@property (strong, nonatomic) FIRDatabaseReference *ref;
// [END define_database_reference]
//@property (strong, nonatomic) FirebaseTableViewDataSource *dataSource;
@property (strong, nonatomic) DetailViewController *detailViewController;
@end
