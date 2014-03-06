#import "WorkoutDetailsViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "Workout.h"

@interface WorkoutDetailsViewController ()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end

@implementation WorkoutDetailsViewController

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
	self.set1TextField.delegate = self;
    self.set2TextField.delegate = self;
    self.set3TextField.delegate = self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtn:(id)sender
{
    NSString *strSet1 = [self.set1TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strSet1.length == 0)
    {
        [Utility showAlert:@"Error" message:@"Set 1 field is required"];
        return;
    }
    
    NSNumber *set1 = [[[NSNumberFormatter alloc] init] numberFromString:strSet1];
    if(!set1 || [set1 floatValue] < 1)
    {
        [Utility showAlert:@"Error" message:@"Please insert a valid number in Set 1 field"];
        return;
    }
    
    NSString *strSet2 = [self.set1TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strSet2.length == 0)
    {
        [Utility showAlert:@"Error" message:@"Set 2 field is required"];
        return;
    }
    
    NSNumber *set2 = [[[NSNumberFormatter alloc] init] numberFromString:strSet2];
    if(!set2 || [set2 floatValue] < 1)
    {
        [Utility showAlert:@"Error" message:@"Please insert a valid number in Set 2 field"];
        return;
    }

    NSString *strSet3 = [self.set1TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strSet3.length == 0)
    {
        [Utility showAlert:@"Error" message:@"Set 3 field is required"];
        return;
    }
    
    NSNumber *set3 = [[[NSNumberFormatter alloc] init] numberFromString:strSet3];
    if(!set3 || [set3 floatValue] < 1)
    {
        [Utility showAlert:@"Error" message:@"Please insert a valid number in Set 3 field"];
        return;
    }
    
    Workout *workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:self.managedObjectContext];
    workout.equipment = _selectedEquipment;
    workout.workoutSet1 = set1;
    workout.workoutSet2 = set2;
    workout.workoutSet3 = set3;
    NSDate *today = [NSDate date];
    workout.workoutDate = today;

    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unable to save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
