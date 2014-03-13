#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *lbsCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *kgCheckBox;

- (IBAction)saveBtn:(id)sender;
- (IBAction)lbsCheckBoxClick:(id)sender;
- (IBAction)kgCheckBoxClick:(id)sender;

@end
