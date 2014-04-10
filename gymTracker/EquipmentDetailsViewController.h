#import <UIKit/UIKit.h>
#import "Equipment.h"

@interface EquipmentDetailsViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIImagePickerController *cameraPickerController;
}

@property (strong, nonatomic) IBOutlet UIImageView *equipmentImageView;

@property (strong, nonatomic) IBOutlet UITextField *equipmentNameTextField;

@property (retain, nonatomic) Equipment *selectedEquipment;

@property (strong, nonatomic) IBOutlet UIPickerView *bodyPartsPickerView;

- (IBAction)saveBtn:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
