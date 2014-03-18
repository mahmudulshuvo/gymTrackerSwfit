#import "EquipmentWiseReportViewController.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "PNColor.h"
#import "FMDBDataAccess.h"
#import "Utility.h"
#import "LineChartVO.h"

@interface EquipmentWiseReportViewController ()

@end

@implementation EquipmentWiseReportViewController

NSDate *selectedFromDate;
NSDate *selectedToDate;

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
    
    selectedFromDate = nil;
    selectedToDate = nil;
    
    self.xAxisLegendLabel.hidden = YES;
    self.yAxisLegendLabel.hidden = YES;
    
    self.fromDateTextField.delegate = self;
    self.toDateTextField.delegate = self;
    
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 220.0, SCREEN_WIDTH, 200.0)];
    
    [self.view addSubview:self.lineChart];
    
    self.yAxisLegendLabel.text = [NSString stringWithFormat:@"Y-Axis: Weight values in %@", [Utility sharedInstance].settings.weight];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    if ([self.pmCalendarController isCalendarVisible])
    {
        if(self.pmCalendarController.destinationComp == self.fromDateTextField)
        {
            selectedFromDate = self.pmCalendarController.period.startDate;
            self.fromDateTextField.text = [[Utility sharedInstance].userFriendlyDateFormat stringFromDate: selectedFromDate];
        }
        else if(self.pmCalendarController.destinationComp == self.toDateTextField)
        {
            selectedToDate = self.pmCalendarController.period.startDate;
            self.toDateTextField.text = [[Utility sharedInstance].userFriendlyDateFormat stringFromDate: selectedToDate];
        }
        
        [self.pmCalendarController dismissCalendarAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPMCalendar
{
    self.pmCalendarController = [[MyPMCalendarController alloc] initWithThemeName:@"default"];
    
    self.pmCalendarController.delegate = self;
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

- (IBAction)viewBtn:(id)sender
{
    if ([self.pmCalendarController isCalendarVisible])
    {
        [self.pmCalendarController dismissCalendarAnimated:YES];
    }
    if(selectedFromDate == nil)
    {
        [Utility  showAlert:@"Info" message:@"Please select 'From date'"];
        return;
    }
    else if(selectedToDate == nil)
    {
        [Utility  showAlert:@"Info" message:@"Please select 'To date'"];
        return;
    }
    else if([selectedToDate compare:selectedFromDate] == NSOrderedAscending)
    {
        [Utility  showAlert:@"Warning" message:@"'To date' cannot be less than 'From date'"];
        return;
    }

    NSArray *array = [FMDBDataAccess getWorkoutsByEquipmentId:self.selectedEquipment.id fromDate:[[Utility sharedInstance].dbDateFormat stringFromDate:selectedFromDate] toDate:[[Utility sharedInstance].dbDateFormat stringFromDate:selectedToDate]];
    
    if(array == nil || array.count < 1)
    {
        self.xAxisLegendLabel.hidden = YES;
        self.yAxisLegendLabel.hidden = YES;
        [Utility  showAlert:@"No data" message:@"No data found"];
        return;
    }
    
    int arrayCount = array.count;
    NSMutableArray *chartXLabels = [NSMutableArray new];
    NSMutableArray *chartDatas = [NSMutableArray new];
    for(int i=0;i<arrayCount;i++)
    {
        LineChartVO *lineChartVO = array[i];
        [chartXLabels addObject:[lineChartVO.workoutDate substringWithRange:NSMakeRange(8, 2)]];
        [chartDatas addObject:lineChartVO.workoutSets];
    }
    NSDate *dbFromDate = [[Utility sharedInstance].dbDateFormat dateFromString:((LineChartVO *)array[0]).workoutDate];
    if(array.count > 1)
    {
        NSDate *dbToDate = [[Utility sharedInstance].dbDateFormat dateFromString:((LineChartVO *)array[array.count - 1]).workoutDate];
        self.chartHeader.text = [NSString stringWithFormat:@"%@ to %@", [[Utility sharedInstance].userFriendlyDateFormat stringFromDate:dbFromDate], [[Utility sharedInstance].userFriendlyDateFormat stringFromDate:dbToDate]];
    }
    else
    {
        self.chartHeader.text = [NSString stringWithFormat:@"%@", [[Utility sharedInstance].userFriendlyDateFormat stringFromDate:dbFromDate]];
    }
    
    [self.lineChart setXLabels:chartXLabels];
    PNLineChartData *data = [PNLineChartData new];
    data.color = PNFreshGreen;
    data.itemCount = self.lineChart.xLabels.count;
    data.getData = ^(NSUInteger index)
    {
        CGFloat yValue = [((LineChartVO *)[array objectAtIndex:index]).workoutSets floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data];
    [self.lineChart strokeChart];
    
    self.xAxisLegendLabel.hidden = NO;
    self.yAxisLegendLabel.hidden = NO;
}

@end
