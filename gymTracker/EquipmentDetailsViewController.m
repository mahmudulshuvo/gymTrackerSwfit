#import "EquipmentDetailsViewController.h"
#import "Utility.h"
#import "AppDelegate.h"

@interface EquipmentDetailsViewController ()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end

@implementation EquipmentDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.equipmentNameTextField.delegate = self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtn:(id)sender
{
    NSString *strEquipmentName = [self.equipmentNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if(strEquipmentName.length == 0)
    {
        [Utility showAlert:@"Error" message:@"Equipment name is required"];
        return;
    }
    
    if(_selectedEquipment == nil)
    {
        int totalEquipmentsCount = self.equipments.count;
        for(int i=0;i<totalEquipmentsCount;i++)
        {
            Equipment *equipmentFromArray = [self.equipments objectAtIndex:i];
            if([[equipmentFromArray.equipmentName lowercaseString] isEqualToString:[strEquipmentName lowercaseString]])
            {
                [Utility showAlert:@"Error" message:@"The specified shop name already exists"];
                return;
            }
        }

        _selectedEquipment = [NSEntityDescription insertNewObjectForEntityForName:@"Equipment" inManagedObjectContext:self.managedObjectContext];
    }
    
    _selectedEquipment.equipmentName = strEquipmentName;
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unable to save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)takePhoto:(id)sender
{
    cameraPickerController = [[UIImagePickerController alloc] init];
    cameraPickerController.delegate = self;
    @try
    {
        [cameraPickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:cameraPickerController animated:YES completion:NULL];
    }
    @catch(NSException *exception)
    {
        [Utility showAlert:@"Error" message:[NSString stringWithFormat:@"Unable to access the camera"]];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.imageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
}

/*- (IBAction)browseBtn:(id)sender
{
    existingImagePickerController = [[UIImagePickerController alloc] init];
    existingImagePickerController.delegate = self;
    [existingImagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:existingImagePickerController animated:YES completion:NULL];
}*/

@end
