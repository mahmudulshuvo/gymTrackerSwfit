//
//  WorkoutDetailsViewController.h
//  gymTracker
//
//  Created by Third Bit on 3/5/14.
//  Copyright (c) 2014 Third Bit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *set1TextField;

@property (strong, nonatomic) IBOutlet UITextField *set2TextField;

@property (strong, nonatomic) IBOutlet UITextField *set3TextField;

- (IBAction)saveBtn:(id)sender;

@end
