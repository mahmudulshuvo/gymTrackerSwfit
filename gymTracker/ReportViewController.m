#import "ReportViewController.h"
#import "Equipment.h"
#import "Utility.h"
#import "LineChartReportViewController.h"
#import "FMDBDataAccess.h"
#import "NSDate+TKCategory.h"

@interface ReportViewController ()

@end

@implementation ReportViewController
{
    BOOL equipmentChecked;
    BOOL measurementChecked;
}

NSDate *selectedFromDate;
NSDate *selectedToDate;
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
    
    NSDate *today = [NSDate date];
    selectedFromDate = [today dateByAddingDays:-15];
    selectedToDate = today;
    
    [self equipmentCheckBoxClick:nil];
    
    self.fromDateTextField.text = [utility.userFriendlyDateFormat stringFromDate: selectedFromDate];
    self.toDateTextField.text = [utility.userFriendlyDateFormat stringFromDate: selectedToDate];
    
    self.fromDateTextField.delegate = self;
    self.toDateTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.pickerView reloadAllComponents];
    
    if(utility.equipmentsList.count < 1)
    {
        self.equipmentWiseReportBtn.enabled = NO;
        [Utility showAlert:@"Error" message:@"Please add an Equipment first"];
        return;
    }
    else
    {
        self.equipmentWiseReportBtn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    if ([self.pmCalendarController isCalendarVisible])
    {
        if(self.pmCalendarController.destinationComp == self.fromDateTextField)
        {
            selectedFromDate = self.pmCalendarController.period.startDate;
            self.fromDateTextField.text = [utility.userFriendlyDateFormat stringFromDate: selectedFromDate];
        }
        else if(self.pmCalendarController.destinationComp == self.toDateTextField)
        {
            selectedToDate = self.pmCalendarController.period.startDate;
            self.toDateTextField.text = [utility.userFriendlyDateFormat stringFromDate: selectedToDate];
        }
        
        [self.pmCalendarController dismissCalendarAnimated:YES];
    }
}

- (void)loadPMCalendar
{
    self.pmCalendarController = [[MyPMCalendarController alloc] initWithThemeName:@"default"];
    
    self.pmCalendarController.delegate = self;
    self.pmCalendarController.allowedPeriod = [PMPeriod periodWithStartDate:nil endDate:[NSDate date]];
    self.pmCalendarController.allowsLongPressMonthChange = YES;
    self.pmCalendarController.mondayFirstDayOfWeek = NO;
    self.pmCalendarController.allowsPeriodSelection = NO;
}

- (IBAction)fromDateTextFieldTouchDown:(id)sender
{
    [self.fromDateTextField resignFirstResponder];
    [self loadPMCalendar];
    
    float xValue = self.fromDateTextField.frame.origin.x + ((self.fromDateTextField.frame.size.width / 2) - 35);
    float yValue = self.fromDateTextField.frame.origin.y + self.fromDateTextField.frame.size.height;
    
    [self.pmCalendarController presentCalendarFromRect:CGRectMake(xValue, yValue, 0, 0)
                                                inView:[sender superview]
                              permittedArrowDirections:PMCalendarArrowDirectionAny
                                             isPopover:YES
                                              animated:YES];
    self.pmCalendarController.destinationComp = self.fromDateTextField;
}

- (IBAction)toDateTextFieldTouchDown:(id)sender
{
    [self.toDateTextField resignFirstResponder];
    [self loadPMCalendar];
    
    float xValue = self.toDateTextField.frame.origin.x + ((self.toDateTextField.frame.size.width / 2) - 35);
    float yValue = self.toDateTextField.frame.origin.y + self.toDateTextField.frame.size.height;
    
    [self.pmCalendarController presentCalendarFromRect:CGRectMake(xValue, yValue, 0, 0)
                                                inView:[sender superview]
                              permittedArrowDirections:PMCalendarArrowDirectionAny
                                             isPopover:YES
                                              animated:YES];
    self.pmCalendarController.destinationComp = self.toDateTextField;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"LineChartReportView"])
    {
        LineChartReportViewController *lineChartReportView = [segue destinationViewController];
        NSInteger row = [self.pickerView selectedRowInComponent:0];
        lineChartReportView.selectedFromDate = selectedFromDate;
        lineChartReportView.selectedToDate = selectedToDate;
        if(equipmentChecked)
        {
            Equipment *equipment = utility.equipmentsList[row];
            lineChartReportView.dbId = equipment.id;
            lineChartReportView.title = equipment.equipmentName;
            lineChartReportView.reportType = @"Workout";
            lineChartReportView.imageName = @"legend_equipment.png";
        }
        else
        {
            Measurement *measurement = utility.measurementsList[row];
            lineChartReportView.dbId = measurement.id;
            lineChartReportView.title = measurement.measurementName;
            lineChartReportView.reportType = @"Measurement";
            lineChartReportView.imageName = @"legend_measurement.png";
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self.pmCalendarController isCalendarVisible])
    {
        [self.pmCalendarController dismissCalendarAnimated:YES];
    }
    if(selectedFromDate == nil)
    {
        [Utility showAlert:@"Info" message:@"Please select 'From date'"];
        return NO;
    }
    else if(selectedToDate == nil)
    {
        [Utility showAlert:@"Info" message:@"Please select 'To date'"];
        return NO;
    }
    else if([selectedToDate compare:selectedFromDate] == NSOrderedAscending)
    {
        [Utility showAlert:@"Warning" message:@"'To date' cannot be less than 'From date'"];
        return NO;
    }
    /*else if([selectedFromDate compare:[NSDate date]] == NSOrderedDescending)
     {
     [Utility showAlert:@"Warning" message:@"'From date' should not be greater than current date"];
     return NO;
     }
     else if([selectedToDate compare:[NSDate date]] == NSOrderedDescending)
     {
     [Utility showAlert:@"Warning" message:@"'To date' should not be greater than current date"];
     return NO;
     }*/
    return YES;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(equipmentChecked)
    {
        Equipment *equipment = [utility.equipmentsList objectAtIndex:row];
        return equipment.equipmentName;
    }
    else
    {
        Measurement *measurement = [utility.measurementsList objectAtIndex:row];
        return measurement.measurementName;
    }
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if(equipmentChecked)
        return utility.equipmentsList.count;
    else
        return utility.measurementsList.count;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (IBAction)equipmentCheckBoxClick:(id)sender
{
    if(!equipmentChecked)
    {
        [self.equipmentCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        equipmentChecked = YES;
        if(measurementChecked)
        {
            [self.measurementCheckBox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            measurementChecked = NO;
        }
        [self.pickerView reloadAllComponents];
    }
}

- (IBAction)measurementCheckBoxClick:(id)sender
{
    if(!measurementChecked)
    {
        [self.measurementCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        measurementChecked = YES;
        if(equipmentChecked)
        {
            [self.equipmentCheckBox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            equipmentChecked = NO;
        }
        [self.pickerView reloadAllComponents];
    }
}

@end
