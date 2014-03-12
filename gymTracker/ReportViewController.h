#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *dateSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *equipmentSwitch;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UIPickerView *equipmentPicker;

@property (nonatomic, strong) NSMutableArray *equipmentsList;

@property (strong, nonatomic) IBOutlet UIButton *dateWiseReportBtn;

@property (strong, nonatomic) IBOutlet UIButton *equipmentWiseReportBtn;

- (IBAction)dateSwitchValueChange:(id)sender;
- (IBAction)equipmentSwitchValueChange:(id)sender;

@end
