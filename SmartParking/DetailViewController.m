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

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFURLRequestSerialization.h>

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
    NSMutableDictionary* dictionary = [_selectedCarPark.carparkArray objectAtIndex:0];
    if (section == AVAILABILE_SERVICES) {
        int nHasWater = 0;
        int nHasVacuum = 0;
        int nHasJet = 0;
        if ([dictionary[@"hasWater"]  isEqual: @"true"])
        {
            nHasWater = 1;
        }
        if ([dictionary[@"hasVacuum"]  isEqual: @"true"])
        {
            nHasVacuum = 1;
        }
        if ([dictionary[@"hasJet"]  isEqual: @"true"])
        {
            nHasJet = 1;
        }
        return nHasWater + nHasVacuum + nHasJet;
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
    NSMutableDictionary* dictionary = [_selectedCarPark.carparkArray objectAtIndex:0];
    if (section == AVAILABILE_SERVICES) {
        return [NSString stringWithFormat:@"Services on %@:", dictionary[@"machineType"]];
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
    NSMutableDictionary* dictionary = [_selectedCarPark.carparkArray objectAtIndex:0];
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
            if ([dictionary[@"hasWater"] isEqualToString:@"true"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"%d cents for %@", [dictionary[@"WaterCents"] intValue], dictionary[@"waterAmount"]];
                cell.imageView.image = [UIImage imageNamed:@"Water_icon"];
            }
        }
        else if (indexPath.row == 1) {
            if ([dictionary[@"hasWater"] isEqualToString:@"true"]) {
                if ([dictionary[@"hasVacuum"] boolValue]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"$%g for %@", [dictionary[@"VacuumDollar"] floatValue], dictionary[@"vacuumAmount"] ];
                    cell.imageView.image = [UIImage imageNamed:@"Vacuum_icon"];
                }
            }
            else {
                if ([dictionary[@"hasJet"] isEqualToString:@"true"]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"$%g for %@", [dictionary[@"jetDollar"] floatValue], dictionary[@"jetAmount"]];
                    cell.imageView.image = [UIImage imageNamed:@"Jet_icon"];
                }
            }
        }
        else {
            if ([dictionary[@"hasJet"] isEqualToString:@"true"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"$%g for %@", [dictionary[@"jetDollar"] floatValue], dictionary[@"jetAmount"]];
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
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [dictionary[@"availableBays"] intValue]];
        
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
        
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void) activateButtonTapped:(UIButton *)sender {
    NSMutableDictionary* dictionary = [_selectedCarPark.carparkArray objectAtIndex:0];
    sender.enabled = false;
    NSString *device = @"w";
    if (sender.tag == 0) {
        if ([dictionary[@"hasWater"] isEqualToString:@"true"]) {
        }
    }
    else if (sender.tag == 1) {
        if ([dictionary[@"hasWater"] isEqualToString:@"true"]) {
            if ([dictionary[@"hasVacuum"] isEqualToString:@"true"]) {
                device = @"v";
            }
        }
        else {
            if ([dictionary[@"hasJet"] isEqualToString:@"true"]) {
                device = @"j";
            }
        }
    }
    else {
        if ([dictionary[@"hasJet"] isEqualToString:@"true"]) {
            device = @"j";
        }
    }
    //    NSString* URL = @"washbay.jlabs.pro/set-parking/6F2DE7?time=11-21-2016&signal=65&station=1326&data=05423E0000000000";
    //    NSString* URL = @"b.strij.net/inc?id=6F2DE7&time=1&signal=65&station=1326&data=05423E0000000000";
    //    NSString* URL = @"http://washbay.jlabs.pro/set-parking/inc?id=6F2DE7&time=1&signal=65&station=1326&data=05423E0000000000";
    //    NSString* donelink = @"https://b.strij.net/api/sendmessage/?modem=6F2DE7?&message= 05423E0000000000&key=0s3w8f0hggufbqsz1h7316qc16ohiovqylsasb6o82470o79jlm7zztk6pqscv3l";
    
    NSString* URL = @"";
    //    AFHTTPSessionManager *operationmanager = [AFHTTPSessionManager manager];
    //    operationmanager.responseSerializer=[AFJSONResponseSerializer serializer];
    //
    //    [operationmanager POST:URL parameters:NULL progress:^(NSProgress * _Nonnull uploadProgress) {
    //        NSLog(@"uploading");
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSLog(@"sucess");
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"fail");
    //    }];
    //
    //
    //    //    NSString* URLGET = @"http://washbay.jlabs.pro/set-parking/inc?id=6F2DE7&time=1&signal=65&station=1326&data=05423E0000000000";
    //    [operationmanager GET:URL parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
    //        NSLog(@"uploading");
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSLog(@"sucess");
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"fail");
    //    }];
    //    [operationmanager POST:URL parameters:postdatadictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
    //     {
    //         [drk hide];
    //
    //         NSLog(@" +++++>> in post api success ");
    //
    //         NSDictionary *responsedictionary = (NSDictionary *)responseObject;
    //
    //         [self.delegate performSelector:responseselector withObject:responsedictionary];
    //
    //     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //         [drk hide];
    //
    //         NSLog(@" +++++>> in post api Failer %@",error.localizedDescription);
    //
    //         if([operation responseObject] != nil)
    //         {
    //             [self.delegate performSelector:responseselector withObject:[operation responseObject]];
    //         }
    //         else
    //         {
    //             UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Wotto" message:@"Internet Connection Failed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //             [alert show];
    //         }
    //
    //     }];
    
    //    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    //    NSMutableDictionary* dictionaryFire = [[NSMutableDictionary alloc] init];
    //    [[[ref child:@"CarWashBay"] child:[NSString stringWithFormat:@"object %d", _selectedCarPark.ID]] setValue:dictionaryFire];
    
    NSURL* url = [NSURL URLWithString:@"https://www.imonnit.com/xml/SensorSendControlCommand/Z3VydmFpbC5kaG90OjkxMTEwMzEx?sensorID=158120&relayIndex=1&state=2&seconds=1"]; //&relayIndex=0&state=2&seconds=1
    NSURL* urlAuthToken = [NSURL URLWithString:@"https://www.imonnit.com/xml/GetAuthToken?username=gurvail.dhot&password=91110311"];
    NSURL* urllogon = [NSURL URLWithString:@"https://www.imonnit.com/xml/Logon/Z3VydmFpbC5kaG90OjkxMTEwMzEx"];
    NSURL* url1 = [NSURL URLWithString:@"http://washbay.jlabs.pro/set-parking/6F3620?time=1&signal=36&station=1326&data=0000000124B571AE"];
    
    [self getToken:urlAuthToken :urllogon : url];
    
    //    NSError *error = nil;
    //    if (error == nil) {
    //        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Activation sent." message:@"Please wait for a few seconds." preferredStyle:UIAlertControllerStyleAlert];
    //        [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        }]];
    //        [self presentViewController:controller
    //                           animated:true completion:nil];
    //    }
    //    else {
    //        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    //        [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        }]];
    //        [self presentViewController:controller
    //                           animated:true completion:nil];
    //    }
    sender.enabled = true;
}

-(void)getToken:(NSURL*) urlAuto :(NSURL*) urlLogon :(NSURL*) url
{
    NSURLRequest* request = [NSURLRequest requestWithURL:urlAuto];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                               if (data.length > 0 && connectionError == nil )
                               {
                                   [self logon:urlLogon :url];
                               }
                           }];
}

-(void)logon:(NSURL*) urlLogon : (NSURL*) url
{
    NSURLRequest* request = [NSURLRequest requestWithURL:urlLogon];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                               if (data.length > 0 && connectionError == nil )
                               {
                                   [self sensorControll:url];
                               }
                           }];
}

-(void)sensorControll:(NSURL*) url
{
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                               if (data.length > 0 && connectionError == nil )
                               {
                                   NSLog(@"%@", [data description]);
                                   UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Activation sent." message:@"Please wait for a few seconds." preferredStyle:UIAlertControllerStyleAlert];
                                   [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                       
                                   }]];
                                   [self presentViewController:controller
                                                      animated:true completion:nil];
                               }
                           }];
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
