#import <UIKit/UIKit.h>
#import "Equipment.h"
#import "PMCalendar.h"
#import "MyPMCalendarController.h"
#import "PNLineChart.h"

@interface EquipmentWiseReportViewController : UIViewController <PMCalendarControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MyPMCalendarController *pmCalendarController;
@property (nonatomic, strong) PNLineChart * lineChart;

@property (retain, nonatomic) Equipment *selectedEquipment;

@property (strong, nonatomic) IBOutlet UILabel *chartHeader;

@property (strong, nonatomic) IBOutlet UILabel *xAxisLegendLabel;

@property (strong, nonatomic) IBOutlet UILabel *yAxisLegendLabel;

@property (strong, nonatomic) IBOutlet UITextField *fromDateTextField;

@property (strong, nonatomic) IBOutlet UITextField *toDateTextField;

- (IBAction)fromDateTextFieldTouchDown:(id)sender;
- (IBAction)toDateTextFieldTouchDown:(id)sender;
- (IBAction)viewBtn:(id)sender;

@end
