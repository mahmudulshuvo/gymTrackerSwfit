#import "MeasureViewController.h"
#import "Utility.h"
#import "FMDBDataAccess.h"

@interface MeasureViewController ()

@end

@implementation MeasureViewController

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

	self.measurementNameTextField.delegate = self;
    if(_selectedMeasurement != nil)
    {
        self.measurementNameTextField.text = [NSString stringWithFormat:@"%@", _selectedMeasurement.measurementName];
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
    NSString *strMeasurementName = [self.measurementNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strMeasurementName.length == 0)
    {
        [Utility showAlert:@"Error" message:@"Measurement name is required"];
        return;
    }
    
    BOOL newEntry = NO;
    
    if(_selectedMeasurement == nil)
    {
        NSUInteger totalMeasurementsCount = utility.measurementsList.count;
        for(int i=0;i<totalMeasurementsCount;i++)
        {
            Measurement *measurementFromArray = [utility.measurementsList objectAtIndex:i];
            if([[measurementFromArray.measurementName lowercaseString] isEqualToString:[strMeasurementName lowercaseString]])
            {
                [Utility showAlert:@"Error" message:@"The specified Measurement name already exists"];
                return;
            }
        }
        
        _selectedMeasurement = [Measurement new];
        
        newEntry = YES;
    }
    
    _selectedMeasurement.measurementName = strMeasurementName;
    
    if(newEntry)
        [FMDBDataAccess createMeasurement:_selectedMeasurement];
    else
        [FMDBDataAccess updateMeasurement:_selectedMeasurement];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
