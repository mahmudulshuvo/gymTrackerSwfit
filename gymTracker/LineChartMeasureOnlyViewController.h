#import <UIKit/UIKit.h>
#import "PNLineChart.h"

@interface LineChartMeasureOnlyViewController : UIViewController

@property (nonatomic, strong) PNLineChart * lineChart;

@property (retain, nonatomic) NSNumber *measurementId;
@property (retain, nonatomic) NSString *measurementName;

@property (strong, nonatomic) IBOutlet UILabel *chartHeader;

@property (strong, nonatomic) IBOutlet UIImageView *legendImageView;

@property (strong, nonatomic) NSDate *selectedFromDate;
@property (strong, nonatomic) NSDate *selectedToDate;

@end
