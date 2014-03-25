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
    
    self.equipmentsWithNoWorkout = [NSMutableArray new];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.equipmentsWithNoWorkout removeAllObjects];
    
    int equipmentsLength = utility.equipmentsList.count;
    int workoutsLength = self.workoutList.count;
    
    if(workoutsLength > 0)
    {
        for(int i=0;i<equipmentsLength;i++)
        {
            Equipment *equipment = utility.equipmentsList[i];
            BOOL shouldAdd = YES;
            for(int j=0;j<workoutsLength;j++)
            {
                Workout *workout = self.workoutList[j];
                if([equipment.equipmentName isEqualToString:workout.equipmentName])
                {
                    shouldAdd = NO;
                    break;
                }
            }
            if(shouldAdd)
                [self.equipmentsWithNoWorkout addObject:equipment];
        }
    }
    else
    {
        [self.equipmentsWithNoWorkout addObjectsFromArray:utility.equipmentsList];
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
    return self.equipmentsWithNoWorkout.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutTableCell";
    WorkoutTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[WorkoutTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Equipment *equipment = [self.equipmentsWithNoWorkout objectAtIndex:[indexPath row]];
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
        workoutDetailsView.selectedEquipment = self.equipmentsWithNoWorkout[row];
        workoutDetailsView.title = workoutDetailsView.selectedEquipment.equipmentName;
        workoutDetailsView.strSelectedDate = self.strSelectedDate;
        workoutDetailsView.parentControllerName = @"WorkoutNewViewController";
    }
}

@end
