#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

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
        self.lbsSwitch.on = YES;
    else
        self.kgSwitch.on = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (IBAction)saveBtn:(id)sender
{
    NSString *strWeight;
    if(self.lbsSwitch.isOn)
        strWeight = @"lbs";
    else
        strWeight = @"kg";
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).settings.weight = strWeight;
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unable to save! %@ %@", error, [error localizedDescription]);
    }
}

- (IBAction)kgSwitchValueChange:(id)sender
{
    if(self.kgSwitch.isOn)
        self.lbsSwitch.on = NO;
}

- (IBAction)lbsSwitchValueChange:(id)sender
{
    if(self.lbsSwitch.isOn)
        self.kgSwitch.on = NO;
}
@end
