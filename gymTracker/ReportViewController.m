#import "ReportViewController.h"
#import "Equipment.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "DateWiseReportViewController.h"
#import "EquipmentWiseReportViewController.h"

@interface ReportViewController ()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

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
	self.datePicker.hidden = YES;
    self.equipmentPicker.hidden = YES;
    self.dateWiseReportBtn.hidden = YES;
    self.equipmentWiseReportBtn.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Equipment"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"equipmentName" ascending:YES], nil];
    
    self.equipmentsList = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    
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

- (NSManagedObjectContext *)managedObjectContext
{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ViewDateWiseReport"])
    {
        DateWiseReportViewController *dateWiseReportView = [segue destinationViewController];
        dateWiseReportView.selectedDate = self.datePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"dd MMMM yyyy";
        dateWiseReportView.title = [dateFormatter stringFromDate:dateWiseReportView.selectedDate];
    }
    
    else if([segue.identifier isEqualToString:@"EquipmentWiseReportView"])
    {
        EquipmentWiseReportViewController *equipmentWiseReportView = [segue destinationViewController];
        NSInteger row = [self.equipmentPicker selectedRowInComponent:0];
        equipmentWiseReportView.selectedEquipment = self.equipmentsList[row];
        equipmentWiseReportView.title = equipmentWiseReportView.selectedEquipment.equipmentName;
    }
}

- (IBAction)dateSwitchValueChange:(id)sender
{
    if(self.dateSwitch.isOn)
    {
        self.equipmentSwitch.on = NO;
        self.datePicker.hidden = NO;
        self.equipmentPicker.hidden = YES;
        self.equipmentWiseReportBtn.hidden = YES;
        self.dateWiseReportBtn.hidden = NO;
    }
    else
    {
        self.datePicker.hidden = YES;
        self.dateWiseReportBtn.hidden = YES;
    }
}

- (IBAction)equipmentSwitchValueChange:(id)sender
{
    if(self.equipmentSwitch.isOn)
    {
        self.dateSwitch.on = NO;
        self.equipmentPicker.hidden = NO;
        self.datePicker.hidden = YES;
        self.dateWiseReportBtn.hidden = YES;
        self.equipmentWiseReportBtn.hidden = NO;
    }
    else
    {
        self.equipmentPicker.hidden = YES;
        self.equipmentWiseReportBtn.hidden = YES;
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
