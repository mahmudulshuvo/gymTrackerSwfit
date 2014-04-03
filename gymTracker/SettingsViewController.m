#import "SettingsViewController.h"
#import "Utility.h"
#import "FMDBDataAccess.h"

@interface SettingsViewController ()
{
    BOOL cmChecked;
    BOOL inchChecked;
    BOOL lbsChecked;
    BOOL kgChecked;
}

@end

@implementation SettingsViewController

Utility *utility;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        utility = [Utility sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([utility.settings.measurement isEqualToString:@"cm"])
    {
        [self.cmCheckBox setImage:utility.checkBoxMarkedImage forState:UIControlStateNormal];
        cmChecked = YES;
    }
    else
    {
        [self.inchCheckBox setImage:utility.checkBoxMarkedImage forState:UIControlStateNormal];
        inchChecked = YES;
    }
    if([utility.settings.weight isEqualToString:@"lbs"])
    {
        [self.lbsCheckBox setImage:utility.checkBoxMarkedImage forState:UIControlStateNormal];
        lbsChecked = YES;
    }
    else
    {
        [self.kgCheckBox setImage:utility.checkBoxMarkedImage forState:UIControlStateNormal];
        kgChecked = YES;
    }
    int sets = utility.settings.sets.intValue;
    self.setsStepper.value = sets;
    self.setsTextField.text = [NSString stringWithFormat:@"%d", sets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cmCheckBoxClick:(id)sender
{
    if(!cmChecked)
    {
        [self.cmCheckBox setImage:utility.checkBoxMarkedImage forState:UIControlStateNormal];
        cmChecked = YES;
        if(inchChecked)
        {
            [self.inchCheckBox setImage:utility.checkBoxImage forState:UIControlStateNormal];
            inchChecked = NO;
        }
        
        utility.settings.measurement = @"cm";
        [FMDBDataAccess updateSettings:utility.settings];
    }
}

- (IBAction)inchCheckBoxClick:(id)sender
{
    if(!inchChecked)
    {
        [self.inchCheckBox setImage:utility.checkBoxMarkedImage forState:UIControlStateNormal];
        inchChecked = YES;
        if(cmChecked)
        {
            [self.cmCheckBox setImage:utility.checkBoxImage forState:UIControlStateNormal];
            cmChecked = NO;
        }
        
        utility.settings.measurement = @"inch";
        [FMDBDataAccess updateSettings:utility.settings];
    }
}

- (IBAction)lbsCheckBoxClick:(id)sender
{
    if(!lbsChecked)
    {
        [self.lbsCheckBox setImage:utility.checkBoxMarkedImage forState:UIControlStateNormal];
        lbsChecked = YES;
        if(kgChecked)
        {
            [self.kgCheckBox setImage:utility.checkBoxImage forState:UIControlStateNormal];
            kgChecked = NO;
        }
        
        utility.settings.weight = @"lbs";
        [FMDBDataAccess updateSettings:utility.settings];
    }
}

- (IBAction)kgCheckBoxClick:(id)sender
{
    if(!kgChecked)
    {
        [self.kgCheckBox setImage:utility.checkBoxMarkedImage forState:UIControlStateNormal];
        kgChecked = YES;
        if(lbsChecked)
        {
            [self.lbsCheckBox setImage:utility.checkBoxImage forState:UIControlStateNormal];
            lbsChecked = NO;
        }
        
        utility.settings.weight = @"kg";
        [FMDBDataAccess updateSettings:utility.settings];
    }
}

- (IBAction)setsStepperValueChanged:(id)sender
{
    NSNumber *selectedSetsValue = [NSNumber numberWithInt:self.setsStepper.value];
    self.setsTextField.text = [NSString stringWithFormat:@"%@", selectedSetsValue];
    
    utility.settings.sets = selectedSetsValue;
    [FMDBDataAccess updateSettings:utility.settings];
}

@end
