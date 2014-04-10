#import <UIKit/UIKit.h>
#import "PNLineChart.h"

@interface LineChartReportViewController : UIViewController

@property (nonatomic, strong) PNLineChart * lineChart;

@property (retain, nonatomic) NSNumber *equipmentId;
@property (retain, nonatomic) NSNumber *measurementId;
@property (retain, nonatomic) NSString *measurementName;

@property (strong, nonatomic) IBOutlet UILabel *chartHeader;

@property (strong, nonatomic) IBOutlet UIImageView *legendImageView;

@property (strong, nonatomic) NSString *imageName;

@property (strong, nonatomic) NSString *reportType;

@property (strong, nonatomic) IBOutlet UIButton *bodyPartButton;

@property (strong, nonatomic) NSDate *selectedFromDate;
@property (strong, nonatomic) NSDate *selectedToDate;

@end
