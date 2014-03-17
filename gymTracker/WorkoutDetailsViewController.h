#import <UIKit/UIKit.h>
#import "Equipment.h"
#import "Workout.h"

@interface WorkoutDetailsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *set1TextField;

@property (strong, nonatomic) IBOutlet UITextField *set2TextField;

@property (strong, nonatomic) IBOutlet UITextField *set3TextField;

@property (strong, nonatomic) IBOutlet UILabel *weightLabel1;

@property (strong, nonatomic) IBOutlet UILabel *weightLabel2;

@property (strong, nonatomic) IBOutlet UILabel *weightLabel3;

@property (retain, nonatomic) Equipment *selectedEquipment;

@property (retain, nonatomic) Workout *workout;

- (IBAction)saveBtn:(id)sender;

@end
