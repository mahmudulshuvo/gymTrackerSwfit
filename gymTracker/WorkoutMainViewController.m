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
        [Utility showAlert:@"Error" message:@"Please add an Equipment first"];
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
    NSArray *workoutDates = [FMDBDataAccess getWorkoutDates];
    
    NSDate *d = start;
    
	while(YES)
    {
        NSString *simplifiedStart = [utility.dbDateFormat stringFromDate:d];
        
		if ([workoutDates containsObject:simplifiedStart])
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

@end
