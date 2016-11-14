//
//  PreBookViewControllerViewController.m
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreBookViewControllerViewController.h"
#import "CarParkSlotViewController.h"

@interface PreBookViewControllerViewController ()
@end

@implementation PreBookViewControllerViewController
@synthesize fromToTableView, datePicker, fromDate, toDate, bookButton, whetherFromOrTo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.fromToTableView.backgroundColor = [UIColor clearColor];
    self.datePicker.hidden = YES;
    self.datePicker.minimumDate = [NSDate date];
    self.bookButton.alpha = 0.5;
    
    [self.tableFooterView setBackgroundColor:[UIColor clearColor]];
    UIView *view = [[UIView alloc] init];
    //[view setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:204.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    [self.fromToTableView setBackgroundView:view];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];

    self.datePicker.hidden = false;
    whetherFromOrTo = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) valueChanged:(UIDatePicker *) picker;
{
    if (whetherFromOrTo) {
        self.fromDate = picker.date;
    }
    else {
        self.toDate = picker.date;
    }
    
    if (self.fromDate) {
        self.bookButton.enabled = YES;
        self.bookButton.alpha = 1.0;
        
        if (self.toDate) {
            int interval = [self.toDate timeIntervalSinceDate:self.fromDate];

            interval /= 3600;

            interval -= 1;
            
            float cost = 3.0;
            cost += interval;
            self.estimatedCostLabel.text = [NSString stringWithFormat:@"Estimated Cost: $%.2f", cost];
        }
    }
    
    [self.fromToTableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"When will you arrive?";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    if (indexPath.row == 0) {
        cell.textLabel.text = @"From";
        if (self.fromDate==nil) {
            cell.detailTextLabel.text = @"";
        }
        else {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            //[df setDateStyle: nil];;
            [df setDateFormat:@"dd MMM hh:mm a"];
            //[df setTimeStyle:NSDateFormatterLongStyle];
            cell.detailTextLabel.text = [df stringFromDate:self.fromDate];
        }
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"To (Optional)";
        
        if (self.toDate==nil) {
            cell.detailTextLabel.text = @"";
        }
        else {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            //[df setDateStyle: nil];;
            [df setDateFormat:@"dd MMM hh:mm a"];
            //[df setTimeStyle:NSDateFormatterLongStyle];
            cell.detailTextLabel.text = [df stringFromDate:self.toDate];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.tableFooterView;
}

- (CGFloat ) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 37;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    self.datePicker.hidden = false;
    
    if (indexPath.row == 0) {
        whetherFromOrTo = YES;
    }
    else {
        whetherFromOrTo = false;
    }
}

- (IBAction) bookButtonClicked:(UIButton *) button
{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Booking Successful" message:@"Your booking is successful. We'll send you the car park slot details before you reach!" delegate:self cancelButtonTitle:@"Cool!" otherButtonTitles: nil];
    [al show];
}

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CarParkSlotViewController *carParkVC = [[CarParkSlotViewController alloc] initWithNibName:@"CarParkSlotViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:carParkVC animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
