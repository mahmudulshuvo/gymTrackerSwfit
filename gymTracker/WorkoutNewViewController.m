#import "WorkoutNewViewController.h"
#import "WorkoutTableCell.h"
#import "Equipment.h"
#import "WorkoutDetailsViewController.h"
#import "Utility.h"
#import "FMDBDataAccess.h"

@interface WorkoutNewViewController ()

@end

@implementation WorkoutNewViewController

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
    return utility.equipmentsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutTableCell";
    WorkoutTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[WorkoutTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Equipment *equipment = [utility.equipmentsList objectAtIndex:[indexPath row]];
    cell.equipmentNameLabel.text = equipment.equipmentName;
    
    if(equipment.imageName == nil || [equipment.imageName isEqualToString:@"(null)"])
        [cell.equipmentImageView setImage:utility.noImage];
    else
        [cell.equipmentImageView setImage:[UIImage imageNamed:equipment.imageName]];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewWorkoutView"])
    {
        WorkoutDetailsViewController *workoutDetailsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = [myIndexPath row];
        workoutDetailsView.selectedEquipment = utility.equipmentsList[row];
        workoutDetailsView.title = workoutDetailsView.selectedEquipment.equipmentName;
        workoutDetailsView.strSelectedDate = self.strSelectedDate;
        workoutDetailsView.parentControllerName = @"WorkoutNewViewController";
    }
}

@end
