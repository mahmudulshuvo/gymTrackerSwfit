#import "DateWiseReportViewController.h"
#import "Utility.h"
#import "Workout.h"
#import "Equipment.h"
#import "DateWiseReportCell.h"
#import "FMDBDataAccess.h"
#import "WorkoutDetailsViewController.h"
#import "WorkoutNewViewController.h"

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
    cell.set1ValueLabel.text = [NSString stringWithFormat:@"%@", workout.workoutSet1];
    cell.set2ValueLabel.text = [NSString stringWithFormat:@"%@", workout.workoutSet2];
    cell.set3ValueLabel.text = [NSString stringWithFormat:@"%@", workout.workoutSet3];
    cell.set4ValueLabel.text = [NSString stringWithFormat:@"%@", workout.workoutSet4];
    cell.set5ValueLabel.text = [NSString stringWithFormat:@"%@", workout.workoutSet5];
    
    cell.weightValueLabel1.text = strWeightLabelValue;
    cell.weightValueLabel2.text = strWeightLabelValue;
    cell.weightValueLabel3.text = strWeightLabelValue;
    cell.weightValueLabel4.text = strWeightLabelValue;
    cell.weightValueLabel5.text = strWeightLabelValue;
    
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
        [FMDBDataAccess deleteWorkout:[self.workoutList objectAtIndex:[indexPath row]]];
        
        [self.workoutList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EditWorkoutView"])
    {
        WorkoutDetailsViewController *workoutDetailsView = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = [myIndexPath row];
        workoutDetailsView.workout = self.workoutList[row];
        workoutDetailsView.title = workoutDetailsView.workout.equipmentName;
        workoutDetailsView.parentControllerName = @"DateWiseReportViewController";
    }
    else if([segue.identifier isEqualToString:@"EquipmentView"])
    {
        WorkoutNewViewController *workoutController = [segue destinationViewController];
        workoutController.workoutList = self.workoutList;
        workoutController.strSelectedDate = self.strSelectedDate;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"EquipmentView"])
    {
        if(self.workoutList.count == utility.equipmentsList.count)
        {
            [Utility showAlert:@"Info" message:@"No more item(s) to be added for workout"];
            return NO;
        }
    }
    return YES;
}

@end
