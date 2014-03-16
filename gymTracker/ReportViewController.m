#import "ReportViewController.h"
#import "Equipment.h"
#import "Utility.h"
#import "DateWiseReportViewController.h"
#import "EquipmentWiseReportViewController.h"
#import "FMDBDataAccess.h"

@interface ReportViewController () <DSLCalendarViewDelegate>
{
    BOOL dateWiseReportChecked;
    BOOL equipmentiseReportChecked;
    NSDate *selectedDate;
}

@end

@implementation ReportViewController

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
	[self.dateWiseReportCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    dateWiseReportChecked = YES;
    self.equipmentPicker.hidden = YES;
    self.equipmentWiseReportBtn.hidden = YES;
    self.dateCalenderView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.equipmentsList = [FMDBDataAccess getEquipments];
    
    [self.equipmentPicker reloadAllComponents];
    
    if(self.equipmentsList.count < 1)
    {
        self.dateWiseReportBtn.enabled = NO;
        self.equipmentWiseReportBtn.enabled = NO;
        [Utility showAlert:@"Error" message:@"Please add an Equipment first"];
        return;
    }
    else
    {
        self.dateWiseReportBtn.enabled = YES;
        self.equipmentWiseReportBtn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range
{
    return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ViewDateWiseReport"])
    {
        DateWiseReportViewController *dateWiseReportView = [segue destinationViewController];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dateWiseReportView.strSelectedDate = [dateFormatter stringFromDate:selectedDate];
        
        dateFormatter.dateFormat = @"dd MMMM yyyy";
        dateWiseReportView.title = [dateFormatter stringFromDate:selectedDate];
    }
    
    else if([segue.identifier isEqualToString:@"EquipmentWiseReportView"])
    {
        EquipmentWiseReportViewController *equipmentWiseReportView = [segue destinationViewController];
        NSInteger row = [self.equipmentPicker selectedRowInComponent:0];
        equipmentWiseReportView.selectedEquipment = self.equipmentsList[row];
        equipmentWiseReportView.title = equipmentWiseReportView.selectedEquipment.equipmentName;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"ViewDateWiseReport"])
    {
        selectedDate = self.dateCalenderView.selectedRange.startDay.date;
        if(selectedDate == nil)
        {
            [Utility showAlert:@"Error" message:@"Please select a date"];
            return NO;
        }
    }
    return YES;
}

- (IBAction)dateWiseReportCheckBoxClick:(id)sender
{
    if(!dateWiseReportChecked)
    {
        [self.dateWiseReportCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        dateWiseReportChecked = YES;
        if(equipmentiseReportChecked)
        {
            [self.equipmentWiseReportCheckBox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            equipmentiseReportChecked = NO;
        }
        self.dateCalenderView.hidden = NO;
        self.equipmentPicker.hidden = YES;
        self.equipmentWiseReportBtn.hidden = YES;
        self.dateWiseReportBtn.hidden = NO;
    }
}

- (IBAction)equipmentWiseReportCheckBoxClick:(id)sender
{
    if(!equipmentiseReportChecked)
    {
        [self.equipmentWiseReportCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        equipmentiseReportChecked = YES;
        if(dateWiseReportChecked)
        {
            [self.dateWiseReportCheckBox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            dateWiseReportChecked = NO;
        }
        self.equipmentPicker.hidden = NO;
        self.dateCalenderView.hidden = YES;
        self.dateWiseReportBtn.hidden = YES;
        self.equipmentWiseReportBtn.hidden = NO;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Equipment *equipment = [self.equipmentsList objectAtIndex:row];
    return equipment.equipmentName;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return self.equipmentsList.count;
}

@end
