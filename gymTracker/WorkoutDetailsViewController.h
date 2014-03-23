#import <UIKit/UIKit.h>
#import "Equipment.h"
#import "Workout.h"

@interface WorkoutDetailsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *set1Label;

@property (strong, nonatomic) IBOutlet UILabel *set2Label;

@property (strong, nonatomic) IBOutlet UILabel *set3Label;

@property (strong, nonatomic) IBOutlet UILabel *set4Label;

@property (strong, nonatomic) IBOutlet UILabel *set5Label;

@property (strong, nonatomic) IBOutlet UITextField *set1TextField;

@property (strong, nonatomic) IBOutlet UITextField *set2TextField;

@property (strong, nonatomic) IBOutlet UITextField *set3TextField;

@property (strong, nonatomic) IBOutlet UITextField *set4TextField;

@property (strong, nonatomic) IBOutlet UITextField *set5TextField;

@property (strong, nonatomic) IBOutlet UILabel *weightLabel1;

@property (strong, nonatomic) IBOutlet UILabel *weightLabel2;

@property (strong, nonatomic) IBOutlet UILabel *weightLabel3;

@property (strong, nonatomic) IBOutlet UILabel *weightLabel4;

@property (strong, nonatomic) IBOutlet UILabel *weightLabel5;

@property (retain, nonatomic) Equipment *selectedEquipment;

@property (retain, nonatomic) Workout *workout;

@property (retain, nonatomic) NSString *parentControllerName;

@end
