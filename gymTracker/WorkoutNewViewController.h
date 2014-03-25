#import <UIKit/UIKit.h>

@interface WorkoutNewViewController : UITableViewController

@property (retain, nonatomic) NSString *strSelectedDate;

@property (retain, nonatomic) NSArray *workoutList;

@property (retain, nonatomic) NSMutableArray *equipmentsWithNoWorkout;

@end
