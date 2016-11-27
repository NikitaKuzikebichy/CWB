//
//  MasterViewController.m
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 SurePark does what it says. It assures your parking lot! You prebook it before going to the mall and don't have to worry about finding a lot when you reach the carpark. Simple as that.
 */

#import "MasterViewController.h"
#import "CarPark.h"

#import "DetailViewController.h"
#import "SPAnnotation.h"
#import "SureParkAnnotationView.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "CarParkCell.h"
#import "PreBookViewControllerViewController.h"
//#import <Parse/Parse.h>

@interface MasterViewController () {
    NSMutableArray *_carParks;
    NSMutableArray* carParksUnsorted;
    BOOL whetherFirstLocationUpdate;
    BOOL whetherMapBeingShown;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (strong, nonatomic) CLLocationManager *manager;

- (IBAction)toggleListMap:(id)sender;
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    UIImageView *imgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cwbsolutionsblack"]];
    imgeView.contentMode = UIViewContentModeScaleAspectFit;
    imgeView.frame = CGRectMake(0, 0, 200, 44);
    
    
    
    //    self.navigationItem.title = @"CWB Solutions";
    self.navigationItem.titleView=imgeView;
    [self reloadAnnotationViews];
}

- (void) reloadAnnotationViews {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"hours: %@", dateString);
    int hours = [dateString intValue];
    
    [dateFormat setDateFormat:@"mm"];
    dateString = [dateFormat stringFromDate:today];
    NSLog(@"minutes: %@", dateString);
    int minutes = [dateString intValue];
    
    NSArray *annotations = [self.mapView annotations];
    
    for (SPAnnotation *annotation in annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    int i=0;
    for (CarPark *carPark in carParksUnsorted) {
        SPAnnotation *spAnnotation = [[SPAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(carPark.latitude, carPark.longitude) andTitle:carPark.name andSubtitle:[carPark getDetailLabelText] andColor:[carPark getParkingAvailabilityColorForHours:hours andWhetherHalfPast:(minutes > 29)]];
        spAnnotation.subtitle = [carPark getOccupancyText];
        spAnnotation.carParkIndex = i;
        spAnnotation.carPark = carPark;
        [self.mapView addAnnotation:spAnnotation];
        
        i++;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    [_manager requestWhenInUseAuthorization];
    [_manager startUpdatingLocation];
    
    [[self.mapView layer] setMasksToBounds:NO];
    [[self.mapView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[self.mapView layer] setShadowOpacity:1.0f];
    [[self.mapView layer] setShadowRadius:6.0f];
    [[self.mapView layer] setShadowOffset:CGSizeMake(20, 20)];
    
    self.navigationController.navigationBar.tintColor = [UIColor cwbYellowColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    self.rightBarButtonItem.tintColor = [UIColor cwbYellowColor];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refresh) userInfo:nil repeats:true];
    [timer fire];
}


- (void) refresh {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    // This type of listener is not one time, and you need to cancel it to stop
    // receiving updates.
    [[[ref child:@"CarWashBay"] queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        
        
        NSMutableDictionary* snapshotArray = [[NSMutableDictionary alloc] init];
        snapshotArray = snapshot.value;
        
        
        
        if (_carParks != nil)
        {
            
        }
        else
        {
            _carParks = [[NSMutableArray alloc] init];
            for (int i = 0; i < [snapshotArray count]; i++)
            {
                NSMutableDictionary* objArray = snapshotArray[[NSString stringWithFormat:@"object %d", i+1]];
                CarPark* ourCarParks = [[CarPark alloc] initWithName:objArray[@"stName"]
                                                               andId:i+1
                                                              andEta:0
                                                             andLots:0
                                                         andLatitude:[objArray[@"locationGlatitude"] floatValue]
                                                        andLongitude:[objArray[@"locationGlongitude"] floatValue]
                                                   andWhetherCarWash:NO
                                              andWhetherValetParking:NO
                                                  andWhetherSurePark:NO];
                [ourCarParks.carparkArray addObject:objArray];
                [_carParks addObject:ourCarParks];
            }
        }
        
        
        
        [self.tableView reloadData];
        
        carParksUnsorted = _carParks;//[[NSMutableArray alloc] initWithArray:_carParks];
        
        whetherFirstLocationUpdate = YES;
        whetherMapBeingShown = YES;
        
        [[AppDelegate getAppDelegate] addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew context:NULL];
        
        self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(1.3042, 103.834444), MKCoordinateSpanMake(0.5, 0.3));
        
        
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
        
        [self.tableView setBackgroundView:view];
        [self reloadAnnotationViews];
        
    }];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"location"]) {
        if (whetherFirstLocationUpdate) {
            self.mapView.showsUserLocation = YES;
            [self.mapView setRegion:MKCoordinateRegionMake([AppDelegate getAppDelegate].locationManager.location.coordinate, MKCoordinateSpanMake(0.05, 0.03)) animated:YES];
            whetherFirstLocationUpdate = false;
        }
        [_carParks sortUsingSelector:@selector(compareDistance:)];
        [self.tableView reloadData];
    }
}

- (void)viewDidUnload
{
    [[AppDelegate getAppDelegate] removeObserver:self forKeyPath:@"location"];
    [self setTableView:nil];
    [self setMapView:nil];
    [self setRightBarButtonItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _carParks.count + 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CarParkCell *cellTmp = (CarParkCell *)cell;
    
    if (indexPath.row == 0) {
        cellTmp.prebookButton.hidden = YES;
        
        return;
    }
    CarPark *carPark = (CarPark *)[_carParks objectAtIndex:indexPath.row-1];
    
    cellTmp.firstImage.image = nil;
    cellTmp.secondImage.image = nil;
    cellTmp.thirdImage.image = nil;
    
    NSMutableDictionary* dictionary = [carPark.carparkArray objectAtIndex:0];
    if ([dictionary[@"hasWater"] boolValue]) {
        
        cellTmp.firstImage.image = [UIImage imageNamed:@"Water_icon"];
        if ([dictionary[@"hasVacuum"] boolValue]) {
            cellTmp.secondImage.image = [UIImage imageNamed:@"Vacuum_icon"];
            if ([dictionary[@"hasJet"] boolValue]) {
                cellTmp.thirdImage.image = [UIImage imageNamed:@"Jet_icon"];
            }
        }
        else if ([dictionary[@"hasJet"] boolValue]) {
            cellTmp.secondImage.image = [UIImage imageNamed:@"Jet_icon"];
        }
    }
    else if ([dictionary[@"hasVacuum"] boolValue]) {
        cellTmp.firstImage.image = [UIImage imageNamed:@"Vacuum_icon"];
        if ([dictionary[@"hasJet"] boolValue]) {
            cellTmp.secondImage.image = [UIImage imageNamed:@"Jet_icon"];
        }
    }
    else if ([dictionary[@"hasJet"] boolValue]) {
        cellTmp.firstImage.image = [UIImage imageNamed:@"Jet_icon"];
    }
    
    
    if (!carPark.whetherSurePark) {
        cellTmp.prebookButton.hidden = YES;
    }
    else {
        cellTmp.prebookButton.hidden = false;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarParkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarParkCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarParkCell" owner:self options:nil] objectAtIndex:0];
        
        [cell.prebookButton setBackgroundImage:[UIImage imageNamed:@"prebookArrowImage.png"] forState:UIControlStateNormal];
        [cell.prebookButton setBackgroundImage:[UIImage imageNamed:@"prebookArrowImageHighlighted.png"] forState:UIControlStateHighlighted];
        
        //        CALayer *layer = cell.prebookButton.layer;
        //[layer setCornerRadius:3.0];
        //        [layer setBorderColor:[UIColor blackColor].CGColor];
        //        [layer setBorderWidth:1.0];
        //        [layer setMasksToBounds:YES];
        
        [cell.prebookButton addTarget:self action:@selector(preBookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"Carpark";
        cell.availableLotsLabel.text = @"Bays";
        [cell.availableLotsLabel setTextColor:[UIColor blackColor]];
        cell.distanceLabel.text = @"Dist.";
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row % 2 == 0) {
            //        [cell setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:204.0/255.0 blue:185.0/255.0 alpha:1.0]];
            [cell setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:206.0/255.0 alpha:1.0]];
        }
        else {
            [cell setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:214.0/255.0 alpha:1.0]];
        }
        
        return cell;
    }
    
    CarPark *carPark = (CarPark *)[_carParks objectAtIndex:indexPath.row-1];
    NSMutableDictionary* dictionary = [carPark.carparkArray objectAtIndex:0];
    NSString *name = carPark.name;
    cell.nameLabel.text = name;
    cell.availableLotsLabel.text = [NSString stringWithFormat:@"%d", [dictionary[@"noOfWashBays"] intValue]];
    [cell.availableLotsLabel setTextColor:carPark.color];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f km", [carPark distanceFromCurrentLocation]];
    
    if (indexPath.row % 2 == 0) {
        //        [cell setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:204.0/255.0 blue:185.0/255.0 alpha:1.0]];
        [cell setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:206.0/255.0 alpha:1.0]];
    }
    else {
        [cell setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:214.0/255.0 alpha:1.0]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //CarPark *carPark = (CarPark *)[_carParks objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        return 44.0;
    }
    //    if (!carPark.whetherSurePark) {
    //        return 44.0;
    //    }
    return 95.0;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//
//}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Hi %@, Please select a carpark:", [[AppDelegate getAppDelegate].loggedInUserName length]>0?[AppDelegate getAppDelegate].loggedInUserName:@"User"];
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailViewController.selectedCarPark = [_carParks objectAtIndex:indexPath.row-1];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setSelectedCarPark:[_carParks objectAtIndex:indexPath.row-1]];
    }
}

- (void)preBookButtonClicked:(UIButton *)sender {
    PreBookViewControllerViewController *prebookVC = [[PreBookViewControllerViewController alloc] initWithNibName:@"PreBookViewControllerViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:prebookVC animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    else {
        SPAnnotation *spAnnotation = (SPAnnotation *)annotation;
        SureParkAnnotationView *annotationView = [[SureParkAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"SureParkAnnotationView"];
        [annotationView setFrame:CGRectMake(0, 0, 30, 30)];
        [annotationView setBackgroundColor:[UIColor clearColor]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        button.frame = CGRectMake(0, 0, 23, 23);
        [button addTarget:self action:@selector(rightCalloutAccessoryViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = spAnnotation.carParkIndex;
        annotationView.rightCalloutAccessoryView = button;
        [annotationView setCarPark:spAnnotation.carPark];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
}

- (void) rightCalloutAccessoryViewClicked:(UIButton *)sender {
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailViewController.selectedCarPark = [carParksUnsorted objectAtIndex:sender.tag];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)toggleListMap:(id)sender {
    if (whetherMapBeingShown) {
        self.mapView.hidden = YES;
        self.tableView.hidden = false;
        [self.rightBarButtonItem setTitle:@"Map"];
    }
    else {
        self.mapView.hidden = false;
        self.tableView.hidden = YES;
        [self.rightBarButtonItem setTitle:@"List"];
    }
    whetherMapBeingShown = !whetherMapBeingShown;
    [self reloadAnnotationViews];
}

- (void) dealloc {
    [[AppDelegate getAppDelegate] removeObserver:self forKeyPath:@"location"];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //also you may add any fancy condition-based code here
    return UIStatusBarStyleLightContent;
}


@end

