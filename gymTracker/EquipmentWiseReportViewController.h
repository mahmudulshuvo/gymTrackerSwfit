#import <UIKit/UIKit.h>
#import "Equipment.h"
#import "PMCalendar.h"
#import "PNLineChart.h"

@interface EquipmentWiseReportViewController : UIViewController <PMCalendarControllerDelegate>

@property (nonatomic, strong) PNLineChart * lineChart;

@property (retain, nonatomic) Equipment *selectedEquipment;

@property (strong, nonatomic) IBOutlet UILabel *chartHeader;

@property (strong, nonatomic) IBOutlet UIImageView *legendImageView;

@property (strong, nonatomic) NSDate *selectedFromDate;
@property (strong, nonatomic) NSDate *selectedToDate;

@end
