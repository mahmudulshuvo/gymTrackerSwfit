#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"

@interface WorkoutMainViewController : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *workoutCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *measurementCheckBox;

@property (strong, nonatomic) IBOutlet UIView *calendarContainer;

@property (strong, nonatomic) IBOutlet TKCalendarMonthView *dateCalenderView;

@property (strong, nonatomic) IBOutlet UIButton *viewWorkoutBtn;

@property (strong, nonatomic) IBOutlet UIButton *viewMeasurementBtn;

- (IBAction)workoutCheckBoxClick:(id)sender;
- (IBAction)measurementCheckBoxClick:(id)sender;

@end
