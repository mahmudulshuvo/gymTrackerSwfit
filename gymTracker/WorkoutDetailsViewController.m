#import "WorkoutDetailsViewController.h"
#import "Utility.h"
#import "Workout.h"
#import "FMDBDataAccess.h"

@interface WorkoutDetailsViewController ()

@end

@implementation WorkoutDetailsViewController

BOOL newEntry;

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
    
    NSString *weightLabelValue = [Utility sharedInstance].settings.weight;
    if(![self.weightLabel1.text isEqualToString:weightLabelValue])
    {
        self.weightLabel1.text = weightLabelValue;
        self.weightLabel2.text = weightLabelValue;
        self.weightLabel3.text = weightLabelValue;
    }
    
	self.set1TextField.delegate = self;
    self.set2TextField.delegate = self;
    self.set3TextField.delegate = self;
    
    NSString *strToday = [[Utility sharedInstance].dbDateFormat stringFromDate:[NSDate date]];
    
    self.workout = [FMDBDataAccess loadWorkoutByEquipmentIdAndDate:self.selectedEquipment.id date:strToday];
    if(self.workout == nil || self.workout.id == nil)
    {
        newEntry = YES;
        self.workout = [[Workout alloc]init];
        self.workout.equipmentId = self.selectedEquipment.id;
        self.workout.workoutDate = strToday;
    }
    else
    {
        newEntry = NO;
        self.set1TextField.text = [NSString stringWithFormat:@"%@", self.workout.workoutSet1];
        self.set2TextField.text = [NSString stringWithFormat:@"%@", self.workout.workoutSet2];
        self.set3TextField.text = [NSString stringWithFormat:@"%@", self.workout.workoutSet3];
    }
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
        [[Utility sharedInstance] showAlert:@"Error" message:@"Set 1 field is required"];
        return;
    }
    
    NSNumber *set1 = [[[NSNumberFormatter alloc] init] numberFromString:strSet1];
    if(!set1 || [set1 floatValue] < 1)
    {
        [[Utility sharedInstance] showAlert:@"Error" message:@"Please insert a valid number in Set 1 field"];
        return;
    }
    
    NSString *strSet2 = [self.set2TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strSet2.length > 0)
    {
        NSNumber *set2 = [[[NSNumberFormatter alloc] init] numberFromString:strSet2];
        if(!set2 || [set2 floatValue] < 0)
        {
            [[Utility sharedInstance] showAlert:@"Error" message:@"Please insert a valid number in Set 2 field"];
            return;
        }
        self.workout.workoutSet2 = set2;
    }

    NSString *strSet3 = [self.set3TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strSet3.length > 0)
    {
        NSNumber *set3 = [[[NSNumberFormatter alloc] init] numberFromString:strSet3];
        if(!set3 || [set3 floatValue] < 0)
        {
            [[Utility sharedInstance] showAlert:@"Error" message:@"Please insert a valid number in Set 3 field"];
            return;
        }
        self.workout.workoutSet3 = set3;
    }
    
    self.workout.workoutSet1 = set1;

    if(newEntry)
        [FMDBDataAccess createWorkout:self.workout];
    else
        [FMDBDataAccess updateWorkout:self.workout];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
