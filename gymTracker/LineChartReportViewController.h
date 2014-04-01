#import <UIKit/UIKit.h>
#import "PMCalendar.h"
#import "PNLineChart.h"

@interface LineChartReportViewController : UIViewController <PMCalendarControllerDelegate>

@property (nonatomic, strong) PNLineChart * lineChart;

@property (retain, nonatomic) NSNumber *dbId;

@property (strong, nonatomic) IBOutlet UILabel *chartHeader;

@property (strong, nonatomic) IBOutlet UIImageView *legendImageView;

@property (strong, nonatomic) NSString *imageName;

@property (strong, nonatomic) NSString *reportType;

@property (strong, nonatomic) NSDate *selectedFromDate;
@property (strong, nonatomic) NSDate *selectedToDate;

@end
