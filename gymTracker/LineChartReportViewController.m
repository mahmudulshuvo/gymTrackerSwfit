#import "LineChartReportViewController.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "PNColor.h"
#import "FMDBDataAccess.h"
#import "Utility.h"
#import "LineChartVO.h"
#import "LineChartMeasureOnlyViewController.h"

@interface LineChartReportViewController ()

@end

@implementation LineChartReportViewController

NSArray *dbDataArray;
NSMutableArray *chartXLabels;
NSMutableArray *chartDatas;
PNLineChartData *data;
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
    
    self.legendImageView.hidden = YES;
    
    if([self.reportType isEqualToString:@"Workout"])
        dbDataArray = [FMDBDataAccess getWorkoutsByEquipmentId:self.equipmentId fromDate:[utility.dbDateFormat stringFromDate:self.selectedFromDate] toDate:[utility.dbDateFormat stringFromDate:self.selectedToDate]];
    else
        dbDataArray = [FMDBDataAccess getMeasurementHistoryByMeasurementId:self.measurementId fromDate:[utility.dbDateFormat stringFromDate:self.selectedFromDate] toDate:[utility.dbDateFormat stringFromDate:self.selectedToDate]];
    
    if(dbDataArray == nil || dbDataArray.count < 1)
    {
        self.legendImageView.hidden = YES;
        [Utility showAlert:@"Info" message:@"No data found"];
        return;
    }
    
    [self.legendImageView setImage:[UIImage imageNamed:self.imageName]];
    
    int arrayCount = dbDataArray.count;
    chartXLabels = [NSMutableArray new];
    chartDatas = [NSMutableArray new];
    if(arrayCount < 19)
    {
        for(int i=0;i<arrayCount;i++)
        {
            LineChartVO *lineChartVO = dbDataArray[i];
            [chartXLabels addObject:[lineChartVO.date substringWithRange:NSMakeRange(8, 2)]];
            [chartDatas addObject:lineChartVO.value];
        }
    }
    else
    {
        for(int i=0;i<arrayCount;i++)
        {
            LineChartVO *lineChartVO = dbDataArray[i];
            [chartXLabels addObject:@""];
            [chartDatas addObject:lineChartVO.value];
        }
    }
    
    NSDate *dbFromDate = [utility.dbDateFormat dateFromString:((LineChartVO *)dbDataArray[0]).date];
    if(arrayCount > 1)
    {
        NSDate *dbToDate = [utility.dbDateFormat dateFromString:((LineChartVO *)dbDataArray[dbDataArray.count - 1]).date];
        self.chartHeader.text = [NSString stringWithFormat:@"%@ to %@", [utility.userFriendlyDateFormat stringFromDate:dbFromDate], [utility.userFriendlyDateFormat stringFromDate:dbToDate]];
    }
    else
    {
        self.chartHeader.text = [NSString stringWithFormat:@"%@", [utility.userFriendlyDateFormat stringFromDate:dbFromDate]];
    }
    
    if(self.lineChart != nil)
    {
        [self.lineChart removeFromSuperview];
        self.lineChart = nil;
    }
    
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 140.0, SCREEN_WIDTH, 200.0)];
    [self.view addSubview:self.lineChart];
    
    [self.lineChart setXLabels:chartXLabels];
    
    data = [PNLineChartData new];
    data.color = PNFreshGreen;
    data.itemCount = chartXLabels.count;
    data.getData = ^(NSUInteger index)
    {
        return [PNLineChartDataItem dataItemWithY:[[chartDatas objectAtIndex:index] floatValue]];
    };
    
    self.lineChart.chartData = @[data];
    [self.lineChart strokeChart];
    
    self.legendImageView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(dbDataArray == nil || dbDataArray.count < 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if(self.measurementName == nil)
        {
            self.bodyPartButton.hidden = YES;
        }
        else
        {
            self.bodyPartButton.hidden = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"LineChartMeasureMentView"])
    {
        LineChartMeasureOnlyViewController *lineChartReportView = [segue destinationViewController];
        lineChartReportView.measurementId = self.measurementId;
        lineChartReportView.title = self.measurementName;
        lineChartReportView.selectedFromDate = self.selectedFromDate;
        lineChartReportView.selectedToDate = self.selectedToDate;
    }
}

@end
