#import <UIKit/UIKit.h>
#import "Measurement.h"

@interface MeasureViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *measurementNameTextField;

@property (retain, nonatomic) Measurement *selectedMeasurement;

- (IBAction)saveBtn:(id)sender;

@end
