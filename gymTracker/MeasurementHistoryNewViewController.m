#import "MeasurementHistoryNewViewController.h"
#import "MeasurementHistoryDetailsViewController.h"
#import "Utility.h"
#import "FMDBDataAccess.h"

@interface MeasurementHistoryNewViewController ()

@end

@implementation MeasurementHistoryNewViewController

Utility *utility;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        utility = [Utility sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.measurementsWithNoHistory = [NSMutableArray new];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.measurementsWithNoHistory removeAllObjects];
    
    int measurementsLength = utility.measurementsList.count;
    int measurementHistoriesLength = self.measurementHistoryList.count;
    
    if(measurementHistoriesLength > 0)
    {
        for(int i=0;i<measurementsLength;i++)
        {
            Measurement *measurement = utility.measurementsList[i];
            BOOL shouldAdd = YES;
            for(int j=0;j<measurementHistoriesLength;j++)
            {
                MeasurementHistory *measurementHistory = self.measurementHistoryList[j];
                if([measurement.measurementName isEqualToString:measurementHistory.measurementName])
                {
                    shouldAdd = NO;
                    break;
                }
            }
            if(shouldAdd)
                [self.measurementsWithNoHistory addObject:measurement];
        }
    }
    else
    {
        [self.measurementsWithNoHistory addObjectsFromArray:utility.measurementsList];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.measurementsWithNoHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MeasurementNewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Measurement *measurement = [self.measurementsWithNoHistory objectAtIndex:[indexPath row]];
    cell.textLabel.text = measurement.measurementName;
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewMeasurementView"])
    {
        MeasurementHistoryDetailsViewController *measurementHistoryDetailsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = [myIndexPath row];
        measurementHistoryDetailsView.selectedMeasurement = self.measurementsWithNoHistory[row];
        measurementHistoryDetailsView.title = measurementHistoryDetailsView.selectedMeasurement.measurementName;
        measurementHistoryDetailsView.strSelectedDate = self.strSelectedDate;
        measurementHistoryDetailsView.parentControllerName = @"MeasurementHistoryNewViewController";
    }
}

@end
