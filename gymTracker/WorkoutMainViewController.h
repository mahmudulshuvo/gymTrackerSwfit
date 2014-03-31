#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"

@interface WorkoutMainViewController : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *activityCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *measureCheckBox;

@property (strong, nonatomic) IBOutlet UIView *calendarContainer;

@property (strong, nonatomic) IBOutlet TKCalendarMonthView *dateCalenderView;

@property (strong, nonatomic) IBOutlet UIButton *viewActivityBtn;

@property (strong, nonatomic) IBOutlet UIButton *viewMeasureBtn;

- (IBAction)activityCheckBoxClick:(id)sender;
- (IBAction)measureCheckBoxClick:(id)sender;

@end
