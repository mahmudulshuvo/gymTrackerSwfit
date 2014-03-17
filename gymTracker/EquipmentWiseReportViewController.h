#import <UIKit/UIKit.h>
#import "Equipment.h"

@interface EquipmentWiseReportViewController : UIViewController

@property (retain, nonatomic) Equipment *selectedEquipment;

@property (strong, nonatomic) IBOutlet UILabel *chartHeader;

@property (strong, nonatomic) IBOutlet UILabel *xAxisLegendLabel;

@property (strong, nonatomic) IBOutlet UILabel *yAxisLegendLabel;

@end
