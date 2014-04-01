#import <UIKit/UIKit.h>
#import "Measurement.h"
#import "MeasurementHistory.h"

@interface MeasurementHistoryDetailsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *sizeTextField;

@property (strong, nonatomic) IBOutlet UILabel *measurementTypeLabel;

@property (retain, nonatomic) Measurement *selectedMeasurement;

@property (retain, nonatomic) MeasurementHistory *measurementHistory;

@property (retain, nonatomic) NSString *strSelectedDate;

@property (retain, nonatomic) NSString *parentControllerName;

- (void)save;

@end
