//
//  AppDelegate.m
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "CarPark.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SignInViewController alloc]initWithNibName:@"SignInViewController" bundle:[NSBundle mainBundle]]];

    [CarPark registerSubclass];
    [Parse setApplicationId:@"RG5ZDyqRMNFxdJTgkCE8e0CjDg5Va7FYDOztAaRl"
                  clientKey:@"1yu2rfZbjHrxPJuwywq2HkKlF5fSO1RHFmnLUWsc"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}

+ (AppDelegate *) getAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (UIColor *) getGreenColor {
    return [UIColor colorWithRed:60.0/255.0 green:169.0/255.0 blue:113.0/255.0 alpha:1.0];
}

+ (UIColor *) getRedColor {
    return [UIColor colorWithRed:190.0/255.0 green:69.0/255.0 blue:11.0/255.0 alpha:1.0];
}

+ (UIColor *) getAmberColor {
    return [UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:0.0/255.0 alpha:1.0];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.location = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.location = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        [manager requestWhenInUseAuthorization];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
