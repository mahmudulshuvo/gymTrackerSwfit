#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"

@interface WorkoutMainViewController : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *calendarContainer;

@property (strong, nonatomic) IBOutlet TKCalendarMonthView *dateCalenderView;

@end
