#import "WorkoutDetailsViewController.h"
#import "Utility.h"
#import "Workout.h"
#import "FMDBDataAccess.h"

@interface WorkoutDetailsViewController ()

@end

@implementation WorkoutDetailsViewController

BOOL newEntry;
int sets;
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
    
    sets = utility.settings.sets.intValue;
    [self prepareViewBasedOnSets];
    
	self.set1TextField.delegate = self;
    self.set2TextField.delegate = self;
    self.set3TextField.delegate = self;
    self.set4TextField.delegate = self;
    self.set5TextField.delegate = self;
    
    NSString *strToday = [utility.dbDateFormat stringFromDate:[NSDate date]];
    
    self.workout = [FMDBDataAccess loadWorkoutByEquipmentIdAndDate:self.selectedEquipment.id date:strToday];
    if(self.workout == nil || self.workout.id == nil)
    {
        newEntry = YES;
        self.workout = [Workout new];
        self.workout.equipmentId = self.selectedEquipment.id;
        self.workout.workoutDate = strToday;
    }
    else
    {
        newEntry = NO;
        self.set1TextField.text = [NSString stringWithFormat:@"%@", self.workout.workoutSet1];
        self.set2TextField.text = [NSString stringWithFormat:@"%@", self.workout.workoutSet2];
        self.set3TextField.text = [NSString stringWithFormat:@"%@", self.workout.workoutSet3];
        self.set4TextField.text = [NSString stringWithFormat:@"%@", self.workout.workoutSet4];
        self.set5TextField.text = [NSString stringWithFormat:@"%@", self.workout.workoutSet5];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *weightLabelValue = utility.settings.weight;
    if(![self.weightLabel1.text isEqualToString:weightLabelValue])
    {
        self.weightLabel1.text = weightLabelValue;
        self.weightLabel2.text = weightLabelValue;
        self.weightLabel3.text = weightLabelValue;
        self.weightLabel4.text = weightLabelValue;
        self.weightLabel5.text = weightLabelValue;
    }
    if(sets != utility.settings.sets.intValue)
    {
        sets = utility.settings.sets.intValue;
        [self prepareViewBasedOnSets];
    }
}

- (void)prepareViewBasedOnSets
{
    if(sets == 3)
    {
        self.set4Label.hidden = YES;
        self.set4TextField.hidden = YES;
        self.weightLabel4.hidden = YES;
        
        self.set5Label.hidden = YES;
        self.set5TextField.hidden = YES;
        self.weightLabel5.hidden = YES;
    }
    else if(sets == 4)
    {
        self.set4Label.hidden = NO;
        self.set4TextField.hidden = NO;
        self.weightLabel4.hidden = NO;
        
        self.set5Label.hidden = YES;
        self.set5TextField.hidden = YES;
        self.weightLabel5.hidden = YES;
    }
    else if(sets == 5)
    {
        self.set4Label.hidden = NO;
        self.set4TextField.hidden = NO;
        self.weightLabel4.hidden = NO;
        
        self.set5Label.hidden = NO;
        self.set5TextField.hidden = NO;
        self.weightLabel5.hidden = NO;
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
        [Utility showAlert:@"Error" message:@"Set 1 field is required"];
        return;
    }
    
    NSNumber *set1 = [[[NSNumberFormatter alloc] init] numberFromString:strSet1];
    if(!set1 || [set1 floatValue] < 1)
    {
        [Utility showAlert:@"Error" message:@"Please insert a valid number in Set 1 field"];
        return;
    }
    
    NSString *strSet2 = [self.set2TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strSet2.length > 0)
    {
        NSNumber *set2 = [[[NSNumberFormatter alloc] init] numberFromString:strSet2];
        if(!set2 || [set2 floatValue] < 0)
        {
            [Utility showAlert:@"Error" message:@"Please insert a valid number in Set 2 field"];
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
            [Utility showAlert:@"Error" message:@"Please insert a valid number in Set 3 field"];
            return;
        }
        self.workout.workoutSet3 = set3;
    }
    
    NSString *strSet4 = [self.set4TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strSet4.length > 0)
    {
        NSNumber *set4 = [[[NSNumberFormatter alloc] init] numberFromString:strSet4];
        if(!set4 || [set4 floatValue] < 0)
        {
            [Utility showAlert:@"Error" message:@"Please insert a valid number in Set 4 field"];
            return;
        }
        self.workout.workoutSet4 = set4;
    }
    
    NSString *strSet5 = [self.set5TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strSet5.length > 0)
    {
        NSNumber *set5 = [[[NSNumberFormatter alloc] init] numberFromString:strSet5];
        if(!set5 || [set5 floatValue] < 0)
        {
            [Utility showAlert:@"Error" message:@"Please insert a valid number in Set 5 field"];
            return;
        }
        self.workout.workoutSet5 = set5;
    }
    
    self.workout.workoutSet1 = set1;

    if(newEntry)
        [FMDBDataAccess createWorkout:self.workout];
    else
        [FMDBDataAccess updateWorkout:self.workout];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
