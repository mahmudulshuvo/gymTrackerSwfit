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

NSArray *workoutDataArray;
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
    
    workoutDataArray = [FMDBDataAccess getWorkoutsByEquipmentId:self.selectedEquipment.id fromDate:[utility.dbDateFormat stringFromDate:self.selectedFromDate] toDate:[utility.dbDateFormat stringFromDate:self.selectedToDate]];
    
    if(workoutDataArray == nil || workoutDataArray.count < 1)
    {
        self.legendImageView.hidden = YES;
        [Utility showAlert:@"Info" message:@"No data found"];
        return;
    }
    
    int arrayCount = workoutDataArray.count;
    chartXLabels = [NSMutableArray new];
    chartDatas = [NSMutableArray new];
    if(arrayCount < 19)
    {
        for(int i=0;i<arrayCount;i++)
        {
            LineChartVO *lineChartVO = workoutDataArray[i];
            [chartXLabels addObject:[lineChartVO.workoutDate substringWithRange:NSMakeRange(8, 2)]];
            [chartDatas addObject:lineChartVO.workoutSets];
        }
    }
    else
    {
        for(int i=0;i<arrayCount;i++)
        {
            LineChartVO *lineChartVO = workoutDataArray[i];
            [chartXLabels addObject:@""];
            [chartDatas addObject:lineChartVO.workoutSets];
        }
    }
    
    NSDate *dbFromDate = [utility.dbDateFormat dateFromString:((LineChartVO *)workoutDataArray[0]).workoutDate];
    if(arrayCount > 1)
    {
        NSDate *dbToDate = [utility.dbDateFormat dateFromString:((LineChartVO *)workoutDataArray[workoutDataArray.count - 1]).workoutDate];
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
    
    if(workoutDataArray == nil || workoutDataArray.count < 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
