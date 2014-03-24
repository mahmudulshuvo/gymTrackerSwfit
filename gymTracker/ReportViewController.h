#import <UIKit/UIKit.h>
#import "MyPMCalendarController.h"

@interface ReportViewController : UIViewController <PMCalendarControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MyPMCalendarController *pmCalendarController;

@property (strong, nonatomic) IBOutlet UITextField *fromDateTextField;

@property (strong, nonatomic) IBOutlet UITextField *toDateTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *equipmentPicker;

@property (strong, nonatomic) IBOutlet UIButton *equipmentWiseReportBtn;

- (IBAction)fromDateTextFieldTouchDown:(id)sender;
- (IBAction)toDateTextFieldTouchDown:(id)sender;

@end
