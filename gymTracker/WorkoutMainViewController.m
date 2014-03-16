#import "WorkoutMainViewController.h"
#import "WorkoutTableCell.h"
#import "Equipment.h"
#import "WorkoutDetailsViewController.h"
#import "Utility.h"
#import "FMDBDataAccess.h"

@interface WorkoutMainViewController ()

@end

@implementation WorkoutMainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
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
    
    self.equipmentsList = [FMDBDataAccess getEquipments];
    
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
    return self.equipmentsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutTableCell";
    WorkoutTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[WorkoutTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Equipment *equipment = [self.equipmentsList objectAtIndex:[indexPath row]];
    cell.equipmentNameLabel.text = equipment.equipmentName;
    UIImage *image;
    if(equipment.imageName == nil || [equipment.imageName isEqualToString:@"(null)"])
        image = [UIImage imageNamed:@"no_image.jpg"];
    else
        image = [UIImage imageNamed:equipment.imageName];
   
    [cell.equipmentImageView setImage:image];
    
    return cell;

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WorkOutDetails"])
    {
        WorkoutDetailsViewController *workoutDetailsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = [myIndexPath row];
        workoutDetailsView.selectedEquipment = self.equipmentsList[row];
    }
}

@end
