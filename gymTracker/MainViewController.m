#import "MainViewController.h"
#import "Utility.h"

@interface MainViewController ()

@property (nonatomic, readonly) Settings *settings;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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

- (IBAction)cameraBtn:(id)sender
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

- (IBAction)browseBtn:(id)sender
{
    existingImagePickerController = [[UIImagePickerController alloc] init];
    existingImagePickerController.delegate = self;
    [existingImagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:existingImagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
}

@end
