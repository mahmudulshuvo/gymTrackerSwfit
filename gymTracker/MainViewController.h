#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *cameraPickerController;
    UIImagePickerController *existingImagePickerController;
    UIImage *image;
    IBOutlet UIImageView *imageView;
}

- (IBAction)cameraBtn:(id)sender;
- (IBAction)browseBtn:(id)sender;

@end
