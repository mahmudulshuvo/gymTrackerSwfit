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
        //[chartXLabels addObject:lineChartVO.workoutDate];
        [chartXLabels addObject:@"*"];
        [chartDatas addObject:lineChartVO.workoutSets];
    }
    NSDate *fromDate = [[Utility sharedInstance].dbDateFormat dateFromString:((LineChartVO *)array[0]).workoutDate];
    if(array.count > 1)
    {
        NSDate *toDate = [[Utility sharedInstance].dbDateFormat dateFromString:((LineChartVO *)array[array.count - 1]).workoutDate];
        self.chartHeader.text = [NSString stringWithFormat:@"%@ to %@", [[Utility sharedInstance].userFriendlyDateFormat stringFromDate:fromDate], [[Utility sharedInstance].userFriendlyDateFormat stringFromDate:toDate]];
    }
    else
    {
        self.chartHeader.text = [NSString stringWithFormat:@"%@", [[Utility sharedInstance].userFriendlyDateFormat stringFromDate:fromDate]];
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
    self.yAxisLegendLabel.text = [NSString stringWithFormat:@"Y-Axis: Weight values in %@", [Utility sharedInstance].settings.weight];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(array == nil || array.count < 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[Utility sharedInstance] showAlert:@"No data" message:@"No data found"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
