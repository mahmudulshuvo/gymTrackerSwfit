#import "DateWiseReportViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "Workout.h"
#import "Equipment.h"
#import "DateWiseReportCell.h"
#import "FMDBDataAccess.h"

@interface DateWiseReportViewController ()

@end

@implementation DateWiseReportViewController

NSString *weightLabelValue;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    weightLabelValue = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).settings.weight;
    self.workoutList = [FMDBDataAccess getWorkoutsByDate:self.strSelectedDate];
    
    [self.tableView reloadData];
    
    if(self.workoutList.count < 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [Utility showAlert:@"No Data" message:@"No data found"];
        return;
    }
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
    return self.workoutList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DateWiseReportCell";
    DateWiseReportCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[DateWiseReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Workout *workout = [self.workoutList objectAtIndex:[indexPath row]];
    cell.equipmentNameLabel.text = workout.equipmentName;
    cell.set1ValueLabel.text = [NSString stringWithFormat:@"%@ %@", workout.workoutSet1, weightLabelValue];
    cell.set2ValueLabel.text = [NSString stringWithFormat:@"%@ %@", workout.workoutSet2, weightLabelValue];
    cell.set3ValueLabel.text = [NSString stringWithFormat:@"%@ %@", workout.workoutSet3, weightLabelValue];
    UIImage *image;
    if(workout.equipmentImageName == nil || [workout.equipmentImageName isEqualToString:@"(null)"])
        image = [UIImage imageNamed:@"no_image.jpg"];
    else
        image = [UIImage imageNamed:workout.equipmentImageName];
    [cell.equipmentImageView setImage:image];
    
    return cell;
}

@end