#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "FMDBDataAccess.h"

@interface SettingsViewController ()
{
    BOOL lbsChecked;
    BOOL kgChecked;
}

@property (nonatomic, readonly) Settings *settings;

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
    if([((AppDelegate *) [[UIApplication sharedApplication] delegate]).settings.weight isEqualToString:@"lbs"])
    {
        [self.lbsCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        lbsChecked = YES;
    }
    else
    {
        [self.kgCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        kgChecked = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Settings *)settings
{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] settings];
}

- (IBAction)saveBtn:(id)sender
{
    NSString *strWeight;
    if(lbsChecked)
        strWeight = @"lbs";
    else if(kgChecked)
        strWeight = @"kg";
    
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).settings.weight = strWeight;
    self.settings.weight = strWeight;
    
    [FMDBDataAccess updateSettings:self.settings];
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

@end
