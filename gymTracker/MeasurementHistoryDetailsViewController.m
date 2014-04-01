#import "MeasurementHistoryDetailsViewController.h"
#import "Utility.h"
#import "MeasurementHistory.h"
#import "FMDBDataAccess.h"

@interface MeasurementHistoryDetailsViewController ()

@end

@implementation MeasurementHistoryDetailsViewController

BOOL newEntry;
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
    
    self.measurementTypeLabel.text = utility.settings.measurement;
    
	self.sizeTextField.delegate = self;
    
    if([self.parentControllerName isEqualToString:@"MeasurementHistoryNewViewController"])
    {
        self.measurementHistory = [FMDBDataAccess loadMeasurementHistoryByMeasurementIdAndDate:self.selectedMeasurement.id date:self.strSelectedDate];
    }
    else if([self.parentControllerName isEqualToString:@"DateWiseMeasurementViewController"])
    {
        self.measurementHistory = [FMDBDataAccess loadMeasurementHistory:self.measurementHistory];
    }
    
    if(self.measurementHistory == nil || self.measurementHistory.id == nil)
    {
        newEntry = YES;
        self.measurementHistory = [MeasurementHistory new];
        self.measurementHistory.measurementId = self.selectedMeasurement.id;
        self.measurementHistory.measurementDate = self.strSelectedDate;
    }
    else
    {
        newEntry = NO;
        self.sizeTextField.text = [NSString stringWithFormat:@"%@", self.measurementHistory.size];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self save];
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
    NSString *strSize = [self.sizeTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSNumber *size = [[[NSNumberFormatter alloc] init] numberFromString:strSize];
    
    BOOL needsToSave = YES;
    
    if(!size || size.floatValue < 1)
        needsToSave = NO;
    else if(size.floatValue == self.measurementHistory.size.floatValue)
        needsToSave = NO;
    else
        self.measurementHistory.size = size;
    
    if(needsToSave)
    {
        if(newEntry)
            [FMDBDataAccess createMeasurementHistory:self.measurementHistory];
        else
            [FMDBDataAccess updateMeasurementHistory:self.measurementHistory];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end
