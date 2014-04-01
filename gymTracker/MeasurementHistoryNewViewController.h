#import <UIKit/UIKit.h>

@interface MeasurementHistoryNewViewController : UITableViewController

@property (retain, nonatomic) NSString *strSelectedDate;

@property (retain, nonatomic) NSArray *measurementHistoryList;

@property (retain, nonatomic) NSMutableArray *measurementsWithNoHistory;

@end
