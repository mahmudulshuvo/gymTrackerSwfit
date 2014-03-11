#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISwitch *lbsSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *kgSwitch;

- (IBAction)saveBtn:(id)sender;
- (IBAction)kgSwitchValueChange:(id)sender;
- (IBAction)lbsSwitchValueChange:(id)sender;

@end
