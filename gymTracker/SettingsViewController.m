#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "Utility.h"

@interface SettingsViewController ()
{
    BOOL lbsChecked;
    BOOL kgChecked;
}

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

- (NSManagedObjectContext *)managedObjectContext
{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (IBAction)saveBtn:(id)sender
{
    NSString *strWeight;
    if(lbsChecked)
        strWeight = @"lbs";
    else if(kgChecked)
        strWeight = @"kg";
    
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).settings.weight = strWeight;
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unable to save! %@ %@", error, [error localizedDescription]);
    }
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
