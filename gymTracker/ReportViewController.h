#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"

@interface ReportViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *dateWiseReportCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *equipmentWiseReportCheckBox;

@property (strong, nonatomic) IBOutlet UIView *calendarContainer;

@property (strong, nonatomic) IBOutlet TKCalendarMonthView *dateCalenderView;

@property (strong, nonatomic) IBOutlet UIPickerView *equipmentPicker;

@property (strong, nonatomic) IBOutlet UIButton *dateWiseReportBtn;

@property (strong, nonatomic) IBOutlet UIButton *equipmentWiseReportBtn;

- (IBAction)dateWiseReportCheckBoxClick:(id)sender;
- (IBAction)equipmentWiseReportCheckBoxClick:(id)sender;

@end
