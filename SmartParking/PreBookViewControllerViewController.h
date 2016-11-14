//
//  PreBookViewControllerViewController.h
//  SmartParking
//
//  Created by Ashish Krishnarao Awaghad on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreBookViewControllerViewController : UIViewController
{
    IBOutlet UITableView *fromToTableView;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIButton *bookButton;
    
    NSDate *fromDate, *toDate;
    BOOL whetherFromOrTo;
}

@property (nonatomic, assign) BOOL whetherFromOrTo;
@property (nonatomic, strong) IBOutlet UITableView *fromToTableView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *fromDate, *toDate;
@property (nonatomic, strong) IBOutlet UIButton *bookButton;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) IBOutlet UILabel *estimatedCostLabel;

- (IBAction) valueChanged:(UIDatePicker *) picker;
- (IBAction) bookButtonClicked:(UIButton *) button;
@end
