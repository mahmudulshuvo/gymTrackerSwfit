#import "MeasurementsTableViewController.h"
#import "MeasurementsViewController.h"
#import "FMDBDataAccess.h"
#import "Utility.h"
#import "Measurement.h"

@interface MeasurementsTableViewController ()

@end

@implementation MeasurementsTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    utility.measurementsList = [FMDBDataAccess getMeasurements];
    
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
    return utility.measurementsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Measurement *measurement = [utility.measurementsList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", measurement.measurementName];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewMeasurement"])
    {
        MeasurementsViewController *measurementsView = [segue destinationViewController];
        measurementsView.selectedMeasurement = nil;
        measurementsView.title = @"New Measurement";
    }
    
    else if([segue.identifier isEqualToString:@"EditMeasurement"])
    {
        MeasurementsViewController *measurementsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = [myIndexPath row];
        measurementsView.selectedMeasurement = utility.measurementsList[row];
        measurementsView.title = @"Edit Measurement";
    }
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
        [FMDBDataAccess deleteMeasurement:[utility.measurementsList objectAtIndex:[indexPath row]]];
        
        [utility.measurementsList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
