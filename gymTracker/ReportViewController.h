#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedControlValueChange:(id)sender;

@end
