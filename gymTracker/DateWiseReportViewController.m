#import "DateWiseReportViewController.h"
#import "Utility.h"
#import "Workout.h"
#import "Equipment.h"
#import "DateWiseReportCell.h"
#import "FMDBDataAccess.h"
#import "WorkoutDetailsViewController.h"

@interface DateWiseReportViewController ()

@end

@implementation DateWiseReportViewController

int sets;
NSString *strWeightLabelValue;
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
    
    sets = utility.settings.sets.intValue;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.workoutList = [FMDBDataAccess getWorkoutsByDate:self.strSelectedDate];
    
    [self.tableView reloadData];
    
    if(self.workoutList.count < 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [Utility showAlert:@"No Data" message:@"No data found"];
        return;
    }
    
    strWeightLabelValue = utility.settings.weight;
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
    cell.set1ValueLabel.text = [NSString stringWithFormat:@"%@ %@", workout.workoutSet1, strWeightLabelValue];
    cell.set2ValueLabel.text = [NSString stringWithFormat:@"%@ %@", workout.workoutSet2, strWeightLabelValue];
    cell.set3ValueLabel.text = [NSString stringWithFormat:@"%@ %@", workout.workoutSet3, strWeightLabelValue];
    cell.set4ValueLabel.text = [NSString stringWithFormat:@"%@ %@", workout.workoutSet4, strWeightLabelValue];
    cell.set5ValueLabel.text = [NSString stringWithFormat:@"%@ %@", workout.workoutSet5, strWeightLabelValue];
    
    if(sets == 2)
    {
        cell.set3Label.hidden = YES;
        cell.set3ValueLabel.hidden = YES;
        
        cell.set4Label.hidden = YES;
        cell.set4ValueLabel.hidden = YES;
        
        cell.set5Label.hidden = YES;
        cell.set5ValueLabel.hidden = YES;
    }
    else if(sets == 3)
    {
        cell.set3Label.hidden = NO;
        cell.set3ValueLabel.hidden = NO;
        
        cell.set4Label.hidden = YES;
        cell.set4ValueLabel.hidden = YES;
        
        cell.set5Label.hidden = YES;
        cell.set5ValueLabel.hidden = YES;
    }
    else if(sets == 4)
    {
        cell.set4Label.hidden = NO;
        cell.set4ValueLabel.hidden = NO;
        
        cell.set5Label.hidden = YES;
        cell.set5ValueLabel.hidden = YES;
    }
    else if(sets == 5)
    {
        cell.set4Label.hidden = NO;
        cell.set4ValueLabel.hidden = NO;
        
        cell.set5Label.hidden = NO;
        cell.set5ValueLabel.hidden = NO;
    }
    if(workout.equipmentImageName == nil || [workout.equipmentImageName isEqualToString:@"(null)"])
        [cell.equipmentImageView setImage:utility.noImage];
    else
        [cell.equipmentImageView setImage:[UIImage imageNamed:workout.equipmentImageName]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EditWorkOutDetails"])
    {
        WorkoutDetailsViewController *workoutDetailsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = [myIndexPath row];
        workoutDetailsView.workout = self.workoutList[row];
        workoutDetailsView.title = workoutDetailsView.workout.equipmentName;
        workoutDetailsView.parentControllerName = @"report";
    }
}

@end
