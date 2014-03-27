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
NSNumber *set1, *set2, *set3, *set4, *set5;

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
    
    if([self.parentControllerName isEqualToString:@"WorkoutNewViewController"])
    {
        self.workout = [FMDBDataAccess loadWorkoutByEquipmentIdAndDate:self.selectedEquipment.id date:self.strSelectedDate];
    }
    else if([self.parentControllerName isEqualToString:@"DateWiseReportViewController"])
    {
        self.workout = [FMDBDataAccess loadWorkout:self.workout];
    }
    
    if(self.workout == nil || self.workout.id == nil)
    {
        newEntry = YES;
        self.workout = [Workout new];
        self.workout.equipmentId = self.selectedEquipment.id;
        self.workout.workoutDate = self.strSelectedDate;
        
        set1 = nil;
        set2 = nil;
        set3 = nil;
        set4 = nil;
        set5 = nil;
    }
    else
    {
        newEntry = NO;
        
        set1 = self.workout.workoutSet1;
        set2 = self.workout.workoutSet2;
        set3 = self.workout.workoutSet3;
        set4 = self.workout.workoutSet4;
        set5 = self.workout.workoutSet5;
        
        self.set1TextField.text = [NSString stringWithFormat:@"%@", set1];
        self.set2TextField.text = [NSString stringWithFormat:@"%@", set2];
        self.set3TextField.text = [NSString stringWithFormat:@"%@", set3];
        self.set4TextField.text = [NSString stringWithFormat:@"%@", set4];
        self.set5TextField.text = [NSString stringWithFormat:@"%@", set5];
    }
    [self enableFieldsBasedOnData];
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

- (void)enableFieldsBasedOnData
{
    if(set1 && set1.floatValue > 0)
    {
        self.set2TextField.enabled = YES;
    }
    else
    {
        self.set2TextField.enabled = NO;
    }
    if(set2 && set2.floatValue > 0)
    {
        self.set3TextField.enabled = YES;
    }
    else
    {
        self.set3TextField.enabled = NO;
    }
    if(set3 && set3.floatValue > 0)
    {
        self.set4TextField.enabled = YES;
    }
    else
    {
        self.set4TextField.enabled = NO;
    }
    if(set4 && set4.floatValue > 0)
    {
        self.set5TextField.enabled = YES;
    }
    else
    {
        self.set5TextField.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self save];
}

- (void)prepareViewBasedOnSets
{
    if(sets == 2)
    {
        self.set3Label.hidden = YES;
        self.set3TextField.hidden = YES;
        self.weightLabel3.hidden = YES;
        
        self.set4Label.hidden = YES;
        self.set4TextField.hidden = YES;
        self.weightLabel4.hidden = YES;
        
        self.set5Label.hidden = YES;
        self.set5TextField.hidden = YES;
        self.weightLabel5.hidden = YES;
    }
    else if(sets == 3)
    {
        self.set3Label.hidden = NO;
        self.set3TextField.hidden = NO;
        self.weightLabel3.hidden = NO;

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

- (void)save
{
    BOOL needsToSave = NO;
    
    if(newEntry)
    {
        if(self.set2TextField.enabled)
        {
            self.workout.workoutSet1 = set1;
            self.workout.workoutSet2 = set2;
            needsToSave = YES;
        }
        if(self.set3TextField.enabled)
            self.workout.workoutSet3 = set3;
        if(self.set4TextField.enabled)
            self.workout.workoutSet4 = set4;
        if(self.set5TextField.enabled)
            self.workout.workoutSet5 = set5;
    }
    else
    {
        if(self.set2TextField.enabled)
        {
            if(set1.floatValue != self.workout.workoutSet1.floatValue)
            {
                self.workout.workoutSet1 = set1;
                needsToSave = YES;
            }
            if(set2.floatValue != self.workout.workoutSet2.floatValue)
            {
                self.workout.workoutSet2 = set2;
                needsToSave = YES;
            }
        }
        if(self.set3TextField.enabled && set3.floatValue != self.workout.workoutSet3.floatValue)
        {
            self.workout.workoutSet3 = set3;
            needsToSave = YES;
        }
        if(self.set4TextField.enabled && set4.floatValue != self.workout.workoutSet4.floatValue)
        {
            self.workout.workoutSet4 = set4;
            needsToSave = YES;
        }
        if(self.set5TextField.enabled && set5.floatValue != self.workout.workoutSet5.floatValue)
        {
            self.workout.workoutSet5 = set5;
            needsToSave = YES;
        }
    }
    
    if(needsToSave)
    {
        if(newEntry)
            [FMDBDataAccess createWorkout:self.workout];
        else
            [FMDBDataAccess updateWorkout:self.workout];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)set1TextFieldEditingChanged:(id)sender
{
    NSString *strSet1 = [self.set1TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    set1 = [[[NSNumberFormatter alloc] init] numberFromString:strSet1];
    [self enableFieldsBasedOnData];
}

- (IBAction)set2TextFieldEditingChanged:(id)sender
{
    NSString *strSet2 = [self.set2TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    set2 = [[[NSNumberFormatter alloc] init] numberFromString:strSet2];
    [self enableFieldsBasedOnData];
}

- (IBAction)set3TextFieldEditingChanged:(id)sender
{
    NSString *strSet3 = [self.set3TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    set3 = [[[NSNumberFormatter alloc] init] numberFromString:strSet3];
    [self enableFieldsBasedOnData];
}

- (IBAction)set4TextFieldEditingChanged:(id)sender
{
    NSString *strSet4 = [self.set4TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    set4 = [[[NSNumberFormatter alloc] init] numberFromString:strSet4];
    [self enableFieldsBasedOnData];
}

- (IBAction)set5TextFieldEditingChanged:(id)sender
{
    NSString *strSet5 = [self.set5TextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    set5= [[[NSNumberFormatter alloc] init] numberFromString:strSet5];
}

@end
