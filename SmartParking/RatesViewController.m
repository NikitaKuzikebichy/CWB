//
//  RatesViewController.m
//  SmartParking
//
//  Created by Ashish Awaghad on 20/1/13.
//
//

#import "RatesViewController.h"

@interface RatesViewController ()
{
    NSMutableArray *ratesArray;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation RatesViewController

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
	// Do any additional setup after loading the view.
    
    self.title = @"Parking Rates";
    ratesArray = [[NSMutableArray alloc] init];
    [ratesArray addObject:@"Mon-Thu: 8am-4.59pm: $2.67 for 1st hr; $0.64 for sub. 15mins\nFriday: 8am-4.59pm: $2.56 for 1st hr; $0.94 for sub. 15mins"];
    [ratesArray addObject:@"Mon-Thu: 5pm-11.59pm: $3 per entry. 12am-7.59am $1.07 per hr\nFriday: 5pm-11.59pm: $3.74 per entry"];
    [ratesArray addObject:@"8am-4.59pm: $2.56 for 1st hr; $0.94 for sub. 15mins\n5pm-11.59pm: $3.74 per entry. 12am-7.59am $1.07 per hour"];
    [ratesArray addObject:@"10 Minutes"];
    UIView *view = [[UIView alloc] init];
    //[view setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:204.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    [self.tableView setBackgroundView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [((NSString *)[ratesArray objectAtIndex:indexPath.section]) sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(320.0, 1000.0) lineBreakMode:UILineBreakModeCharacterWrap].height + 30.0;
    }
    else if (indexPath.section == 1) {
        return [((NSString *)[ratesArray objectAtIndex:indexPath.section]) sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(320.0, 1000.0) lineBreakMode:UILineBreakModeCharacterWrap].height + 40.0;
    }
    else if (indexPath.section == 2) {
        return [((NSString *)[ratesArray objectAtIndex:indexPath.section]) sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(320.0, 1000.0) lineBreakMode:UILineBreakModeCharacterWrap].height + 25.0;
    }
    else if (indexPath.section == 3) {
        return [((NSString *)[ratesArray objectAtIndex:indexPath.section]) sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(320.0, 1000.0) lineBreakMode:UILineBreakModeCharacterWrap].height + 20.0;
    }
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case 0:
            title = @"Weekday (Before 5/6pm)";
            break;
            
        case 1:
            title = @"Weekday (After 5/6pm)";
            break;
            
        case 2:
            title = @"Saturday/Sunday/PH";
            break;
            
        case 3:
            title = @"Grace Period";
            break;
            
        default:
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [ratesArray objectAtIndex:indexPath.section];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

@end
