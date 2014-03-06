#import <UIKit/UIKit.h>
#import "Equipment.h"

@interface WorkoutDetailsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *set1TextField;

@property (strong, nonatomic) IBOutlet UITextField *set2TextField;

@property (strong, nonatomic) IBOutlet UITextField *set3TextField;

@property (retain, nonatomic) Equipment *selectedEquipment;

- (IBAction)saveBtn:(id)sender;

@end
