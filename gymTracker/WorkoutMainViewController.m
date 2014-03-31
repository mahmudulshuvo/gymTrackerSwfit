#import "WorkoutMainViewController.h"
#import "FMDBDataAccess.h"
#import "Utility.h"
#import "NSDate+TKCategory.h"
#import "DateWiseReportViewController.h"

@interface WorkoutMainViewController ()

@end

@implementation WorkoutMainViewController

Utility *utility;
NSDate *selectedDate;
BOOL activityChecked;
BOOL measureChecked;

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
    
    [self activityCheckBoxClick:nil];
    
    self.dateCalenderView = [TKCalendarMonthView new];
    self.dateCalenderView.delegate = self;
    self.dateCalenderView.dataSource = self;
    
    [self.dateCalenderView selectDate:[NSDate date]];
    
    [self.calendarContainer addSubview:self.dateCalenderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(utility.equipmentsList.count < 1)
    {
        [Utility showAlert:@"Info" message:@"Please add an Equipment first"];
        return;
    }
    
    [self.dateCalenderView reloadData];
}

- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
    return [self populateCalendarThroughStartDate:startDate endDate:lastDate];
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date
{
    NSDate *today = [NSDate date];
    if([date compare:today] == NSOrderedDescending)
    {
        [monthView selectDate:[NSDate date]];
    }
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)d animated:(BOOL)animated
{
    NSDate *today = [NSDate date];
    if([d compare:today] == NSOrderedDescending)
    {
        [monthView selectDate:[NSDate date]];
    }
}

- (NSArray *) populateCalendarThroughStartDate:(NSDate*)start endDate:(NSDate*)end
{
	NSMutableArray *marks = [NSMutableArray array];
    NSArray *dates;
    if(activityChecked)
        dates = [FMDBDataAccess getWorkoutDates];
    else
        dates = [FMDBDataAccess getMeasurementHistoryDates];
    
    NSDate *d = start;
    
	while(YES)
    {
        NSString *simplifiedStart = [utility.dbDateFormat stringFromDate:d];
        
		if ([dates containsObject:simplifiedStart])
        {
            [marks addObject:[NSNumber numberWithBool:YES]];
        }
        else
        {
            [marks addObject:[NSNumber numberWithBool:NO]];
        }
		
		NSDateComponents *info = [d dateComponentsWithTimeZone:self.dateCalenderView.timeZone];
		info.day++;
		d = [NSDate dateWithDateComponents:info];
		if([d compare:end] == NSOrderedDescending) break;
	}
    
    return marks;
	
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ViewDateWiseReport"])
    {
        DateWiseReportViewController *dateWiseReportView = [segue destinationViewController];
        
        dateWiseReportView.strSelectedDate = [utility.dbDateFormat stringFromDate:selectedDate];
        
        dateWiseReportView.title = [utility.userFriendlyDateFormat stringFromDate:selectedDate];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"ViewDateWiseReport"])
    {
        selectedDate = self.dateCalenderView.dateSelected;
        if(selectedDate == nil)
        {
            [Utility showAlert:@"Error" message:@"Please select a date"];
            return NO;
        }
        return YES;
    }
    return NO;
}

- (IBAction)activityCheckBoxClick:(id)sender
{
    if(!activityChecked)
    {
        [self.activityCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        activityChecked = YES;
        self.viewActivityBtn.hidden = NO;
        self.viewMeasureBtn.hidden = YES;
        if(measureChecked)
        {
            [self.measureCheckBox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            measureChecked = NO;
        }
        [self.dateCalenderView reloadData];
    }
}

- (IBAction)measureCheckBoxClick:(id)sender
{
    if(!measureChecked)
    {
        [self.measureCheckBox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        measureChecked = YES;
        self.viewMeasureBtn.hidden = NO;
        self.viewActivityBtn.hidden = YES;
        if(activityChecked)
        {
            [self.activityCheckBox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            activityChecked = NO;
        }
        [self.dateCalenderView reloadData];
    }
}

@end
