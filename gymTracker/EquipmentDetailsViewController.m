#import "EquipmentDetailsViewController.h"
#import "Utility.h"
#import "FMDBDataAccess.h"
#import "Measurement.h"

@interface EquipmentDetailsViewController ()

@end

@implementation EquipmentDetailsViewController

bool hasChosenImage;
Utility *utility;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        utility = [Utility sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hasChosenImage = false;
	self.equipmentNameTextField.delegate = self;
    
    self.bodyPartsPickerView.delegate = self;
    self.bodyPartsPickerView.dataSource = self;
    
    if(_selectedEquipment != nil)
    {
        self.equipmentNameTextField.text = [NSString stringWithFormat:@"%@", _selectedEquipment.equipmentName];
        if(_selectedEquipment.imageName != nil && ![_selectedEquipment.imageName isEqualToString:@"(null)"])
        {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", utility.documentDir, _selectedEquipment.imageName];
            [self.equipmentImageView setImage:[UIImage imageWithContentsOfFile:filePath]];
        }
        else
        {
            [self.equipmentImageView setImage:utility.noImage];
        }
    }
    else
    {
        [self.equipmentImageView setImage:utility.noImage];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.bodyPartsPickerView reloadAllComponents];
    
    if(_selectedEquipment == nil) return;
    
    NSUInteger totalMeasurementsCount = utility.measurementsList.count;
    for(int i=0;i<totalMeasurementsCount;i++)
    {
        Measurement *measurementFromArray = [utility.measurementsList objectAtIndex:i];
        if(measurementFromArray.id == _selectedEquipment.measurementId)
        {
            [self.bodyPartsPickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
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
    if(utility.measurementsList.count < 1)
    {
        [Utility showAlert:@"Info" message:@"Please add a body part from Measure section"];
        return;
    }
    
    NSString *strEquipmentName = [self.equipmentNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if(strEquipmentName.length == 0)
    {
        [Utility showAlert:@"Error" message:@"Equipment name is required"];
        return;
    }
    
    BOOL newEntry = NO;
    
    if(_selectedEquipment == nil)
    {
        NSUInteger totalEquipmentsCount = utility.equipmentsList.count;
        for(int i=0;i<totalEquipmentsCount;i++)
        {
            Equipment *equipmentFromArray = [utility.equipmentsList objectAtIndex:i];
            if([[equipmentFromArray.equipmentName lowercaseString] isEqualToString:[strEquipmentName lowercaseString]])
            {
                [Utility showAlert:@"Error" message:@"The specified Equipment name already exists"];
                return;
            }
        }

        _selectedEquipment = [Equipment new];
        if(self.equipmentImageView.image != utility.noImage)
            _selectedEquipment.imageName = [NSString stringWithFormat:@"%.0f.png", [NSDate date].timeIntervalSince1970];
        
        newEntry = YES;
    }
    
    _selectedEquipment.equipmentName = strEquipmentName;
    
    NSInteger row = [self.bodyPartsPickerView selectedRowInComponent:0];
    _selectedEquipment.measurementId = ((Measurement *)utility.measurementsList[row]).id;
    
    if(hasChosenImage)
    {
        [[NSUserDefaults standardUserDefaults]setValue:_selectedEquipment.imageName forKey:@"imageName"];
    
        NSString *savedImagePath = [utility.documentDir stringByAppendingPathComponent:_selectedEquipment.imageName];
        UIImage *image = self.equipmentImageView.image;
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
    }
    
    if(newEntry)
        [FMDBDataAccess createEquipment:_selectedEquipment];
    else
        [FMDBDataAccess updateEquipment:_selectedEquipment];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)takePhoto:(id)sender
{
    cameraPickerController = [UIImagePickerController new];
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
    [self.equipmentImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    hasChosenImage = true;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Measurement *measurement = [utility.measurementsList objectAtIndex:row];
    return measurement.measurementName;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return utility.measurementsList.count;
}

/*- (IBAction)browseBtn:(id)sender
{
    existingImagePickerController = [UIImagePickerController new];
    existingImagePickerController.delegate = self;
    [existingImagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:existingImagePickerController animated:YES completion:NULL];
}*/

@end
