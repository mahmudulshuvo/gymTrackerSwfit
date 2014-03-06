#import <UIKit/UIKit.h>
#import "Equipment.h"

@interface EquipmentDetailsViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    UIImagePickerController *cameraPickerController;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UITextField *equipmentNameTextField;

@property (retain, nonatomic) NSMutableArray *equipments;

@property (retain, nonatomic) Equipment *selectedEquipment;

- (IBAction)saveBtn:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
