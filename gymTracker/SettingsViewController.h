#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *cmCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *inchCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *lbsCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *kgCheckBox;

@property (strong, nonatomic) IBOutlet UITextField *setsTextField;

@property (strong, nonatomic) IBOutlet UIStepper *setsStepper;

- (IBAction)cmCheckBoxClick:(id)sender;
- (IBAction)inchCheckBoxClick:(id)sender;
- (IBAction)lbsCheckBoxClick:(id)sender;
- (IBAction)kgCheckBoxClick:(id)sender;
- (IBAction)setsStepperValueChanged:(id)sender;

@end
