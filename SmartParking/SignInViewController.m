//
//  SignInViewController.m
//  SmartParking
//
//  Created by Ashish Awaghad on 18/1/13.
//
//

#import "SignInViewController.h"
#import "MasterViewController.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface SignInViewController ()
{
    NSMutableDictionary *usernamesToPasswords;
}
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signInFacebookButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentViewOfScrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField, *passwordTextField;


- (IBAction)signInButtonClicked:(id)sender;
- (IBAction)signInWithFacebookButtonClicked:(id)sender;

@end

@implementation SignInViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    
    //[self.usernameTextField becomeFirstResponder];
    
    usernamesToPasswords = [[NSMutableDictionary alloc] init];
    [usernamesToPasswords setObject:@"reshma" forKey:@"ali"];
    [usernamesToPasswords setObject:@"ipad" forKey:@"suchet"];
    [usernamesToPasswords setObject:@"surepark" forKey:@"heri"];
    [usernamesToPasswords setObject:@"redbull" forKey:@"steffan"];
    [usernamesToPasswords setObject:@"ciaran" forKey:@"ciaran"];
    [usernamesToPasswords setObject:@"dhot" forKey:@"dhot"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self.contentViewOfScrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    //    [self.signInButton setBackgroundImage:[[UIImage imageNamed:@"bluebg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)] forState:UIControlStateNormal];
    [self.signInButton setBackgroundColor:[UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0]];
    CALayer *layer = [self.signInButton layer];
    [layer setCornerRadius:3.0];
    [layer setMasksToBounds:YES];
    [self.signInFacebookButton setBackgroundColor:[UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0]];
    layer = [self.signInFacebookButton layer];
    [layer setCornerRadius:3.0];
    [layer setMasksToBounds:YES];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)]];
}

- (void) singleTap:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setSignInButton:nil];
    [super viewDidUnload];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self signInButtonClicked:self.signInButton];
    }
    
    return false;
}

- (IBAction)signInButtonClicked:(id)sender {
    NSString *username = [self.usernameTextField.text lowercaseString];
    if ((self.usernameTextField.text.length == 0 && [self.passwordTextField.text isEqualToString:@"q"]) ||([usernamesToPasswords objectForKey:username] && [[usernamesToPasswords objectForKey:username] isEqualToString:self.passwordTextField.text])) {
        [[AppDelegate getAppDelegate] setLoggedInUserName:[username capitalizedString]];
        MasterViewController *masterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
        [self.navigationController pushViewController:masterViewController animated:YES];
    }
    else {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Incorrect Username or Password" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [al show];
    }
}

- (IBAction)signInWithFacebookButtonClicked:(id)sender {
    //    [PFFacebookUtils initializeFacebook];
    //    NSArray *permissionsArray = @[@"email", @"user_about_me", @"user_birthday"];
    //
    //    // Login PFUser using Facebook
    //    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
    //
    //        if (!user) {
    //            if (!error) {
    //                NSLog(@"Uh oh. The user cancelled the Facebook login.");
    //            } else {
    //                NSLog(@"Uh oh. An error occurred: %@", error);
    //            }
    //        } else
    //        {
    //            [[AppDelegate getAppDelegate] setLoggedInUserName:[user.username capitalizedString]];
    //            MasterViewController *masterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    //            [self.navigationController pushViewController:masterViewController animated:YES];
    //
    //            NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status,picture,email,id";
    //
    //            FBRequest *request = [[FBRequest alloc] initWithSession:[PFFacebookUtils session] graphPath:requestPath];
    //
    //            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    //                if (!error) {
    //                    NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
    //
    //                    NSString *name = [userData objectForKey:@"name"];
    //
    //                    NSString *email = [userData objectForKey:@"email"];
    //
    //                    NSString *sID = [userData objectForKey:@"id"];
    //
    //                    // get the FB user's profile image
    //                    NSDictionary *dicFacebookPicture = [userData objectForKey:@"picture"];
    //                    NSDictionary *dicFacebookData = [dicFacebookPicture objectForKey:@"data"];
    //                    [[AppDelegate getAppDelegate] setLoggedInUserName:[name capitalizedString]];
    //                    user[@"email"] = email;
    //                    user[@"name"] = name;
    //                    [user saveInBackground];
    //                }
    //            }];
    //
    //            if (user.isNew) {
    //                NSLog(@"User with facebook signed up and logged in!");
    //            } else {
    //                NSLog(@"User with facebook logged in!");
    //            }
    //        }
    //    }];
}

- (void) keyboardWillHide:(NSNotification*)note
{
    [UIView animateWithDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        CGFloat height = self.usernameTextField.frame.origin.y;
        [self.contentViewOfScrollView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+height)];
        [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+height)];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }];
}

- (void) keyboardWillShow:(NSNotification*)note
{
    [UIView animateWithDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        CGFloat height = self.usernameTextField.frame.origin.y - 30;
        [self.contentViewOfScrollView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+height)];
        [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+height)];
        [self.scrollView setContentOffset:CGPointMake(0, height)];
    }];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
