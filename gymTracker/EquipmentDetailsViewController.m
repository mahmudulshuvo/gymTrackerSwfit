//
//  EquipmentDetailsViewController.m
//  gymTracker
//
//  Created by Third Bit on 3/5/14.
//  Copyright (c) 2014 Third Bit. All rights reserved.
//

#import "EquipmentDetailsViewController.h"
#import "Utility.h"

@interface EquipmentDetailsViewController ()

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtn:(id)sender
{
    
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
