#import "EquipmentMainViewController.h"
#import "AppDelegate.h"
#import "EquipmentDetailsViewController.h"
#import "EquipmentTableCell.h"

@interface EquipmentMainViewController ()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end

@implementation EquipmentMainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Equipment"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"equipmentName" ascending:YES], nil];
    
    self.equipmentsList = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    
    [self.tableView reloadData];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
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
    static NSString *CellIdentifier = @"EquipmentTableCell";
    EquipmentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[EquipmentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Equipment *equipment = [self.equipmentsList objectAtIndex:[indexPath row]];
    cell.equipmentNameLabel.text = [NSString stringWithFormat:@"%@", equipment.equipmentName];
    UIImage *image = [UIImage imageNamed:equipment.equipmentName];
    [cell.imageView setImage:image];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EquipmentDetailsNewView"])
    {
        EquipmentDetailsViewController *equipmentDetailsView = [segue destinationViewController];
        equipmentDetailsView.selectedEquipment = nil;
        equipmentDetailsView.equipments = self.equipmentsList;
        equipmentDetailsView.title = @"New Equipment";
    }
    
    else if([segue.identifier isEqualToString:@"EquipmentDetailsEditView"])
    {
        EquipmentDetailsViewController *equipmentDetailsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        int row = [myIndexPath row];
        equipmentDetailsView.selectedEquipment = self.equipmentsList[row];
        equipmentDetailsView.equipments = self.equipmentsList;
        equipmentDetailsView.title = @"Edit Equipment";
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
        Equipment *equipment = [self.equipmentsList objectAtIndex:[indexPath row]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDir, equipment.imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:filePath] == YES)
        {
            [fileManager removeItemAtPath:filePath error: NULL];
        }
        
        [self.managedObjectContext deleteObject:equipment];
        [self.managedObjectContext save:nil];
        
        [self.equipmentsList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
