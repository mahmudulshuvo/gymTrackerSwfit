#import "SettingsViewController.h"
#import "Utility.h"
#import "FMDBDataAccess.h"

@interface SettingsViewController ()
{
    BOOL lbsChecked;
    BOOL kgChecked;
}

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[Utility sharedInstance].settings.weight isEqualToString:@"lbs"])
    {
        [self.lbsCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        lbsChecked = YES;
    }
    else
    {
        [self.kgCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        kgChecked = YES;
    }
    int sets = [Utility sharedInstance].settings.sets.intValue;
    self.setsStepper.value = sets;
    self.setsTextField.text = [NSString stringWithFormat:@"%d", sets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtn:(id)sender
{
    NSString *strWeight;
    if(lbsChecked)
        strWeight = @"lbs";
    else if(kgChecked)
        strWeight = @"kg";
    
    [Utility sharedInstance].settings.weight = strWeight;
    [Utility sharedInstance].settings.sets = [NSNumber numberWithInt:self.setsStepper.value];
    
    [FMDBDataAccess updateSettings:[Utility sharedInstance].settings];
}

- (IBAction)lbsCheckBoxClick:(id)sender
{
    if(!lbsChecked)
    {
        [self.lbsCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        lbsChecked = YES;
        if(kgChecked)
        {
            [self.kgCheckBox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            kgChecked = NO;
        }
    }
}

- (IBAction)kgCheckBoxClick:(id)sender
{
    if(!kgChecked)
    {
        [self.kgCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        kgChecked = YES;
        if(lbsChecked)
        {
            [self.lbsCheckBox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            lbsChecked = NO;
        }
    }
}

- (IBAction)setsStepperValueChanged:(id)sender
{
    self.setsTextField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:self.setsStepper.value]];
}

@end
