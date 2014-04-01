#import "DateWiseMeasurementViewController.h"
#import "Utility.h"
#import "DateWiseMeasurementReportCell.h"
#import "FMDBDataAccess.h"
#import "MeasurementHistoryDetailsViewController.h"
#import "MeasurementHistoryNewViewController.h"

@interface DateWiseMeasurementViewController ()

@end

@implementation DateWiseMeasurementViewController

NSString *strMeasurementLabelValue;
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.measurementHistoryList = [FMDBDataAccess getMeasurementHistoryByDate:self.strSelectedDate];
    
    [self.tableView reloadData];
    
    strMeasurementLabelValue = utility.settings.measurement;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.measurementHistoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DateWiseMeasurementReportCell";
    DateWiseMeasurementReportCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[DateWiseMeasurementReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MeasurementHistory *measurementHistory = [self.measurementHistoryList objectAtIndex:[indexPath row]];
    cell.measurementNameLabel.text = measurementHistory.measurementName;
    cell.sizeLabel.text = [NSString stringWithFormat:@"%@ %@", measurementHistory.size, strMeasurementLabelValue];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [FMDBDataAccess deleteMeasurementHistory:[self.measurementHistoryList objectAtIndex:[indexPath row]]];
        
        [self.measurementHistoryList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EditMeasurementView"])
    {
        MeasurementHistoryDetailsViewController *measurementHistoryDetailsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = [myIndexPath row];
        measurementHistoryDetailsView.measurementHistory = self.measurementHistoryList[row];
        measurementHistoryDetailsView.title = measurementHistoryDetailsView.measurementHistory.measurementName;
        measurementHistoryDetailsView.parentControllerName = @"DateWiseMeasurementViewController";
    }
    else if([segue.identifier isEqualToString:@"MeasurementView"])
    {
        MeasurementHistoryNewViewController *measurementController = [segue destinationViewController];
        measurementController.measurementHistoryList = self.measurementHistoryList;
        measurementController.strSelectedDate = self.strSelectedDate;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"MeasurementView"])
    {
        if(self.measurementHistoryList.count == utility.measurementsList.count)
        {
            [Utility showAlert:@"Info" message:@"No more item(s) to be added for workout"];
            return NO;
        }
    }
    return YES;
}

@end
