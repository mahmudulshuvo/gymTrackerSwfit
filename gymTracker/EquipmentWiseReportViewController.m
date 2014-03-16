#import "EquipmentWiseReportViewController.h"
#import "PNLineChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "PNColor.h"
#import "FMDBDataAccess.h"
#import "Utility.h"
#import "LineChartVO.h"

@interface EquipmentWiseReportViewController ()

@end

@implementation EquipmentWiseReportViewController

NSArray *array;

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
	
    array = [FMDBDataAccess getWorkoutsByEquipmentId:self.selectedEquipment.id];
    
    if(array == nil || array.count < 1) return;
    
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    int arrayCount = array.count;
    NSMutableArray *chartXLabels = [[NSMutableArray alloc]init];
    NSMutableArray *chartDatas = [[NSMutableArray alloc]init];
    for(int i=0;i<arrayCount;i++)
    {
        LineChartVO *lineChartVO = array[i];
        [chartXLabels addObject:lineChartVO.workoutDate];
        [chartDatas addObject:lineChartVO.workoutSets];
    }
    
    [lineChart setXLabels:chartXLabels];
    PNLineChartData *data = [PNLineChartData new];
    data.color = PNFreshGreen;
    data.itemCount = lineChart.xLabels.count;
    data.getData = ^(NSUInteger index)
    {
        CGFloat yValue = [((LineChartVO *)[array objectAtIndex:index]).workoutSets floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data];
    [self.view addSubview:lineChart];
    
    [lineChart strokeChart];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(array == nil || array.count < 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [Utility showAlert:@"No data" message:@"No data found"];
    }
}

/*- (void)showDummyChart
{
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data01Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data01, data02];
    [self.view addSubview:lineChart];
    
    [lineChart strokeChart];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
