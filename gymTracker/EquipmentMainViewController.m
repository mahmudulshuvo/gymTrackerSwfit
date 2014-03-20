#import "EquipmentMainViewController.h"
#import "EquipmentDetailsViewController.h"
#import "EquipmentTableCell.h"
#import "FMDBDataAccess.h"
#import "Utility.h"

@interface EquipmentMainViewController ()

@end

@implementation EquipmentMainViewController

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
    
    utility.equipmentsList = [FMDBDataAccess getEquipments];
    
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
    static NSString *CellIdentifier = @"EquipmentTableCell";
    EquipmentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[EquipmentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Equipment *equipment = [utility.equipmentsList objectAtIndex:[indexPath row]];
    cell.equipmentNameLabel.text = [NSString stringWithFormat:@"%@", equipment.equipmentName];
    
    if(equipment.imageName == nil || [equipment.imageName isEqualToString:@"(null)"])
        [cell.equipmentImageView setImage:utility.noImage];
    else
        [cell.equipmentImageView setImage:[UIImage imageNamed:equipment.imageName]];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EquipmentDetailsNewView"])
    {
        EquipmentDetailsViewController *equipmentDetailsView = [segue destinationViewController];
        equipmentDetailsView.selectedEquipment = nil;
        equipmentDetailsView.title = @"New Equipment";
    }
    
    else if([segue.identifier isEqualToString:@"EquipmentDetailsEditView"])
    {
        EquipmentDetailsViewController *equipmentDetailsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = [myIndexPath row];
        equipmentDetailsView.selectedEquipment = utility.equipmentsList[row];
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
        Equipment *equipment = [utility.equipmentsList objectAtIndex:[indexPath row]];
        
        if(equipment.imageName != nil)
        {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", utility.documentDir, equipment.imageName];
            NSFileManager *fileManager = [NSFileManager defaultManager];
        
            if ([fileManager fileExistsAtPath:filePath] == YES)
            {
                [fileManager removeItemAtPath:filePath error: NULL];
            }
        }
        
        [FMDBDataAccess deleteEquipment:equipment];
        
        [utility.equipmentsList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
