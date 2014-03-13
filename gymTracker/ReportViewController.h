#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"

@interface ReportViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *dateWiseReportCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *equipmentWiseReportCheckBox;

@property (strong, nonatomic) IBOutlet DSLCalendarView *dateCalenderView;

@property (strong, nonatomic) IBOutlet UIPickerView *equipmentPicker;

@property (nonatomic, strong) NSMutableArray *equipmentsList;

@property (strong, nonatomic) IBOutlet UIButton *dateWiseReportBtn;

@property (strong, nonatomic) IBOutlet UIButton *equipmentWiseReportBtn;

- (IBAction)dateWiseReportCheckBoxClick:(id)sender;
- (IBAction)equipmentWiseReportCheckBoxClick:(id)sender;

@end
