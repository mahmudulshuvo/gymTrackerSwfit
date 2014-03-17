#import "EquipmentMainViewController.h"
#import "EquipmentDetailsViewController.h"
#import "EquipmentTableCell.h"
#import "FMDBDataAccess.h"
#import "Utility.h"

@interface EquipmentMainViewController ()

@end

@implementation EquipmentMainViewController

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
    static NSString *CellIdentifier = @"EquipmentTableCell";
    EquipmentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[EquipmentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Equipment *equipment = [self.equipmentsList objectAtIndex:[indexPath row]];
    cell.equipmentNameLabel.text = [NSString stringWithFormat:@"%@", equipment.equipmentName];
    
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
        NSInteger row = [myIndexPath row];
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
        
        if(equipment.imageName != nil)
        {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", [Utility sharedInstance].documentDir, equipment.imageName];
            NSFileManager *fileManager = [NSFileManager defaultManager];
        
            if ([fileManager fileExistsAtPath:filePath] == YES)
            {
                [fileManager removeItemAtPath:filePath error: NULL];
            }
        }
        
        [FMDBDataAccess deleteEquipment:equipment];
        
        [self.equipmentsList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
