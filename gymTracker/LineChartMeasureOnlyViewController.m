#import "LineChartMeasureOnlyViewController.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "PNColor.h"
#import "FMDBDataAccess.h"
#import "Utility.h"
#import "LineChartVO.h"

@interface LineChartMeasureOnlyViewController ()

@end

@implementation LineChartMeasureOnlyViewController

NSArray *measurementDBDataArray;
NSMutableArray *measurementChartXLabels;
NSMutableArray *measurementChartDatas;
PNLineChartData *measurementData;
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
    
    measurementDBDataArray = [FMDBDataAccess getMeasurementHistoryByMeasurementId:self.measurementId fromDate:[utility.dbDateFormat stringFromDate:self.selectedFromDate] toDate:[utility.dbDateFormat stringFromDate:self.selectedToDate]];
    
    if(measurementDBDataArray == nil || measurementDBDataArray.count < 1)
    {
        self.legendImageView.hidden = YES;
        [Utility showAlert:@"Info" message:@"No data found"];
        return;
    }
    
    int arrayCount = measurementDBDataArray.count;
    measurementChartXLabels = [NSMutableArray new];
    measurementChartDatas = [NSMutableArray new];
    if(arrayCount < 19)
    {
        for(int i=0;i<arrayCount;i++)
        {
            LineChartVO *lineChartVO = measurementDBDataArray[i];
            [measurementChartXLabels addObject:[lineChartVO.date substringWithRange:NSMakeRange(8, 2)]];
            [measurementChartDatas addObject:lineChartVO.value];
        }
    }
    else
    {
        for(int i=0;i<arrayCount;i++)
        {
            LineChartVO *lineChartVO = measurementDBDataArray[i];
            [measurementChartXLabels addObject:@""];
            [measurementChartDatas addObject:lineChartVO.value];
        }
    }
    
    NSDate *dbFromDate = [utility.dbDateFormat dateFromString:((LineChartVO *)measurementDBDataArray[0]).date];
    if(arrayCount > 1)
    {
        NSDate *dbToDate = [utility.dbDateFormat dateFromString:((LineChartVO *)measurementDBDataArray[measurementDBDataArray.count - 1]).date];
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
    
    [self.lineChart setXLabels:measurementChartXLabels];
    
    measurementData = [PNLineChartData new];
    measurementData.color = PNFreshGreen;
    measurementData.itemCount = measurementChartXLabels.count;
    measurementData.getData = ^(NSUInteger index)
    {
        return [PNLineChartDataItem dataItemWithY:[[measurementChartDatas objectAtIndex:index] floatValue]];
    };
    
    self.lineChart.chartData = @[measurementData];
    [self.lineChart strokeChart];
    
    self.legendImageView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(measurementDBDataArray == nil || measurementDBDataArray.count < 1)
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
