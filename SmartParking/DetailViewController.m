//
//  DetailViewController.m
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "PreBookViewControllerViewController.h"
#import "LotsAvailabilityCell.h"
#import "AppDelegate.h"
#import "RatesViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define NUMBER_OF_SECTIONS 3
#define AVAILABILE_SERVICES 0
#define CURRENT_SECTION_NUMBER 1
#define FUTURE_SECTION_NUMBER 2
#define PREBOOK_SECTION_NUMBER 3

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface DetailViewController ()
@property (nonatomic, strong) IBOutlet UIView *footerViewWithColorHelp;
@property (nonatomic, strong) IBOutlet UIView *greenViewInFooterView, *amberViewInFooterView, *redViewInFooterView;
@end

@implementation DetailViewController

@synthesize selectedCarPark = _selectedCarPark;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize timeArray, colorsArray, liveAvailability, tableView;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = [NSString stringWithFormat:@"Wash Bay @ %@", self.selectedCarPark.name];
    
    self.liveAvailability = @"Loading...";
    
    self.timeArray = [[NSMutableArray alloc] init];
    self.colorsArray = [[NSMutableArray alloc] init];

    [self.timeArray addObject:@"Loading..."];
    [self.colorsArray addObject:[UIColor clearColor]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        sleep(2);
        self.liveAvailability = @"61";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        sleep(4);

        self.liveAvailability = @"61";
        [self.timeArray removeAllObjects];
        [self.colorsArray removeAllObjects];

        NSDate *today = [NSDate date];
        NSDate *tempDate = [NSDate date];
        tempDate = [tempDate dateByAddingTimeInterval:1800];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd"];
        while ([[dateFormat stringFromDate:tempDate] isEqualToString:[dateFormat stringFromDate:today]]) {
            [dateFormat setDateFormat:@"HH"];
            NSString *dateString = [dateFormat stringFromDate:tempDate];
            NSLog(@"hours: %@", dateString);
            int hours = [dateString intValue];
            
            [dateFormat setDateFormat:@"mm"];
            dateString = [dateFormat stringFromDate:tempDate];
            NSLog(@"minutes: %@", dateString);
            int minutes = [dateString intValue];
            
            [dateFormat setDateFormat:@" a"];
            [self.timeArray addObject:[NSString stringWithFormat:@"%d:%02d%@", hours>12?hours%12:hours, (minutes/30)*30, [dateFormat stringFromDate:tempDate]]];
            [self.colorsArray addObject:[self.selectedCarPark getParkingAvailabilityColorForHours:hours andWhetherHalfPast:minutes>29]];
            tempDate = [tempDate dateByAddingTimeInterval:1800];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
    if (!self.selectedCarPark.whetherSurePark) {
        self.prebookButton.enabled = false;
        self.prebookButton.alpha = 0.5;
    }
    
    [self.footerViewWithColorHelp setBackgroundColor:[UIColor clearColor]];
    [self.redViewInFooterView setBackgroundColor:[AppDelegate getRedColor]];
    [self.greenViewInFooterView setBackgroundColor:[AppDelegate getGreenColor]];
    [self.amberViewInFooterView setBackgroundColor:[AppDelegate getAmberColor]];

    CALayer *layer = [self.redViewInFooterView layer];
    [layer setCornerRadius:3.0];
    [layer setMasksToBounds:YES];
    layer = [self.greenViewInFooterView layer];
    [layer setCornerRadius:3.0];
    [layer setMasksToBounds:YES];
    layer = [self.amberViewInFooterView layer];
    [layer setCornerRadius:3.0];
    [layer setMasksToBounds:YES];

    UIView *view = [[UIView alloc] init];
    //[view setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:204.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    [self.tableView setBackgroundView:view];
    
    [self.ratesButton setBackgroundColor:[UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0]];
    layer = [self.ratesButton layer];
    [layer setCornerRadius:3.0];
    [layer setMasksToBounds:YES];
    
    [self.routeButton setBackgroundColor:[UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0]];
    layer = [self.routeButton layer];
    [layer setCornerRadius:3.0];
    [layer setMasksToBounds:YES];
    
    [self.prebookButton setBackgroundColor:[UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0]];
    layer = [self.prebookButton layer];
    [layer setCornerRadius:3.0];
    [layer setMasksToBounds:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
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
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == AVAILABILE_SERVICES) {
        return [_selectedCarPark[@"hasWater"] boolValue] + [_selectedCarPark[@"hasVacuum"] boolValue] + [_selectedCarPark[@"hasJet"] boolValue];
    }
    if (section == CURRENT_SECTION_NUMBER) {
        return 1;
    }
    else if (section == FUTURE_SECTION_NUMBER) {
        return [timeArray count];
    }
    if (section == PREBOOK_SECTION_NUMBER) {
        return ([timeArray count]>0)?1:0;
    }
    
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == AVAILABILE_SERVICES) {
        return [NSString stringWithFormat:@"Services on %@:", _selectedCarPark[@"machineType"]];
    }
    if (section == CURRENT_SECTION_NUMBER) {
        return @"Currently Available BAYS:";
    }
    else if (section == FUTURE_SECTION_NUMBER) {
        return @"Predicted Availability of Lots:";
    }
    return @"";
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == FUTURE_SECTION_NUMBER) {
        return self.footerViewWithColorHelp;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == FUTURE_SECTION_NUMBER) {
        return 70.0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == AVAILABILE_SERVICES) {
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"ServicesAvailabilityCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServicesAvailabilityCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 0, 100, 44);
            [button setTitle:@"Activate" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(activateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = button;
        }
        
        cell.accessoryView.tag = indexPath.row;

        if (indexPath.row == 0) {
            if ([_selectedCarPark[@"hasWater"] boolValue]) {
                cell.textLabel.text = [NSString stringWithFormat:@"%d cents for %@", [_selectedCarPark[@"WaterCents"] intValue], _selectedCarPark[@"waterAmount"]];
                cell.imageView.image = [UIImage imageNamed:@"Water_icon"];
            }
        }
        else if (indexPath.row == 1) {
            if ([_selectedCarPark[@"hasWater"] boolValue]) {
                if ([_selectedCarPark[@"hasVacuum"] boolValue]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"$%g for %@", [_selectedCarPark[@"VacuumDollar"] floatValue], _selectedCarPark[@"vacuumAmount"] ];
                    cell.imageView.image = [UIImage imageNamed:@"Vacuum_icon"];
                }
            }
            else {
                if ([_selectedCarPark[@"hasJet"] boolValue]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"$%g for %@", [_selectedCarPark[@"jetDollar"] floatValue], _selectedCarPark[@"jetAmount"]];
                    cell.imageView.image = [UIImage imageNamed:@"Jet_icon"];
                }
            }
        }
        else {
            if ([_selectedCarPark[@"hasJet"] boolValue]) {
                cell.textLabel.text = [NSString stringWithFormat:@"$%g for %@", [_selectedCarPark[@"jetDollar"] floatValue], _selectedCarPark[@"jetAmount"]];
                cell.imageView.image = [UIImage imageNamed:@"Jet_icon"];
            }
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", self.selectedCarPark.lots];
        
        return cell;
    }

    if (indexPath.section == CURRENT_SECTION_NUMBER) {
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"CurrentAvailabilityCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CurrentAvailabilityCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"Current Availability";
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [self.selectedCarPark[@"availableBays"] intValue]];
        
        return cell;
    }
    
    else if (indexPath.section == FUTURE_SECTION_NUMBER) {
        LotsAvailabilityCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"LotsAvailabilityCell"];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LotsAvailabilityCell" owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CALayer *layer = [cell.colorView layer];
            [layer setCornerRadius:3.0];
            [layer setMasksToBounds:YES];
        }
        
        cell.timeLabel.text = [self.timeArray objectAtIndex:indexPath.row];
        [cell.colorView setBackgroundColor:[self.colorsArray objectAtIndex:indexPath.row]];

        return cell;
    }
    
    else if (indexPath.section == PREBOOK_SECTION_NUMBER) {
//        UITableViewCell *cell1 = [aTableView dequeueReusableCellWithIdentifier:@"PrebookCell"];
//        
//        if (cell1 == nil) {
//            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrebookCell"];
//        }
//        
//        cell1.textLabel.text = @"Prebook";
//        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        
//        return cell1;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
}

- (void) activateButtonTapped:(UIButton *)sender {
    sender.enabled = false;
    NSString *device = @"w";
    if (sender.tag == 0) {
        if ([_selectedCarPark[@"hasWater"] boolValue]) {
        }
    }
    else if (sender.tag == 1) {
        if ([_selectedCarPark[@"hasWater"] boolValue]) {
            if ([_selectedCarPark[@"hasVacuum"] boolValue]) {
                device = @"v";
            }
        }
        else {
            if ([_selectedCarPark[@"hasJet"] boolValue]) {
                device = @"j";
            }
        }
    }
    else {
        if ([_selectedCarPark[@"hasJet"] boolValue]) {
            device = @"j";
        }
    }

    
    PFPush *push = [[PFPush alloc] init];
    

    [push setMessage:[NSString stringWithFormat:@"%@,%@", _selectedCarPark.objectId, device]];
    NSLog(@"%@", [NSString stringWithFormat:@"%@,%@", _selectedCarPark.objectId, device]);
    NSError *error = nil;
    [push sendPush:&error];
    
    if (error == nil) {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Activation sent." message:@"Please wait for a few seconds." preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller
                       animated:true completion:nil];
    }
    else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controller
                           animated:true completion:nil];
    }
    sender.enabled = true;
}

- (void) preBookButtonClicked:(UIButton *) sender
{
    PreBookViewControllerViewController *prebookVC = [[PreBookViewControllerViewController alloc] initWithNibName:@"PreBookViewControllerViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:prebookVC animated:YES];
}

- (IBAction) routesButtonClicked:(UIButton *) sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%1.6f,%1.6f&saddr=%1.6f,%1.6f", self.selectedCarPark.latitude,self.selectedCarPark.longitude, [AppDelegate getAppDelegate].location.coordinate.latitude, [AppDelegate getAppDelegate].location.coordinate.longitude];
        NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    else {
        NSString* addr = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=%1.6f,%1.6f", self.selectedCarPark.latitude,self.selectedCarPark.longitude, [AppDelegate getAppDelegate].location.coordinate.latitude, [AppDelegate getAppDelegate].location.coordinate.longitude];
        NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction) ratesButtonClicked:(UIButton *) sender
{
    RatesViewController *ratesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RatesViewController"];
    [self.navigationController pushViewController:ratesViewController animated:YES];
}

@end
