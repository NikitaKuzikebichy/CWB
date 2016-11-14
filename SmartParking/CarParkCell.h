//
//  CarParkCell.h
//  SmartParking
//
//  Created by Ashish Awaghad on 20/1/13.
//
//

#import <UIKit/UIKit.h>

@interface CarParkCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel, *availableLotsLabel, *distanceLabel;
@property (nonatomic, strong) IBOutlet UIButton *prebookButton;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;

@end
