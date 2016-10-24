//
//  ViewController.m
//  Semaphore Control
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 29/09/15.
//  Copyright © 2015 Leonardo Vinicius Kaminski Ferreira. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Constants.h"
#import "HelperFunctions.h"


@interface ViewController ()

@property (nonatomic, strong) UISegmentedControl *mySegmentedControl;
@property (nonatomic, strong) UILabel *temp;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self threadQuery:@1];
    
    // timer to verify Parse.com periodically
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(threadQuery:) userInfo:nil repeats:YES];
    
    
    
    UIFont * customFont = [UIFont fontWithName:@"Arial" size:25]; //custom font
    NSString *text = @"Actual mode time: ";
    
    //CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(380, 20) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize maximumLabelSize = CGSizeMake(310, 9999);
    
    CGRect textRect = [text boundingRectWithSize:maximumLabelSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: customFont}
                                         context:nil];
    
    CGSize labelSize = textRect.size;
    
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, labelSize.width, labelSize.height)];
    fromLabel.text = text;
    fromLabel.font = customFont;
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor blackColor];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:fromLabel];
    
    
    self.temp = [[UILabel alloc]initWithFrame:CGRectMake(fromLabel.frame.origin.x+fromLabel.frame.size.width+5, fromLabel.frame.origin.y, labelSize.width, labelSize.height)];
    self.temp.text = @"";
    self.temp.font = customFont;
    self.temp.numberOfLines = 1;
    self.temp.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    self.temp.adjustsFontSizeToFitWidth = YES;
    self.temp.minimumScaleFactor = 10.0f/12.0f;
    self.temp.clipsToBounds = YES;
    self.temp.backgroundColor = [UIColor clearColor];
    self.temp.textColor = [UIColor redColor];
    self.temp.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.temp];
    
    
    //set the view background to white
    self.view.backgroundColor = [UIColor whiteColor];
    
    //frame for the segemented button
    CGRect myFrame = CGRectMake(10, 300.0f, 300.0f, 50.0f);
    
    //Array of items to go inside the segment control
    //You can choose to add an UIImage as one of the items instead of NSString
    NSArray *mySegments = [[NSArray alloc] initWithObjects: @"T1",
                           @"T2", @"TA", @"Urg. S1", @"Urg. S2", @"Std. By",  nil];
    
    //create an intialize our segmented control
    self.mySegmentedControl = [[UISegmentedControl alloc] initWithItems:mySegments];
    
    //set the size and placement
    self.mySegmentedControl.frame = myFrame;
    
    
    
    // lets rotate segmented
    self.mySegmentedControl.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    
    NSArray *arr = [self.mySegmentedControl subviews];
    for (int i = 0; i < [arr count]; i++) {
        UIView *v = (UIView*) [arr objectAtIndex:i];
        NSArray *subarr = [v subviews];
        for (int j = 0; j < [subarr count]; j++) {
            if ([[subarr objectAtIndex:j] isKindOfClass:[UILabel class]]) {
                UILabel *l = (UILabel*) [subarr objectAtIndex:j];
                l.transform = CGAffineTransformMakeRotation(- M_PI / 2.0); //do the reverse of what Ben did
            }
        }
    }
    
    
    //default the selection to second item
    [self.mySegmentedControl setSelectedSegmentIndex:5];
    
    //attach target action for if the selection is changed by the user
    [self.mySegmentedControl addTarget:self
                                action:@selector(whichTempSelected:)
                      forControlEvents:UIControlEventValueChanged];
    
    //add the control to the view
    [self.view addSubview:self.mySegmentedControl];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) whichTempSelected:(UISegmentedControl *)paramSender{
    
    //check if its the same control that triggered the change event
    if ([paramSender isEqual:self.mySegmentedControl]){
        
        //get index position for the selected control
        NSInteger selectedIndex = [paramSender selectedSegmentIndex];
        
        NSString *tempSelected = @"";
        
        if(selectedIndex == 0) {
            tempSelected = @"m0";
        } else if(selectedIndex == 1) {
            tempSelected = @"m1";
        } else if(selectedIndex == 2) {
            tempSelected = @"auto";
        } else if(selectedIndex == 3) {
            tempSelected = @"em1";
        } else if(selectedIndex == 4) {
            tempSelected = @"em2";
        } else if(selectedIndex == 5) {
            tempSelected = @"stand-by";
        }
        
        //get the Text for the segmented control that was selected
        //NSString *myChoice = [paramSender titleForSegmentAtIndex:selectedIndex];
        //let log this info to the console
    
        
        PFObject *objRule = [PFObject objectWithClassName:@"Rules"];
        
        objRule[@"code"] = tempSelected;
        objRule[@"isImplemented"] = [NSNumber numberWithBool:FALSE];
        objRule[@"new"] = [NSNumber numberWithBool:TRUE];
        [objRule saveEventually:^(BOOL succeeded, NSError *error) {
            NSLog(@"post to parse.com succeed");
            
            if(error) {
                [HelperFunctions showErrorWithMessage:@"Failed to post object on server."  title:@"Connection Error"];
            }
        }];
    }
}


-(void) threadQuery: (id)target {

    PFQuery *queryRulesClass = [PFQuery queryWithClassName:@"Rules"];
    
    [queryRulesClass selectKeys:@[@"code",
                                 @"target",
                                  @"isImplemented"]];
    [queryRulesClass orderByDescending:@"updatedAt"];
    
    [queryRulesClass findObjectsInBackgroundWithBlock:^(NSArray *userPostsObjects, NSError *error) {
        if (!error) {
            
            
            
            // Do something with the data
            for (PFObject *oObject in userPostsObjects) {
                
                //NSLog(@"FINAL OUTPUT %@", [userPostsObjects firstObject][@"code"]);
                if([oObject[@"isImplemented"] boolValue]) { // get most recent object with isImplementd == TRUE
                    self.temp.text = [oObject[@"code"] description];
                    
                    if([[oObject[@"code"] description] isEqualToString:@"m0"]) {
                        self.temp.text = @"T1";
                    } else if([[oObject[@"code"] description] isEqualToString:@"m1"]) {
                        self.temp.text = @"T2";
                    } else if([[oObject[@"code"] description] isEqualToString:@"auto"]) {
                        self.temp.text = @"TA";
                    } else if([[oObject[@"code"] description] isEqualToString:@"em1"]) {
                        self.temp.text = @"Urg. S1";
                    } else if([[oObject[@"code"] description] isEqualToString:@"em2"]) {
                        self.temp.text = @"Urg. S2";
                    } else if([[oObject[@"code"] description] isEqualToString:@"stand-by"]) {
                        self.temp.text = @"Std. By";
                    }
                    
                    break;
                }
                
            }
        }
        else {
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


-(UILabel *) createLogoLabelWithText:(NSString *) text frame:(CGRect )frame {
    
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.text=text;
    lb.font = [UIFont fontWithName:@"GillSans-Light" size:38];
    lb.textColor = [UIColor darkGrayColor];
    return lb;
}

#pragma mark - Login
-(void) viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // if not logged, show login controller
    if (![PFUser currentUser]) {
        
        PFLogInViewController *loginVC = [PFLogInViewController new];
        loginVC.logInView.logo = [self createLogoLabelWithText:@"Semaphore Control" frame:loginVC.logInView.logo.frame];
        loginVC.signUpController.signUpView.logo=[self createLogoLabelWithText:@"Semaphore Control" frame:loginVC.signUpController.signUpView.logo.frame];
        loginVC.delegate = self;
        loginVC.signUpController.delegate=self;
        [loginVC.logInView.dismissButton setHidden:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    } else {
        
        
    }
    
//    [self checkIfGoalWasChanged];
//    [self fillRoundView];
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController
shouldBeginLogInWithUsername:(NSString *)username
                   password:(NSString *)password {
    
    if (!username.length || !password.length) {
        
        [HelperFunctions showErrorWithMessage:@"Please fill all fields."  title:@"Missing field(s)"];
        
        return NO;
    }
    
    return YES;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    // lets post notification to update all lists
    [[NSNotificationCenter defaultCenter] postNotificationName:NEW_MEAL_ADDED object:nil];
    
    [logInController dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // here we could do something when the user cancels
    return;
}

#pragma mark - Signup
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    
    // we have to send the info to update the ROLE to USE
    [user setObject:@"U" forKey:@"role"];
    [user saveEventually];
    
    // now lets dismiss both view, the signup and the login
    [signUpController dismissViewControllerAnimated:YES completion:^{
        
        // lets post notification to update all lists
        [[NSNotificationCenter defaultCenter] postNotificationName:NEW_MEAL_ADDED object:nil];
        
        // and we have to dismiss the login that was being s
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    
    if (!signUpController.signUpView.usernameField.text.length || !signUpController.signUpView.passwordField.text.length || !signUpController.signUpView.emailField.text.length) {
        
        [HelperFunctions showErrorWithMessage:@"Please fill all fields."  title:@"Missing field(s)"];
        
        return NO;
    }
    
    return YES;
}


@end
